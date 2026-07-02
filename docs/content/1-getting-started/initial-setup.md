# Initial Setup & Client Pairing

This guide covers the first boot sequence, network configuration, and secure client pairing required to establish encrypted out-of-band connectivity with your USBridge-KVM 2.0 appliance.

---

## Prerequisites
Before starting the configuration, ensure that:
1. The USBridge device is correctly wired to the target host according to the [Quick Start Guide](./quick-start.md).
2. The unit is powered on, and the built-in IPS display on the front panel is active and showing the boot splash screen.

---

## Step 1: Network Provisioning (Wi-Fi)

To enable remote access, the USBridge appliance must be connected to a local network with outbound internet access (for Tailscale orchestration and firmware validation).

1. **Open Menu:** Press the physical rotary encoder on the front panel to unlock the interface and open the **Settings** menu.
2. **Scan Networks:** Select the **Wi-Fi** submenu to initiate an automated scan of available local SSIDs.
3. **Authentication:** Select your target network from the list, input the network password using the rotary encoder interface (or via the local web panel), and confirm.
4. **Verification:** Wait for the successful connection prompt. Once connected, the interface will display the newly assigned IP address and network status.

---

## Step 2: Client Application Deployment

To monitor and control the target machine, you must install the native **USBridge Client** software on your administrator workstation or mobile device. 

Depending on your workflow, deploy the appropriate package:

* **Desktop Application (Windows, macOS, Linux):** *Recommended.* Required for low-latency Moonlight streaming, advanced keyboard/mouse mapping, and local ISO/Virtual Media mounting.
* **Mobile Application (iOS, Android):** Optimized for portable out-of-band diagnostics, real-time event log monitoring, and executing emergency hardware resets via the Power Management Module.

*Note: For download links and platform-specific installation instructions, navigate to the **Software & Access** section in the main documentation tree.*

---

## Step 3: Secure Device Authorization & Pairing

To prevent unauthorized access, every management session requires explicit cryptographic binding between the client app and the physical KVM hardware.

1. Launch the **USBridge Client** on your workstation or mobile device.
2. Click on the **Add New Device** button.
3. Select your preferred authorization method:
   * **QR Code Sync (Fastest):** Choose the QR option in the app and scan the authentication token generated directly on the USBridge front panel LCD.
   * **Manual Entry:** Manually input the KVM's assigned IP address and the unique alpha-numeric **Access Token** retrieved from the device's *Settings -> Auth* menu.
4. Click **Connect** to initialize the secure handshake.

---

## Setup Complete

The encrypted control channel is now fully established. You have complete, isolated, out-of-band control over the target infrastructure, enabling:
* Real-time BIOS/UEFI configuration.
* Bare-metal operating system deployment via virtual media.
* Low-level power state orchestration.
