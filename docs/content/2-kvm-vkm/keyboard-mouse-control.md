# Keyboard & Mouse Input Specification

The USBridge appliance interfaces with the target host by emulating a standard hardware **composite USB Human Interface Device (HID)**. This hardware-level virtualization guarantees native, driverless compatibility across all deployment phases, functioning reliably at the BIOS, UEFI, bootloader, and OS levels without requiring any agent software on the managed machine.

---

##  Mouse Control & Cursor Tracking Modes

To ensure precise interaction with both graphical operating systems and legacy installation wizards, the KVM firmware supports two distinct mouse tracking algorithms. Administrators can toggle between these modes via the client application depending on target host behavior.

### Absolute Mode (Default)
* **Technical Mechanism:** The appliance transmits exact, fixed $X/Y$ coordinate matrices to the target host's USB controller.
* **User Experience:** Replicates precision touch-panel or digitizer behavior. The remote cursor maps perfectly `1:1` with your local workstation's mouse pointer, eliminating cursor drift or tracking desynchronization.
* **Recommended For:** Modern operating systems (Windows, Linux desktop distributions, macOS) and advanced graphical UEFI environments.
* **Multi-Monitor Targets:** If the target host drives more than one physical display, absolute mode can be pointed at a specific one (0-based display index + total display count) so coordinates map correctly onto that screen instead of assuming a single-monitor layout.

### Relative Mode
* **Technical Mechanism:** The appliance transmits only motion vectors (directional delta shifts: $+\Delta X, -\Delta Y$) relative to the pointer's last known position.
* **User Experience:** Replicates a classic, physical wired mouse. This tracking method is strictly required when absolute coordinate positioning is rejected by the host.
* **Recommended For:** Legacy operating system installers, older text-based BIOS menus, industrial hypervisor consoles, or specialized bare-metal recovery environments.

### Configuring the Mode
Mode (and the multi-monitor display index/count above) is a **client-app and API** setting — there's no dedicated front-panel screen for it. Via the REST API, it's part of the same device-attach call that brings up the mouse in the first place: see [USB Gadget / Device Management](../10-developer-api/rest-api-reference.md#4-usb-gadget--device-management) and [Input Control](../10-developer-api/rest-api-reference.md#5-input-control).

---

##  Keyboard Virtualization & Protocol Stability

Keyboard emulation is hardened for critical out-of-band infrastructure management, prioritizing input determinism over complex multimedia layouts.

* **USB HID Boot Protocol Compliance:** The virtual keyboard engine strictly adheres to the legacy USB HID Boot Protocol specification. This forces the host motherboard to recognize the KVM as a standard keyboard immediately upon POST, ensuring full input capability before any advanced OS-level USB drivers are initialized.
* **Pre-OS Environment Optimization:** Input mapping is engineered to function flawlessly within low-level terminal interfaces, GRUB/Systemd-boot loaders, and bare-metal server provisioning shells where software-dependent hotkeys are unavailable.



