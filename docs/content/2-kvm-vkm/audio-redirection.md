# Audio Redirection Specification

The USBridge-KVM 2.0 subsystem natively supports real-time out-of-band audio redirection fully integrated into the Moonlight streaming pipeline. For audio redirection to function properly, the managed server's operating system must explicitly route its sound pipeline to the KVM hardware: you must navigate to the target host's OS audio settings and select the **HDMI/DisplayPort Digital Output** corresponding to the USBridge-KVM hardware connection as the primary audio playback device.

*Note: Audio redirection requires an active audio driver or UEFI-level audio engine to be initialized on the target host; legacy text-based BIOS menus do not output audio signals by design.*
