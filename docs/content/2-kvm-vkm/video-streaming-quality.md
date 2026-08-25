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

You're not locked to the bundled dongle. The capture pipeline talks plain V4L2/UVC and auto-negotiates whatever the connected device reports — in practice, that covers **most UVC and CSI-MIPI capture cards**, not just one specific chipset.

* **Supported pixel formats:** MJPEG, NV12, YUYV, UYVY — probed live from the device, in that priority order.
* **Default format is picked automatically by USB link speed:** MJPEG on a `[480M]`/USB 2.0 link (keeps bandwidth within budget), YUYV on `[5G]`/USB 3.0 or MIPI (uncompressed, no JPEG artifacts, bandwidth isn't the constraint there). See the speed-mode note above.
* **Confirmed working in practice:** MacroSilicon MS2130-based capture cards (USB 3.0/NV12-YUYV class chips), and MacroSilicon MS2109-based cards (the common USB 2.0, MJPEG-only capture dongles) — both third-party, not the bundled unit. Any UVC or CSI-MIPI device reporting one of the formats above should work the same way; these are just two concretely verified examples, not an exhaustive allowlist.

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

### Local Monitor Passthrough
The onboard **Mini HDMI** port mirrors the captured signal in real time to a local monitor or crash cart — useful for on-site work alongside a remote session, no active HDMI splitter needed.

### HDCP / DRM
Not supported by the capture hardware. Protected content (DRM'd video playback, some game launchers) shows as a black screen on both the local and remote display — this is a hardware capture limitation, not a bug.
