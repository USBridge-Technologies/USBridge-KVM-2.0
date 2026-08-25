# AI Agent Integration (Model Context Protocol)

USBridge exposes a built-in **[Model Context Protocol](https://modelcontextprotocol.io)** server directly from the appliance's own web service — there is no separate proxy process to install. Because BIOS-in-Terminal already turns the target's screen into structured, machine-readable text, an LLM agent gets the same full-machine access a human gets over SSH: it can read the console, navigate BIOS/UEFI menus, mount installation media, and run diagnostics entirely out-of-band, on real hardware, before any OS is even installed.

---

## 1. Endpoint & Protocol

* **Endpoint:** `POST http://<device-ip>:8080/api/mcp` (port `8080` is the appliance's default HTTP port; see the [REST API Reference](../10-developer-api/rest-api-reference.md)).
* **Wire format:** JSON-RPC 2.0 over plain HTTP POST — not the stdio or SSE transports some MCP clients expect by default. Clients that only speak stdio/SSE need a small local bridge; anything that can POST JSON and read a JSON response (including a short Python/curl loop) works directly.
* **Methods supported:** `initialize`, `tools/list`, `tools/call`, `resources/list`, `resources/read`.

```json
// tools/list
{"jsonrpc":"2.0","id":1,"method":"tools/list"}

// Enable keyboard
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"mountdrive.start","arguments":{"keyboard":true}}}

// Read the screen
{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"screen.get","arguments":{"format":"screen.v1"}}}
```

---

## 2. Authentication Model

MCP requests follow the same rule as every other endpoint on the appliance, split by **which IP you connect to**:

| Connecting to | Signature required? | Notes |
| :--- | :---: | :--- |
| `127.0.0.1` (loopback — an agent running on the device itself, or reached through an SSH tunnel) | **No** | Local-process-only by design; still rate-limited. |
| LAN IP / Tailscale IP | **Yes** | Same `X-Auth-Timestamp` + `X-Auth-Signature` HMAC-SHA256 scheme as the rest of the API — see the [REST API Reference](../10-developer-api/rest-api-reference.md). |

Reaching the endpoint over the LAN or a tailnet requires signing each request with the appliance's API secret, exactly like a script driving `/api/scripts/run` would. To skip that and get an unsigned local connection instead, you have two options:

### Option A: The Client App's MCP Proxy
The desktop/mobile client can run a small local HTTP server on your own workstation (`http://127.0.0.1:8765/api/mcp` by default) that signs and forwards every request to the device on your behalf — point your agent at that local address instead of the device's own IP, and you never have to implement the signing scheme yourself. This works over LAN or Tailscale, since the client (not the loopback exemption) is what's doing the authenticating.

### Option B: SSH Local Port Forwarding
The same [BIOS-in-Terminal SSH account](./technology-overview.md) also supports `ssh -L`, restricted specifically to forwarding into the device's own loopback:

```bash
ssh -L 127.0.0.1:8080:127.0.0.1:8080 <your_username>@<your_usbridge_ip_address>
```

With that tunnel open, `http://127.0.0.1:8080/api/mcp` on your machine lands on the device's loopback interface — the same no-signature fast path a locally-running agent gets. The SSH server only allows forwarding to `127.0.0.1`/`localhost`/`::1` on the device side, so this can't be used to reach anything else on the device's network.

MCP tooling can also be switched off entirely from the front panel: **Settings → Authentication → MCP**.

---

## 3. Self-Onboarding Resource

Before hand-writing tool calls, have the agent call `resources/read` on `usbridge://instructions` — it returns a Markdown cheat-sheet generated live by the appliance itself, including the **current list of ISO/IMG files actually available on the device** (so the agent stops guessing filenames or trying to search its own local disk), the USB HID codes for arrow/navigation keys, and the recommended `mountdrive.start → screen.get → keyboard.send → repeat` loop.

| Resource URI | Contents |
| :--- | :--- |
| `usbridge://instructions` | Markdown onboarding guide + live disk list (`text/markdown`) |
| `usbridge://screen` | One-shot `screen.v1` JSON snapshot of the current screen (`application/json`) |

```json
{"jsonrpc":"2.0","id":4,"method":"resources/read","params":{"uri":"usbridge://instructions"}}
```

---

## 4. Tool Catalog

| Tool | What it does |
| :--- | :--- |
| `screen.get` | Current screen as structured `screen.v1` JSON (text runs + color segmentation). Rendering is async — wait ~150–300 ms after sending input before calling this. |
| `screen.text` | Current screen as plain text lines only (no color data) — same snapshot as `screen.get`, lighter payload. |
| `screen.get_image` | Current screen as a **lossless PNG screenshot** (base64-encoded MCP image content), plus a `{"width":...,"height":...}` text block. Same capture pipeline and timing rules as `screen.get` — no extra hardware needed. Optional `compression: 0-9` (default `3`) trades encode time for response size; the image itself is always lossless regardless of the setting. |
| `keyboard.send` | `action: key\|combo\|text`. `key`/`combo` use USB HID codes (Enter=40, Left=80, Down=81, Up=82); `text` also accepts xterm escape sequences (`\x1b[C` etc.) for special keys. Requires `mountdrive.start` with `keyboard: true` first. |
| `mouse.action` | Move/click/scroll. Requires `mountdrive.start` with `mouse: true` first. |
| `rndis.set` | Enable/disable the USB-Ethernet (RNDIS) network bridge to the target. |
| `mountdrive.start` | Attach drives and/or HID (keyboard/mouse/RNDIS). Required before `keyboard.send`/`mouse.action` will work. |
| `mountdrive.stop` | Stop all mounted devices. |
| `media.insert` | Attach one more disk/ISO source on top of whatever's already configured, without needing to know or repeat the current device set. |
| `media.eject` | Detach disk/ISO/MTP sources while leaving keyboard/mouse/RNDIS/gamepad untouched — use before rebooting a host you just installed via a CD-ROM gadget, so boot order doesn't loop back into the installer. |
| `device.info` | Current device/gadget info. |
| `pcpanel.leds` | Power/HDD LED status read back from the target's front panel. |
| `pcpanel.button` | Press the target's power or reset button (`button: "power"\|"reset"`). |
| `scripts.list` | List available Starlark automation scripts. |
| `scripts.run` | Run a script by full path (background). Check `scripts.status` first — starting the same path twice fails, and a script racing manual `keyboard.send`/`screen.get` calls against the same target produces confusing, hard-to-debug navigation. |
| `scripts.status` | Running/recently-finished runs (`path`, `running`, `started_at`, `error`). |
| `scripts.log` | A run's `print()` output from an offset — poll this while `running: true` to watch progress instead of guessing timings. |
| `scripts.stop` | Cancel a run; it stops at its next `key_press`/`sleep`/`wait_text` checkpoint. |

Full request/response shapes for each tool live in the appliance's own `tools/list` response (`inputSchema` per tool). For the scripting-related tools specifically, see the [Starlark Scripting Reference](./scripting-automation.md).

> [!TIP]
> **When to reach for `screen.get_image` instead of `screen.get`/`screen.text`.** The OCR text tools only describe text-mode content — a boot splash/logo, a graphical desktop, a game, BIOS vendor art, or a progress bar/spinner with no readable text is invisible to them. `screen.get_image` returns the actual pixels instead, for that case or whenever the agent needs to visually confirm something the OCR text can't describe. Prefer `screen.get`/`screen.text` when the screen genuinely is text — they're cheaper and skip image decoding on the agent's side.
>
> ```json
> {"jsonrpc":"2.0","id":6,"method":"tools/call","params":{"name":"screen.get_image","arguments":{}}}
> ```

> [!NOTE]
> **MCP can run scripts, not write them.** The tool catalog only covers *listing/running/monitoring* Starlark scripts (`scripts.list`/`run`/`status`/`log`/`stop`) — there is no `scripts.write` or `scripts.read` MCP tool. Creating or editing a script's code is a human/client-app action (or a direct, HMAC-signed call to `POST /api/scripts/write` — see [Writing Reliable Scripts](./scripting-automation.md)), not something an MCP agent can do on its own out of the box.

---

## 5. Prefer Scripts Over a Raw Tool-Call Loop

For anything beyond a couple of keystrokes — walking a BIOS menu, driving an unattended OS installer — write a [Starlark script](./scripting-automation.md) and run it with `scripts.run` instead of looping `keyboard.send`/`screen.get` by hand across many agent turns. A script keeps its own state between steps, can retry/self-heal, and its `print()` log is a durable record of what actually happened; a long multi-turn tool-call loop tends to drift out of sync with real device state instead.

```json
{"jsonrpc":"2.0","id":5,"method":"tools/call","params":{"name":"scripts.run","arguments":{"path":"/mnt/sdcard/scripts/enter_bios.star"}}}
```

---

## 6. What This Enables

* **Autonomous auditing:** an agent reads the rendered console the same way a human would, navigates menus, and reports back configuration state.
* **Intelligent triage:** instead of a blind macro, the agent interprets an unpredictable error screen (e.g. spotting a `"RAID Critical"` flag, or inferring a dead CMOS battery from a reset system date) and decides on a recovery path.
* **Unattended provisioning:** combined with `mountdrive.start`/`media.insert`, an agent can mount an installer ISO, drive the installer through text prompts, and reboot into the freshly installed disk — the same flow a hand-written Starlark script would follow, just directed by natural-language instructions instead.
