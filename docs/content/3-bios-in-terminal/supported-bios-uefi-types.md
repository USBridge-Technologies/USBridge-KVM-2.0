# Supported BIOS/UEFI Types & Compatibility Matrix

[BIOS-in-Terminal](./technology-overview.md) is built for text-based pre-OS interfaces, console bootloaders, and text-mode OS installers — anything that renders as characters, not pixels.

| Pre-OS Interface | Support | Use It Through |
| :--- | :---: | :--- |
| **Legacy Text BIOS** (AMI, Phoenix, Award, Insyde) | Full | SSH Terminal |
| **Text-Mode UEFI Utilities** | Full | SSH Terminal |
| **GRUB / Bootloaders** (rEFInd, Syslinux) | Full | SSH Terminal |
| **Text OS Installers** (Ubuntu Server, Debian, Arch) | Full | SSH Terminal |
| **Graphical UEFI Shells** (vendor-branded dashboards) | Not supported | [Client app video stream](../7-software-access/desktop-app.md) |
| **Graphical OS Installers / Desktop GUI** | Not supported | [Client app video stream](../7-software-access/desktop-app.md) |

Installing one of the fully-supported text-mode OSes? Combine this with [mounted installer media](../5-remote-disk-image-mounting/mounting-iso-images.md) and a [Starlark script](./scripting-automation.md) to drive the whole install unattended.

---

> [!NOTE]
> OCR is under continuous improvement, and real-time processing occasionally misreads a character or layout — run into a text-based installer or boot utility that doesn't parse correctly? Open an issue or reach out on [Discord](../8-maintenance-support/faq.md#community-channels).
>
> Support for graphical UEFI dashboards and high-definition vendor shells is planned for a future release.
