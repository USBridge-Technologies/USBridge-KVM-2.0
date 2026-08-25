# Video Streaming & Quality Specification

USBridge captures video through a driverless **UVC (USB Video Class)** HDMI capture dongle and streams it over **Moonlight/Sunshine**. Because capture happens at the hardware level, it works identically during BIOS/UEFI, pre-OS boot stages, and even a kernel panic — there's no OS driver on the target host to depend on.

---

## 1. Hardware Pipeline & Signal Routing

* **Primary Interface:** The HDMI capture dongle connects to the appliance's **USB-C (Host)** port.
* **Combining Capture + RNDIS:** If you also need the [USB-LAN network bridge](./network.md) running at the same time as video capture, route both the capture dongle and a USB-Ethernet adapter through an external USB hub — the appliance's own ports can't carry both simultaneously.

> [!IMPORTANT]
> **Capture Dongle Speed Mode**
> The USB Type-C capture dongle can enumerate in either of two USB modes depending on cable orientation — check its status in the app:
> * **`[5G]` (USB 3.0, target mode):** Full bandwidth, no compression artifacts, lowest input lag.
> * **`[480M]` (USB 2.0, fallback):** Works, but with visibly more compression and latency.
>
> **Fix:** unplug the Type-C cable, flip it 180°, and reconnect — this is enough to force renegotiation into `[5G]` mode.

---

## 2. Resolution & Signal Parameters

The appliance probes the connected capture dongle's actual reported UVC modes at runtime rather than assuming a fixed set — what's available depends on the specific dongle. The bundled dongle (see [What's in the Box](../1-getting-started/whats-in-the-box.md)) reports:

| Mode | Typical Use |
| :--- | :--- |
| **1280×720 @ 60 FPS** | Fluid mouse tracking and low interaction latency — the default for most sessions. |
| **1920×1080 @ 30 FPS** | Maximum text/UI sharpness for dense CLI or GUI content, at half the frame rate. |
| **640×480** (fallback) | Falls back here if the dongle can't negotiate a higher mode — still fully usable for text-mode BIOS/bootloader screens. |

4K capture is not supported — out of scope for a pre-OS diagnostic/BIOS-focused capture pipeline.

---

## 3. Capture Device Compatibility

You're not locked to the bundled dongle. The capture pipeline auto-negotiates whatever the connected device reports — in practice, that covers **most UVC and CSI-MIPI capture cards**, not just one specific chipset.

* **Supported pixel formats:** MJPEG, NV12, YUYV, UYVY — probed live from the device, in that priority order.
* **Default format is picked automatically by USB link speed:** MJPEG on a `[480M]`/USB 2.0 link (keeps bandwidth within budget), YUYV on `[5G]`/USB 3.0 or MIPI (uncompressed, no JPEG artifacts, bandwidth isn't the constraint there). See the speed-mode note above.
* **Confirmed working in practice:** MacroSilicon MS2130-based capture cards (USB 3.0/NV12-YUYV class chips), and MacroSilicon MS2109-based cards (the common USB 2.0, MJPEG-only capture dongles) — both third-party, not the bundled unit. Any UVC or CSI-MIPI device reporting one of the formats above should work the same way; these are just two concretely verified examples, not an exhaustive allowlist.

> [!NOTE]
> **Third-party capture cards don't have the 576p EDID trick.** The bundled dongle's pre-flashed EDID (see [EDID & Headless Targets](#5-display-emulation--signal-constraints) below) is specific to that unit — a non-bundled capture card reports its own generic EDID instead. It'll still capture video fine, but for [BIOS-in-Terminal](../3-bios-in-terminal/technology-overview.md)/SSH-KVM to get the same compact, readable character grid instead of an overly dense one, pair a third-party capture card with a separate **HDMI EDID-lock/dummy-plug adapter** set to a similar low resolution.

---

## 4. Latency

Glass-to-glass latency (physical frame change on the target → pixels rendered on your client via Moonlight) is dominated by the network path, not the capture/encode pipeline:

* **Wired LAN:** typically **under 50 ms**.
* **Wi-Fi 6 (802.11ax):** also typically **under 50 ms** on a clean channel — close enough to wired that it isn't the bottleneck in practice on modern hardware.
* **Older Wi-Fi (802.11n/ac) or a congested 2.4 GHz channel:** noticeably higher and less consistent — if you're seeing lag, this is the first thing to check before blaming the appliance.

---

## 5. Display Emulation & Signal Constraints

### EDID & Headless Targets
The bundled capture dongle ships with its **own EDID pre-flashed**, advertising a fixed preferred mode (576p) to whatever it's plugged into — it already looks like "a monitor is attached" to the target, and most GPUs/BIOSes will pick that preferred mode by default. This is deliberate, not just a side effect of being a generic capture device: it means most setups **don't need a separate EDID emulator/dummy plug** just to get a display signal or to pin a sane resolution.

That fixed resolution also keeps the target's text console at a manageable character grid. A Linux framebuffer console (and most BIOS/UEFI text modes) size their character grid off the active video mode — at a high resolution like 1080p that can mean a dense grid (e.g. ~250×67 characters), which doesn't render usefully in [BIOS-in-Terminal](../3-bios-in-terminal/technology-overview.md)'s SSH view or OCR pipeline. At 576p it comes out around 100×31, which fits cleanly.

If your target's GPU still disables output entirely regardless of EDID (some do, on certain BIOS/driver combinations, when they can't get a satisfactory handshake), that's the case an external **HDMI dummy plug (EDID emulator)** is for — inline between the target and the capture dongle.

> [!IMPORTANT]
> This pre-flashed 576p EDID is a property of the **bundled dongle specifically** — see [Capture Device Compatibility](#3-capture-device-compatibility) above. Swap in a third-party UVC/CSI-MIPI capture card and you lose it: the card reports its own generic EDID, the target will likely negotiate a much higher resolution, and BIOS-in-Terminal/SSH-KVM's text grid comes out far denser than the ~100×31 the pipeline is tuned for. Add an external **HDMI EDID-lock/dummy-plug adapter** set to a similarly low resolution to get the same behavior with a non-bundled capture card.

### Local Monitor Passthrough
The onboard **Mini HDMI** port mirrors the captured signal in real time to a local monitor or crash cart — useful for on-site work alongside a remote session, no active HDMI splitter needed.

### HDCP / DRM
Not supported by the capture hardware. Protected content (DRM'd video playback, some game launchers) shows as a black screen on both the local and remote display — this is a hardware capture limitation, not a bug.

---

## 6. Streaming Settings

**Settings → Authentication → Moonlight** on the front panel covers pairing and stream tuning:

| Option | What it does | Also settable from |
| :--- | :--- | :--- |
| **Enter PIN** | Completes Moonlight pairing when a client requests it. | The client app normally handles this automatically during its own pairing flow — you only need to type it manually on the front panel if you're pairing a standalone Moonlight client instead of the USBridge-Remote app. The REST API also accepts a PIN directly (`POST /api/moonlight/pin`) — see the [REST API Reference](../10-developer-api/rest-api-reference.md#3-pairing-sync--moonlight). |
| **Paired Clients** | Lists every client currently paired to this appliance; select one and **Unpair** to revoke its access immediately. Use this if a client device is lost, retired, or you just want to audit who's paired. | Front panel only. |
| **FEC Percentage** | Forward error correction overhead for the video stream — higher tolerates more packet loss (lossy Wi-Fi, congested links) at the cost of extra bandwidth. Default 20%. | Front panel only. |
| **WebRTC** | Same toggle as [Settings → Authentication → WebRTC](../1-getting-started/device-status-menu.md) — required for the [Web Client](../7-software-access/web-client.md). | Front panel only (two menu locations, same setting). |
| **Pixel Converter** | Which pixel-format conversion path the streaming pipeline uses (`auto` / hardware-accelerated / software). Leave on `auto` unless you're troubleshooting a specific rendering issue. | Front panel only. |
