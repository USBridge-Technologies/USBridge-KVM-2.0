# Video Streaming & Quality Specification

Video capture and low-latency streaming in the USBridge-KVM 2.0 ecosystem rely on the driverless **UVC (USB Video Class)** protocol paired with the high-performance **Moonlight** streaming architecture. This ensures absolute hardware independence from the target host's operating system, allowing video capture to function seamlessly during pre-OS boot stages, BIOS/UEFI configuration, and kernel panic events where standard drivers are not yet loaded.

---

## 1. Hardware Pipeline & Signal Routing

The video signal path is engineered for hardware-level isolation to prevent any electrical or logical interference with the target host:

* **Primary Interface:** The USBridge appliance utilizes its dedicated **USB-C (Host)** port to receive the raw video stream from the integrated or external HDMI-to-USB UVC capture module.
* **Complex Deployments (USB Hub):** If your target infrastructure topology requires simultaneous hardware video capture and wired USB-LAN emulation (via the KVM), both the capture module and the network adapter must be routed through an external USB hub connected to the appliance.

---

## 2. Resolution & Signal Parameters

The video pipeline is explicitly optimized for rock-solid stability across both legacy text-mode terminals and modern high-resolution desktop environments.

| Parameter | Specification | Behavioral Context |
| :--- | :--- | :--- |
| **High-Framerate Mode** | **1280x720 (720p) @ 60 FPS** | Optimized for fluid mouse tracking, real-time diagnostic observation, and ultra-low interaction latency. |
| **High-Resolution Mode** | **1920x1080 (1080p) @ 30 FPS** | Tailored for maximum crispness and text readability in dense CLI setups, remote IDEs, or detailed GUI configurations. |
| **Guaranteed Baseline** | **800x600 @ 60 FPS** | Enforced fallback state to maintain predictable pixel mapping within text-based legacy BIOS or bootloader menus. |
| **4K Topologies** | **Strictly Unsupported** | 4K input processing falls outside the architectural scope of out-of-band pre-OS diagnostics. |

---

## 3. Latency Optimization Metrics

Glass-to-glass latency (the duration from a physical frame change on the target server to the pixel rendering on your client application screen via Moonlight) is directly tied to the network transport layer:

* **Wired LAN Connection:** `~40–100 ms` — Recommended for production server environments requiring instantaneous UI and mouse synchronization.
* **Standard Wi-Fi 6 Connection:** `~80–180 ms` — Highly dependent on local RF environment conditions, signal degradation, and channel congestion.

---

## 4. Display Emulation & Signal Constraints

### EDID Management & Headless Operations
Extended Display Identification Data (EDID) behavior is governed by the connected UVC capture architecture. 
> **Critical Infrastructure Note:** If the target host motherboard or discrete GPU completely disables its video outputs when it detects no physical monitor attached, you must introduce an **HDMI dummy plug (EDID emulator)** inline to force the server's graphics pipeline to continuously generate a video signal.

### Local Monitor Passthrough (Loop-Out)
If you need to output video to a local server rack crash cart or local monitor simultaneously alongside the remote KVM stream, you can connect a physical display directly to the onboard **Mini HDMI** port. The hardware pipeline mirrors the server's video signal in real time without introducing extra latency or requiring external active HDMI splitters.

### Content Limitations & DRM
* **HDCP / DRM:** High-bandwidth Digital Content Protection and Digital Rights Management are strictly unsupported by the capture hardware. Attempting to pass or stream protected media content through the KVM pipeline will result in a solid black screen layout on both the local display and remote clients.
