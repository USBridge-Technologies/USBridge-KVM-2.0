# Local Display Mode

**Monitor** — the front-panel menu item — routes the target host's live video straight to the appliance's own screen. It's for on-site diagnostics at the rack: no network, no client app, no remote session, just look at the screen.

---

## 1. How It Works

* **Panel:** The appliance's integrated IPS LCD, 240×240.
* **Signal path:** The same UVC capture feed used for streaming, scaled down and rendered locally in real time — no perceptible lag.
* **Navigation:** Selected from the main menu and driven with the [5-way directional joystick](../1-getting-started/device-status-menu.md#1-front-panel-hardware-interface) — the same input used everywhere else on the front panel.

---

## 2. What It's For

* **Pre-OS state at a glance:** confirm the target is initializing before its OS or hypervisor comes up.
* **POST & bootloader tracking:** motherboard logo, UEFI entry, GRUB/Systemd-boot/Windows Boot Manager activity.
* **Spotting a stuck host:** a frozen BIOS screen, a RAID degradation warning, a CMOS battery failure, or a blocking `"Press F1 to Continue"` prompt — distinguishable at a glance without hooking up a full remote session first.

---

## 3. Limits

At 240×240, this isn't for reading dense terminal text or scrolling through logs — it's for recognizing *what kind* of screen the target is on (BIOS vs. GRUB vs. kernel panic vs. a normal desktop), so you can decide whether to open a full [KVM client session](../7-software-access/desktop-app.md) or just hit reset, without needing either for that first look.
