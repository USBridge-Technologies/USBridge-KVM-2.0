# USBridge Flip-HAT 1.3" IPS LCD for Raspberry Pi Zero

![USBridge Flip-HAT](images/Flip-HAT_1.3.png)

The **USBridge Flip-HAT** is a professional rear-mount terminal designed specifically for the Raspberry Pi Zero family. This module offers a vibrant display interface while maintaining full system cooling and GPIO access.

Screen and buttons are identical to the [Waveshare 1.3" LCD HAT](https://www.waveshare.com/1.3inch-lcd-hat.htm); only the pinout is mirrored. The Waveshare HAT sits on top of the board and covers the SoC; the Flip-HAT mounts on the back, so the SoC faces out and lies against a heatsink. Works with the USBridge firmware on the **Radxa Zero 3W** and **Radxa Cubie A7Z** (see the [board comparison](../docs/content/6-hardware-connectivity/board-comparison.md#front-panel-display-for-the-radxa-boards)). [Buy it on usbridge.io](https://www.usbridge.io/hardware-agent/#buy-screen-module).

## Technical Specifications
- **Display:** 1.3-inch HD IPS (240x240 pixels)
- **Interface:** 4-wire SPI (Driver IC: ST7789)
- **Controls:** Integrated 5-way Joystick (U2) + 3x Tactile Buttons (K1, K2, K3)
- **Form Factor:** Rear-mount (Optimized for SoC cooling)
  
![USBridge Flip-HAT](images/Technical_Specifications.png)
## Pinout Mapping
| Component | Function | BCM Pin / Connection |
|-----------|----------|----------------------|
| LCD       | SPI      | Standard SPI Pins    |
| Joystick  | 5-way    | Up, Down, Left, Right, Center Click |
| Buttons   | User-def | K1, K2, K3 |
| Header    | 40-Pin   | Female (Pass-through access) |


## Hardware Design Pillars
- **Thermal Freedom:** Unique back-side mounting keeps the SoC unobstructed for heatsinks.
- **Visual Clarity:** Premium IPS panel with wide viewing angles.
- **Enhanced UI:** Dedicated hardware controls for complex menu navigation.

## Hardware Components

The hardware design is open for community use. You can find all necessary production files in the [/Gerber](./Gerber) directory.

### Production Files
- **Gerber Files:** Located in [/Gerber](./Gerber). Ready for PCB fabrication (Standard 2-layer, 1.6mm thickness recommended).

### Key Components Reference
- **Display:** 1.3" IPS LCD (ST7789 Driver)
- **Joystick:** 5-way navigation switch
- **Buttons:** 3x SMD tactile switches
- **Header:** 40-pin female connector for RPi Zero
---
Designed by **USBridge** in Spain.
