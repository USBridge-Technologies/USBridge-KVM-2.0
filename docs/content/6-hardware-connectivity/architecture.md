# Core Hardware Architecture

USBridge runs on a **Radxa Zero 3W** single-board computer — a **Rockchip RK3566** (quad-core ARM Cortex-A55) with 1–2 GB LPDDR4X RAM, part of which the appliance dedicates to high-speed [virtual media caching](../5-remote-disk-image-mounting/mounting-iso-images.md#2-ram-cache-on-streamed-sources) for streamed drive sources.

That single SoC is doing real, simultaneous work: capturing and encoding video for [Moonlight streaming](../2-kvm-vkm/video-streaming-quality.md), running the [OCR pipeline behind BIOS-in-Terminal](../3-bios-in-terminal/technology-overview.md), emulating the USB HID/mass-storage gadget the target sees, and driving the [front-panel display](../2-kvm-vkm/display-mode.md) — all out-of-band, with zero footprint on the machine being managed.

See [Ports & Connectors Reference](./ports-connectors-reference.md) for the physical interfaces, and [Power & Thermal Specifications](./power-thermal.md) for what it takes to run this reliably 24/7.
