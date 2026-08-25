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

## 3. Latency

Glass-to-glass latency (physical frame change on the target → pixels rendered on your client via Moonlight) is dominated by the network path, not the capture/encode pipeline:

* **Wired LAN:** typically **under 50 ms**.
* **Wi-Fi 6 (802.11ax):** also typically **under 50 ms** on a clean channel — close enough to wired that it isn't the bottleneck in practice on modern hardware.
* **Older Wi-Fi (802.11n/ac) or a congested 2.4 GHz channel:** noticeably higher and less consistent — if you're seeing lag, this is the first thing to check before blaming the appliance.

---

## 4. Display Emulation & Signal Constraints

### EDID & Headless Targets
If the target's motherboard/GPU disables its video output when it detects no physical monitor, insert an **HDMI dummy plug (EDID emulator)** inline so the target always sees a display and keeps generating a signal.

### Local Monitor Passthrough
The onboard **Mini HDMI** port mirrors the captured signal in real time to a local monitor or crash cart — useful for on-site work alongside a remote session, no active HDMI splitter needed.

### HDCP / DRM
Not supported by the capture hardware. Protected content (DRM'd video playback, some game launchers) shows as a black screen on both the local and remote display — this is a hardware capture limitation, not a bug.
