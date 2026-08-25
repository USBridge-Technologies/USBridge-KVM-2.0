# Starlark Scripting Reference

USBridge ships an embedded automation engine that runs **[Starlark](https://github.com/google/starlark-go)** (a deterministic, sandboxed dialect of Python) directly on the appliance. Scripts drive the same keyboard/mouse HID emulation and OCR screen-reading used everywhere else in the product, so a script can walk a BIOS menu, drive an unattended OS installer, or self-heal a stuck boot sequence without a host-side agent, and without "pixel-hunting" screenshot macros — it reads and matches actual recognized text.

> [!NOTE]
> This engine runs on the **hardware KVM appliance itself**, not in the [client app](https://github.com/USBridge-Technologies/USBridge-Remote) and not on a [software-only Agent](https://github.com/USBridge-Technologies/USBridge-Remote/blob/main/agent/docs/README.md#agent-vs-hardware-kvm) — an Agent target has no HID gadget or OCR pipeline to drive.

---

## 1. Where Scripts Live

Scripts are plain `.star` text files, searched in two fixed locations:

| Path | Storage |
| :--- | :--- |
| `/mnt/sdcard/scripts/*.star` | MicroSD card |
| `/mnt/emmc/scripts/*.star` | Onboard eMMC |

The appliance always ships one default script, `bios_entry.star` ("Enter BIOS"), which is rewritten on every boot so fixes to it deploy automatically — don't rely on hand-editing it as a permanent customization.

Metadata is declared with two comment lines at the top of the file; both are optional but drive the name/description shown in the on-device Scripts list and the client app:

```python
# name: My Automation
# desc: This script does X and Y
```

---

## 2. Running Scripts

### On the device (front panel)
**Scripts** on the main menu shows the flat list of discovered `.star` files by name. Press **[1]/OK** on an entry to run it immediately against the live session; press any button while it's running to cancel. The on-device menu is execution-only — creating or editing script text is done through the client app or the REST/MCP APIs below.

### Via REST API
| Method & Path | Purpose |
| :--- | :--- |
| `GET /api/scripts/list` | List scripts (path, name, description). |
| `GET /api/scripts/read?path=...` | Read a script's source. |
| `POST/PUT /api/scripts/write` `{"path": "...", "content": "..."}` | Create or overwrite a script. `path` must resolve under `/mnt/sdcard/scripts` or `/mnt/emmc/scripts`. |
| `POST /api/scripts/run` `{"path": "..."}` | Start a script in the background. Returns `409 Conflict` if that path is already running. |
| `GET /api/scripts/status` | Running/recently-finished runs (`path`, `running`, `started_at`, `error`). |
| `GET /api/scripts/log?path=...&offset=N` | `print()` output lines from offset `N` onward (`0` = from the start). |
| `POST /api/scripts/stop` `{"path": "..."}` | Cancel a run — it stops at its next `key_press`/`sleep`/`wait_text` checkpoint, not instantly. |
| `DELETE/POST /api/scripts/delete` `{"path": "..."}` | Delete a script file. |

Every one of these endpoints requires the standard HMAC-signed request headers (`X-Auth-Timestamp` + `X-Auth-Signature`) described in the [REST API Reference](../10-developer-api/rest-api-reference.md), including when called from `localhost` — that exemption only applies to the [MCP endpoint](./mcp-ai-agents.md).

### Via MCP (AI agents)
The same run/stop/status/log/list surface is exposed as MCP tools (`scripts.list`, `scripts.run`, `scripts.status`, `scripts.log`, `scripts.stop`) so an LLM agent can launch and monitor a script the same way a human would from the app. See [AI Agent Integration (MCP)](./mcp-ai-agents.md).

A running script's `print()` output is also mirrored live into the on-device **Event Log** screen, so a script kicked off remotely is still visible to someone standing at the rack.

---

## 3. Built-in Functions

### Keyboard
| Function | Description |
| :--- | :--- |
| `key_press(code)` | Sends a single key press. `code` is a USB HID key code (e.g. `40` = Enter, `82` = Up Arrow). Retries for up to 30s if the USB gadget is momentarily disconnected (e.g. mid host-reboot). |
| `key_combo(modifiers, code)` | Sends a key combination. `modifiers` is a bitmask: `1`=Ctrl, `2`=Shift, `4`=Alt, `8`=Meta. |
| `type_text(text)` | Types a string as if typed on a keyboard. |
| `sleep(ms)` | Pauses execution for `ms` milliseconds. |

### Reading the screen (OCR)
| Function | Description |
| :--- | :--- |
| `screen_text()` | List of all text lines currently detected on screen. |
| `screen_contains(text)` | `True` if the screen contains `text` (case-insensitive substring). |
| `screen_match(pattern)` | `True` if any line matches the given regular expression (case-insensitive). |
| `screen_fuzzy_contains(text, max_errors=1)` | Like `screen_contains`, but tolerates up to `max_errors` OCR mistakes (substitution/insertion/deletion) — e.g. matching `"B0ot Override"` for `"Boot Override"`. `max_errors=0` behaves exactly like `screen_contains`. Keep the budget small (1–2); use it only for landmark text you've actually seen an OCR engine misread, not everywhere. |
| `wait_text(text, timeout_ms=5000, max_errors=0, delay_ms=0)` | Polls until `text` appears or the timeout elapses. `delay_ms` waits *before* the first check, so the UI has time to finish transitioning. |
| `fuzzy_match(needle, haystack, max_errors)` | Standalone Levenshtein-distance substring match, for comparing arbitrary strings (not just live screen text). |
| `screen_focused_texts()` | Text of every screen segment currently rendered with the focus-highlight background color. Some text-mode installers (e.g. Proxmox VE's Cursive TUI) show **no text difference** between a focused and unfocused button — only a background-color change — so this is the only reliable way to know what's actually focused. Only works on the direct device-capture path, not inside an SSH-KVM session's plain-text feed (returns empty there). |
| `screen_focused_contains(text)` | `True` if any currently-focused widget's text contains `text`. Use right after a `Tab`, *before* the `Enter` that commits it, instead of blindly tabbing N times and hoping you landed on the right button. |

### Media & gadget control
| Function | Description |
| :--- | :--- |
| `insert_media(source, drive_mode="")` | Attaches one more disk/ISO source on top of whatever is already mounted. `source` follows the same resolution rules as [mounting an ISO](../5-remote-disk-image-mounting/mounting-iso-images.md)'s `sources[]` (bare filename searched under `/mnt/sdcard/iso` / `/mnt/emmc/iso`, or a full path/URL). |
| `eject_media()` | Detaches any mounted disk/ISO sources while leaving keyboard/mouse connected — use this right before a final reboot in an unattended install script, otherwise a CD-ROM-first boot order can loop back into the installer. |
| `reconnect_gadget(keyboard=True, mouse=True, rndis=False, sources=[])` | Tears down and rebuilds the entire USB composite gadget from scratch. Use at the start of a script that's about to drive a target through a real reboot — the gadget's reported "connected" state can go stale relative to reality after a USB enumeration failure on the target side, and a full rebuild is the only reliable recovery. |
| `list_backups()` | Returns the same entries the [Snapshots](../4-snapshots-state-management/creating-managing-snapshots.md) view shows: Btrfs snapshots (`data_*`) and standalone disk images, plus a synthetic `"BackupFlash"` entry for the whole backup folder. Each entry carries `name`, `type` (`mtp`/`backup`), `file_type`, `size`, `size_human`, `modified`, and `mtp_source` — pass `mtp_source` straight into `insert_media()` or `reconnect_gadget(sources=[...])` to mount an individual snapshot by MTP. Only paths under the board's `/mnt/*` storage are ever returned. |
| `run_script(path)` | Runs another script as a subroutine; the caller blocks until it finishes and shares its `print()` log and built-in environment. `path` can be a bare filename (searched the same way as script locations, `.star` optional) or a full path. Use this to compose small, independently-testable scripts (e.g. a shared `enter_bios.star`) instead of duplicating the same key sequence everywhere. |

---

## 4. Example Script

```python
# name: Boot to BIOS
# desc: Repeatedly presses F2 until "Setup" is detected

def main():
    print("Starting BIOS entry automation...")

    for i in range(40):
        key_press(59)  # F2
        sleep(500)

        if screen_contains("Setup") or screen_contains("BIOS"):
            print("Detected BIOS screen!")
            break

    if wait_text("Main", timeout_ms=5000):
        print("We are in the Main menu")
        key_press(81)  # Down
    else:
        print("Failed to detect Main menu")

main()
```

---

## 5. Writing Reliable Scripts

* **Verify before you commit.** OCR does misread characters on real hardware (`"Boot Override"` read as `"B0ot Override"` is a confirmed live example). Reach for `screen_fuzzy_contains`/`wait_text(max_errors=1)` on landmark text you've actually seen misread, and for `screen_focused_contains()` to confirm what a `Tab` actually landed on before pressing `Enter`.
* **Compose, don't duplicate.** Split a multi-stage flow (e.g. "enter BIOS" → "change a setting" vs. "enter BIOS" → "boot from USB") into small scripts joined with `run_script()`.
* **Rebuild the gadget before driving a reboot.** `reconnect_gadget()` at the top of a script that reboots the target avoids acting on stale connection state.
* **Re-insert media before a script's own reboot** if an earlier gadget reconfigure might have left the target not currently seeing the disk — `insert_media()` guarantees a fresh enumeration window at the next POST.
