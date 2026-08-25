# Gamepad Emulation Specification

The USBridge-KVM 2.0 architecture includes a native hardware-level input emulation subsystem, allowing administrators and developers to inject console controller signals directly into the target host completely out-of-band, driven by a real gamepad connected to the Moonlight/Sunshine client.

---

## Current Capabilities

The hardware emulation layer bypasses the need for host-side virtualization drivers, presenting itself to the target system as a native USB Human Interface Device (HID). Two report formats are supported:

* **DirectInput (default):** A generic 8-byte HID gamepad report with 8-bit axes. Recognized out-of-the-box by any OS or BIOS/UEFI setup utility that already supports generic HID game controllers, without a vendor-specific driver.
* **XInput (Xbox 360-compatible):** Emulates a genuine Xbox 360 wired controller (USB VID:PID `045E:028E`) at the raw USB protocol level. Windows loads its native `xusb22.sys` driver and registers the device as a real XInput controller — indistinguishable from hardware to Steam and XInput-aware games, including rumble feedback. This mode starts automatically the moment a gamepad is connected through Moonlight/Sunshine.

There is no PlayStation-specific (DualShock/DualSense) controller identity — a physical PlayStation controller connected on the client side is translated into one of the two USB HID formats above, the same as any other input source.

---

> [!NOTE]
> **Xbox One controller identity:** Only the Xbox 360 controller protocol is emulated. Microsoft's Xbox One controller ecosystem uses a different, more restrictive USB handshake that isn't implemented as a distinct emulated identity — Xbox One-specific accessories or software that requires that exact identity are not supported.
