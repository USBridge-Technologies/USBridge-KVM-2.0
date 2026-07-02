# Local Display Mode Specification

**Display Mode** is a hardware-level feature that routes the target host's incoming video signal directly to the USBridge appliance's built-in LCD screen. This diagnostic loop is engineered for rapid, on-site diagnostics at the server rack without requiring a network uplink, a remote desktop workspace, or a mobile client connection.

---

## 1. Hardware Implementation & Scaling Architecture

The local monitoring pipeline is built completely on-device to ensure zero external dependencies:

* **Physical Panel:** The USBridge unit utilizes its integrated, high-contrast **IPS LCD display (240x240 native resolution)** mounted on the front panel.
* **Signal Path:** The hardware receives the raw digital frames via the standard driverless **USB Video Class (UVC)** pipeline from the attached HDMI capture module.
* **On-Board Processing:** The internal Rockchip RK3566 graphics layer intercept processor captures, processes, and scales the incoming video feed down to the native 240x240 layout in real-time with zero human-perceptible processing lag.

---

## 2. On-Site Diagnostic Scenarios

This mode is engaged directly via the physical rotary encoder interface. It is explicitly optimized to assist infrastructure engineers with immediate, rack-level decision-making during physical deployment or hardware triage:

* **Pre-OS State Verification:** Fast visual confirmation of the target server's initialization status before the primary operating system or corporate hypervisor boots up.
* **POST & Bootloader Monitoring:** Real-time tracking of Power-On Self-Test (POST) progression, motherboard logo rendering, UEFI configuration entry states, and low-level GRUB/Systemd-boot or Windows Boot Manager activity.
* **Hardware Halt Detection:** Immediate on-site identification of critical boot interruptions, missing storage arrays, broken RAID degradation warnings, CMOS battery failures, or blocking `"Press F1 to Continue"` firmware prompts.

---

## 3. Operational Constraints & Semantic Recognition

> [!NOTE]
> **Resolution & Readability Limits**
> Due to the ultra-compact physical footprint of the 240x240 pixel IPS panel, Display Mode is **not designed or intended** for the prolonged parsing of high-density terminal text, micro-font configurations, or detailed log analysis.

The primary engineering function of this mode is **semantic host-state recognition**. It allows an onsite administrator to instantly distinguish between a frozen BIOS utility, an active GRUB menu awaiting user input, or a kernel panic screen layout. This instant visualization facilitates a rapid decision on whether to hook up a full out-of-band remote KVM client console session or perform a hard hardware reset.
