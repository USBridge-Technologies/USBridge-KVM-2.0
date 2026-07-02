# Desktop App Updates

This registry tracks the stable release line, binary distributions, and architectural changelogs for the USBridge cross-platform desktop application.

## Current Baseline Release

The initial production release of the client application establishes the baseline feature set required for out-of-band management.

* **Device Module:** Initial deployment of virtual peripheral management and remote ISO mounting pipelines.
* **Control Module:** Core integration of live UVC video rendering and bi-directional HID input injection for pre-OS KVM access.
* **Snapshots Module:** Baseline telemetry and tracking for hardware-isolated Btrfs storage states.

| Version | Platform Support | Release Status |
| :--- | :--- | :--- |
| **v2.0** | Windows, macOS, Linux | Initial Public Baseline (Stable) |

---

## Release Tracking Methodology

As incremental client builds are validated and deployed, this repository will be updated with comprehensive technical summaries. 

Future changelog iterations will systematically document the following parameters:

* **Architectural Release Notes:** Detailed summaries of newly implemented automation modules, API expansions, and UI optimizations.
* **Patch Diagnostics:** Engineering reports detailing resolved software regressions, video latency optimizations, and HID compatibility expansions across different BIOS implementations.
* **Binary Distributions:** Secure, version-controlled download links for the latest compiled binaries across all supported operating systems.
