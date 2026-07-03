# BIOS-in-Terminal: Technology Overview & Quick Start

The **BIOS-in-Terminal** feature converts the graphical interface of pre-OS environments (BIOS/UEFI) into an interactive, real-time text stream. By intercepting the raw HDMI video signal at the hardware level, the onboard chip processes the visual data using localized, offline OCR algorithms. Instead of traditional, bandwidth-heavy video streaming, operators gain access to a pure text console exposed via a standard SSH session that supports native, bidirectional keyboard navigation.

https://github.com/user-attachments/assets/fa2abbf4-3526-480b-b062-484498e28779

---

## Quick Start: Accessing BIOS via SSH

Deploying a low-level text session takes only a few straightforward steps:

1. **Verify the Hardware Pipeline:** Ensure the external HDMI capture dongle is physically bridged between the target server's video output and the USBridge Host USB-C port.
2. **Retrieve the IP Address:** Check the physical onboard IPS display or the USBridge-Remote client interface to get the appliance's currently assigned IP.
3. **Initialize the Connection:** Open a local terminal emulator and execute the standard SSH command:
   
   ```bash
   ssh admin@<your_usbridge_ip_address>
 Once the cryptographic handshake completes, the terminal window clears and begins rendering the live text representation of the target host's active BIOS/UEFI interface.  

---

## Post-Connection Capabilities

Transitioning from a visual canvas to raw terminal text redefines bare-metal infrastructure management:

* **Lag-Free Interactive Navigation:** Standard ANSI/VT100 terminal keystrokes (arrows, Enter, Escape) are instantly captured by the SSH daemon and injected into the host via hardware USB-HID emulation, neutralizing network latency.
* **Direct Buffer Manipulation:** Because the environment renders as native text, you can highlight, copy, and export asset serial numbers, interface MAC addresses, or complex POST error codes directly from your local terminal buffer.
* **Robust Automation Layer:** The text stream eliminates the need for brittle graphical "pixel-hunting" macros. Using the built-in automation engine, you can write Starlark (Python syntax) scripts that reliably scan the screen state, wait for exact strings (e.g., `"Aptio Setup Utility"`), and programmatically respond with physical scan-codes.
* **AI Agent Integration:** Translating the visual interface into structured text enables machine-level management via the Model Context Protocol (MCP). An AI agent (like Claude) can independently read the console, navigate menus, and run low-level diagnostics, such as identifying a dead CMOS battery by parsing an unexpected system date reset.
