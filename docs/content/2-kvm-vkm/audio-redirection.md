# Audio Redirection Specification

The USBridge-KVM 2.0 subsystem supports real-time, low-latency audio transport fully synchronized with the Moonlight video pipeline. This allows administrators to monitor system alerts, boot chimes, and OS-level audio streams completely out-of-band.

---

## 1. Supported Capabilities & Parameters

The audio pipeline automatically extracts digital audio from the host's HDMI output and stream it via the following specification:

* **Audio Codec:** **Opus** (low-latency, dynamic bitrate adaptation).
* **Sampling Quality:** **48 kHz** stereo (2.0 channels) audio streaming.
* **AV-Sync:** Hardware-level audio/video timestamp synchronization to prevent drift during extended sessions.

---

## 2. Target Host Prerequisite (Critical Configuration)

For audio redirection to function properly, the managed server's operating system must explicitly route its sound pipeline to the KVM hardware:

> ⚠️ **Required Setup:** You must navigate to the target host's OS audio settings and select the **HDMI/DisplayPort Digital Output** corresponding to the USBridge-KVM hardware connection as the primary audio playback device. 

*Note: Audio redirection requires an active audio driver or UEFI-level audio engine to be initialized on the target host. Legacy text-based BIOS menus do not output audio signals by design.*
