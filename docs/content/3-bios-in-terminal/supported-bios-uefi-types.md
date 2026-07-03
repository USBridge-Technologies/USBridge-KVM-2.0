# Supported BIOS/UEFI Types & Compatibility Matrix

The **BIOS-in-Terminal** engine is explicitly optimized for parsing text-based pre-OS interfaces, standard console bootloaders, and text-driven operating system installers. 

## Compatibility Summary

| Pre-OS Interface Type | BIOS-in-Terminal Support | Recommended Management Protocol |
| :--- | :---: | :--- |
| **Legacy Text BIOS** (AMI, Phoenix, Award, Insyde) | **Full Support** | SSH Terminal Session (ANSI/VT100) |
| **Text-Mode UEFI Utilities** | **Full Support** | SSH Terminal Session (ANSI/VT100) |
| **GRUB / Bootloaders** (rEFInd, Syslinux) | **Full Support** | SSH Terminal Session (ANSI/VT100) |
| **Text OS Installers** (Ubuntu Server, Debian, Arch) | **Full Support** | SSH Terminal Session (ANSI/VT100) |
| **Graphical UEFI Shells** (Vendor-branded dashboards) | *Unsupported* | Native Client App (Moonlight Video Stream) |
| **Graphical OS Installers / Desktop GUI**| *Unsupported* | Native Client App (Moonlight Video Stream) |

---

> [!NOTE]
> I am continuously working on improving the optical character recognition (OCR) engine. Since processing happens in real-time, minor character recognition or layout artifacts may occasionally occur. 
>
> If you encounter a specific text-based installer or boot utility that does not parse correctly, please open an issue or contact our support team.
> 
> Support for graphical UEFI dashboards and high-definition vendor shells is planned for a future release.
