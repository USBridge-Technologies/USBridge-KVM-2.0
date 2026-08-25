# REST API Reference

Everything the desktop/mobile client, the on-device UI, and Starlark scripts do to the appliance goes through one HTTP API. This page is the complete endpoint reference — organized by subsystem, with request/response shapes for every route the appliance actually serves.

For automation-specific surfaces, see the dedicated pages instead of this one: [Starlark Scripting Reference](../3-bios-in-terminal/scripting-automation.md) and [AI Agent Integration (MCP)](../3-bios-in-terminal/mcp-ai-agents.md).

---

## 1. Base URL & Response Shape

* **Plain HTTP:** `http://<device-ip>:8080`
* **TLS:** `https://<device-ip>:9443` (self-signed by default; a real Tailscale-issued certificate when the device is on a tailnet) — needed for a browser page served over `https://` to `fetch()` the API without hitting mixed-content blocking.

Both serve the identical API. Every endpoint returns this envelope, except WebSocket messages and the raw file download from `/api/backup/get_file`:

```json
{ "success": true, "message": "...", "data": { } }
```

---

## 2. Authentication

Every request **except** `GET /api/healthz`, `POST /api/auth/sync`, and `POST /api/mcp` called from `127.0.0.1` must carry:

| Header | Value |
| :--- | :--- |
| `X-Auth-Timestamp` | Unix timestamp (seconds); rejected if more than 60s off from the appliance's clock. |
| `X-Auth-Signature` | `hex(HMAC_SHA256(SHA256(api_secret), METHOD + REQUEST_URI + TIMESTAMP + BODY))` |

`api_secret` is the appliance's master key — generated on first boot and shown as the pairing QR code/token on the front panel (**Settings → Authentication → Show Master Key**; see [Initial Setup & Client Pairing](../1-getting-started/initial-setup.md)). `POST`/`PUT`/`PATCH` requests must declare `Content-Type: application/json` or `multipart/form-data`.

> [!NOTE]
> **The MCP endpoint is the one exception.** `POST /api/mcp` skips signature verification entirely when the caller connects on `127.0.0.1` — meant for a local AI agent or an SSH-tunneled one. Reached over a LAN or Tailscale IP, it's signed exactly like every other endpoint. See [AI Agent Integration (MCP)](../3-bios-in-terminal/mcp-ai-agents.md#2-authentication-model) for the full breakdown.

WebSocket endpoints (`/api/mouse/ws`, `/api/gamepad/ws`) are signed on the upgrade `GET` request itself, before the connection switches protocols.

---

## 3. Pairing, Sync & Moonlight

| Method & Path | Body | Notes |
| :--- | :--- | :--- |
| `POST /api/auth/sync` | `{"payload": "<AES-GCM b64>", "iv": "<b64>", "timestamp": N}` | First-contact pairing request (from the onboard QR code) — self-authenticated by AES-GCM encryption, not HMAC. Decrypted payload can carry a Moonlight PIN, a Tailscale auth key, and a hostname. |
| `POST /api/moonlight/pin` | `{"pin": "1234"}` | Relays a Moonlight pairing PIN to Sunshine's local pairing API. |
| `GET /api/auth/tailscale/status` | — | Current Tailscale backend/login/IP state. |
| `POST /api/auth/tailscale/register` | `{"device_token", "auth_key", "hostname"}` | `device_token` must match the appliance's own API secret; empty `auth_key` requests an `AuthURL` for browser-based login instead of key-based registration. |

---

## 4. USB Gadget / Device Management

| Method & Path | Body | Notes |
| :--- | :--- | :--- |
| `POST /api/device/start` | Single device object, an array of devices, or `{"devices": [...], "merge": bool, ...cache options}` | Attaches drive/keyboard/mouse/MTP/RNDIS devices. `merge: true` adds to what's already attached instead of replacing it. Returns `409` if a Starlark script currently owns the gadget. |
| `POST /api/device/stop` | — | Detaches everything currently attached. |
| `GET /api/device/info` | — | Attached devices + mount-in-progress state. |
| `GET /api/device/status` | — | Mountdrive subsystem availability (keyboard/RNDIS support, connected devices). |
| `GET /api/device/lun_flags` | — | Diagnostic dump of raw USB mass-storage LUN flags per attached drive. |

> [!IMPORTANT]
> There is no `/api/video/start` or `/api/video/stop` endpoint. Streaming is driven by Moonlight/Sunshine pairing, not a direct call on this API — if you've seen those two mentioned elsewhere, that's stale.

---

## 5. Input Control

| Method & Path | Body | Notes |
| :--- | :--- | :--- |
| `POST /api/keyboard` | `{"action": "key\|combo\|text", "key_code", "modifiers", "text"}` | USB HID codes; `modifiers` bitmask 1=Ctrl/2=Shift/4=Alt/8=Meta; `text` capped at 1000 chars. |
| `POST /api/mouse` | `{"action": "move\|click\|scroll\|action\|touch\|touch_position\|absolute_event", "dx", "dy", "button", "scroll", "x", "y", "tip", "button_state"}` | `button`: 1=left/2=right/3=middle. |
| `WS /api/mouse/ws` | JSON message per event, mouse **and** keyboard actions combined | Low-latency interactive control; avoids one REST round-trip per event. |
| `WS /api/gamepad/ws` | `{"buttons", "lx", "ly", "rx", "ry", "lt", "rt"}` at up to ~60 Hz | Raw 8-byte HID gamepad report fields; see [Gamepad Emulation](../2-kvm-vkm/gamepad.md). |

---

## 6. Screen (OCR)

| Method & Path | Notes |
| :--- | :--- |
| `GET /api/screen?format=screen.v1` | Current BIOS-in-Terminal OCR snapshot. `format` optional; `screen.v1` is the structured text-run + color-segmentation shape used by MCP's `screen.get`. |

---

## 7. Video & Audio

| Method & Path | Body | Notes |
| :--- | :--- | :--- |
| `GET /api/video/info?device=...` | — | Streaming state + a ready-to-use stream URL. |
| `GET /api/video/devices` | — | Available UVC capture devices. |
| `POST /api/video/set_device` | `{"device", "pixel_format"}` | Switches capture device/pixel format at runtime. |
| `GET /api/audio/info` | — | Streaming/mute state. |
| `GET /api/audio/devices` | — | Available capture devices. |
| `POST /api/audio/start` | `{"device_path"}` (optional) | Empty body uses the default device. |
| `POST /api/audio/stop` | — | |

---

## 8. Storage & Virtual Media

| Method & Path | Body | Notes |
| :--- | :--- | :--- |
| `GET /api/storage/status` | — | SD card + eMMC space, human-readable. |
| `GET /api/drives/local` | — | Locally staged ISO/IMG/VDI/VMDK files. |
| `POST /api/sources/validate` | `{"sources": ["file.iso", "nbd://..."]}` | Per-source validity check before mounting. |
| `GET /api/cache/status` | — | dm-cache (1 GB RAM hot cache in front of NBD drives) hit/miss counters. |
| `POST /api/iso/upload` | `multipart/form-data`, field `file`; optional `X-File-Size` header | Streamed upload, 50 GB cap, max 2 concurrent uploads. |
| `POST /api/iso/delete` | `{"filename"}` | |
| `GET /api/iso/space` | — | Free space on the ISO storage volume. |

---

## 9. Backup / Snapshots (Btrfs)

| Method & Path | Body | Notes |
| :--- | :--- | :--- |
| `POST /api/backup/get_versions` | `{"filename"}` | Every historical version of a file across snapshots. |
| `POST /api/backup/get_snapshots` | `{"from_date", "to_date", "limit"}` (all optional) | Snapshot list with Btrfs sizing and disk totals. |
| `POST /api/backup/get_file` | `{"snapshot", "file_path"}` | **Returns raw file bytes**, not JSON — `Content-Type` inferred from extension. |

See [Snapshots & State Management](../4-snapshots-state-management/snapshots-overview.md) for the underlying model.

---

## 10. Scripts (Starlark Automation)

| Method & Path | Body | Notes |
| :--- | :--- | :--- |
| `GET /api/scripts/list` | — | |
| `GET /api/scripts/read?path=...` | — | |
| `POST/PUT /api/scripts/write` | `{"path", "content"}` | `path` must resolve under `/mnt/sdcard/scripts` or `/mnt/emmc/scripts`. |
| `POST /api/scripts/run` | `{"path"}` | `409` if that path is already running. |
| `POST /api/scripts/stop` | `{"path"}` | Cancels at the next checkpoint, not instantly. |
| `GET /api/scripts/status` | — | |
| `GET /api/scripts/log?path=...&offset=N` | — | |
| `DELETE/POST /api/scripts/delete` | `{"path"}` | |

Full builtin-function reference: [Starlark Scripting Reference](../3-bios-in-terminal/scripting-automation.md).

---

## 11. Hardware (RNDIS, Power/Reset Panel)

| Method & Path | Body | Notes |
| :--- | :--- | :--- |
| `GET /api/rndis/info` | — | RNDIS (USB-Ethernet) bridge state. |
| `GET /api/pcpanel/leds` | — | Live POWER/HDD LED state from the [Power Management Module](../6-hardware-connectivity/power-management-module-control.md). |
| `POST /api/pcpanel/button` | `{"button": "power"\|"reset"}` | |

---

## 12. AI Agents (MCP)

| Method & Path | Notes |
| :--- | :--- |
| `POST /api/mcp` | JSON-RPC 2.0 (`tools/list`, `tools/call`, `resources/read`, …). Full tool catalog and auth model: [AI Agent Integration (MCP)](../3-bios-in-terminal/mcp-ai-agents.md). |

---

## 13. System

| Method & Path | Notes |
| :--- | :--- |
| `GET /api/healthz` | The only fully public, unauthenticated endpoint. |
