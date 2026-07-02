# Video Streaming & Quality Specification

Video capture in the USBridge-KVM 2.0 ecosystem relies entirely on the driverless **UVC (USB Video Class)** protocol. This ensures absolute hardware independence from the target host's operating system, allowing capture to function during low-level boot stages where OS-level drivers are not yet loaded.

---

## 1. Hardware Pipeline & Signal Routing

The video signal path is completely isolated from the KVM's internal system logic to prevent any interference with the target host:

* **Primary Interface:** The USBridge appliance utilizes its dedicated **USB-C (Host)** port to receive the video stream from the included external HDMI-to-USB UVC capture dongle.
* **Complex Deployments (USB Hub):** If your target topology requires simultaneous hardware video capture and wired USB-LAN emulation (via the KVM), both the capture dongle and the network adapter must be routed through an external USB hub connected to the appliance.

---

## 2. Resolution & Signal Parameters

The capture architecture is explicitly optimized for rock-solid stability in pre-OS environments (BIOS, UEFI, GRUB/Systemd-boot, and crash screens).

| Parameter | Specification | Behavioral Context |
| :--- | :--- | :--- |
| **Guaranteed Baseline** | **800x600 @ 60 FPS** | Enforced by the capture adapter to maintain ultra-low latency and predictable pixel mapping within text-based legacy terminal interfaces. |
| **Maximum Input** | **Up to 1080p @ 60 FPS** | Dependent on the capabilities of the specific UVC capture hardware dongle attached to the KVM. |
| **Streaming Output** | **Up to 1080p @ 30 FPS** | Dynamically scales and compresses video frames based on available network bandwidth and selected client-side encoder settings. |
| **4K Topologies** | **Strictly Unsupported** | 4K input processing falls outside the architectural scope of out-of-band pre-OS diagnostics. |

---

## 3. Latency Optimization Metrics

Glass-to-glass latency (the time from a hardware frame change on the server to the pixel rendering on your client app screen) is directly tied to the network transport layer:

* **Wired LAN Connection:** `~80–150 ms` — Recommended for production environments requiring instantaneous UI responses.
* **Standard Wi-Fi 6 Connection:** `~120–250 ms` — Dependent on local RF interference and signal degradation.

---

## 4. Display Emulation & Signal Constraints

### EDID Management & Headless Operations
Extended Display Identification Data (EDID) behavior is governed entirely by the connected UVC capture module. 
* *Critical Note:* If the target host motherboard or GPU completely disables its video outputs when it detects no physical monitor attached, you must introduce an **HDMI dummy plug (EDID emulator)** inline to force the server's graphics pipeline to generate a video signal.

### Local Monitor Passthrough (Loop-Out)
An HDMI loop-out port is **not natively present** on the standard USBridge hardware revision. If you need to output video to a local server rack crash cart monitor and the KVM simultaneously:
1. Introduce an external, active HDMI splitter before the capture dongle.
2. Alternatively, utilize a secondary physical video output port on the target server's GPU.

### Content & Audio Limitations
* **HDCP / DRM:** High-bandwidth Digital Content Protection and Digital Rights Management are strictly unsupported. Attempting to stream protected media content will result in a solid black screen layout.
* **Audio Intercept:** HDMI audio transport is disabled by design. The KVM pipeline handles video synchronization exclusively.
