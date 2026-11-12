# HDMI Video Capture Dongle (1080p @ 60 FPS)

The high-performance hardware-level UVC video capture adapter included with the **USBridge KVM 2.0 Standard** and **Full** kits, and available as a standalone accessory for custom SBC builds.

* 👉 [Buy HDMI Capture Dongle on usbridge.io ($20)](https://www.usbridge.io/hardware-agent/#buy-capture-card)

---

## Technical Specifications

| Feature | Details |
| :--- | :--- |
| **Input Interface** | Standard HDMI 1.4+ (connecting to host GPU or server motherboard) |
| **Output Interface** | USB Type-C High-Speed Interface |
| **Supported Resolutions** | 1080p @ 60 FPS, 1080p @ 30 FPS, 720p @ 60 FPS |
| **Encoding Architecture** | Direct UVC hardware capture pipeline integrated with Moonlight |
| **Color Formats** | YUY2, NV12, MJPEG |
| **Plug & Play** | Standard UVC driverless compliance across Linux, Windows, macOS |

---

## Critical: USB 3.0 `[5G]` vs `[480M]` Operation Modes

The capture dongle operates in two different hardware modes depending on cable orientation and port capability:

* **`[5G]` Mode (USB 3.0 - 5 Gbps)**: **Target High-Performance Mode**. Uncompressed color transmission, crystal-clear text readability, and minimum video latency (~45 ms).
* **`[480M]` Mode (USB 2.0 - 480 Mbps)**: Compatibility fallback mode. May cause compression artifacts, color banding, and noticeable delay.

> [!TIP]
> **How to ensure `[5G]` Mode:**  
> Verify the connection indicator in the USBridge Client interface. If `[480M]` is displayed, simply unplug the Type-C cable from the KVM, flip the connector 180°, and plug it back in to lock onto high-speed `[5G]` mode.
