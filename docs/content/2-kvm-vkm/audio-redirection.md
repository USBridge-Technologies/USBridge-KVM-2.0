# Audio Redirection Specification

This section details the hardware and software architecture regarding real-time audio transport through the USBridge-KVM 2.0 subsystem. 

---

## 1. Audio Transport Architecture

Unlike traditional IP-KVM solutions that are strictly limited to video streams, the USBridge appliance features a fully integrated hardware and software audio pipeline. This allows administrators to monitor system alerts, verified boot chimes, and full OS-level multimedia outputs completely out-of-band.

* **Hardware Extraction:** The external UVC capture dongle acts as a combined hardware video/audio bridge, intercepting the raw digital audio signal embedded within the target host's HDMI output stream.
* **On-Board Processing:** The USBridge core processor captures the raw PCM audio data stream directly from the internal USB host controller, ensuring no software overhead or processing lag on the managed server.
* **Network Streaming Layer:** Audio telemetry is tightly synchronized with the low-latency Moonlight video pipeline, streaming crystal-clear sound directly to your native USBridge Client application.

---

## 2. Technical Parameters & Codec Specification

The audio subsystem is optimized for high-fidelity replication and minimal network footprint:

| Parameter | Specification | Technical Note |
| :--- | :--- | :--- |
| **Audio Compression Codec** | **Opus** | Utilizes the industry-standard Opus codec for dynamic bit-rate adjustments and ultra-low encoding latency. |
| **Sampling Rate** | **48 kHz** | Full studio-quality sampling for precise sound reproduction. |
| **Channel Layout** | **Stereo (2.0 Channels)** | Dual-channel transport ensuring full spatial awareness for system diagnostic tones and alerts. |
| **Synchronization** | **Hardware AV-Sync** | Dynamic timestamping ensures the audio stream matches the video frames perfectly, preventing desynchronization during extended remote sessions. |

---

## 3. Deployment Requirements & Prerequisites

To ensure successful audio redirection during a remote management session, please verify the following configurations:

1. **Target Host Audio Output:** The operating system or hardware on the target server must have its primary audio output device set to the **HDMI/DisplayPort Digital Output** corresponding to the KVM connection.
2. **Client-Side Permission:** Ensure that the USBridge Client application has permission to access your workstation's local audio playback device, and that the volume toggle within the session window is enabled.
3. **Pre-OS Limits:** *Note:* Audio redirection functions exclusively once an audio driver or basic UEFI-level audio engine initializes on the target host. Legacy text-based BIOS menus do not output audio signals by design.
