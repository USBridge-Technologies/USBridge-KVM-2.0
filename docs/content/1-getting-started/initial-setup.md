# Initial Setup & Client Pairing

This guide covers the network configuration and secure client pairing required to establish encrypted out-of-band connectivity with your USBridge-KVM 2.0 appliance.
Before starting the software configuration, ensure that the USBridge device is correctly wired to the target host according to the [Quick Start Guide](https://github.com/USBridge-Technologies/USBridge-KVM-2.0/blob/main/docs/content/1-getting-started/quick-start.md).

---

## Step 1: Retrieve Authentication Credentials

To securely connect the client application to the physical KVM hardware, you must retrieve the authorization token from the device.

1. On the appliance front panel, navigate to **Settings** -> **Auth** -> **Show Master Key**.
2. Upon selection, the KVM will automatically generate a secure pairing QR Code alongside an alphanumeric Access Token.
3. If scanning the QR code is difficult or impossible, press **Button 1** to display the token in a full plaintext format.

---

## Step 2: Client Connection Initialization

Before proceeding, ensure you have downloaded the latest version of the Client from the official releases [USBridge-Remote Releases](https://github.com/USBridge-Technologies/USBridge-Remote/releases) page.

1. Install and launch the **USBridge Client** application on your administrator workstation.
2. Click the **+ (Add Connection)** button to open the device provisioning menu.
3. Establish the secure handshake using one of the following methods:
   * **Automated Sync:** Scan the onscreen QR code using your workstation/mobile camera to instantly pull configuration parameters.
   * **Manual Entry:** Input the target appliance's assigned local IP address, the unique **Access Token** retrieved in Step 1, and assign a custom **Connection Name** *(Optional)* for easier infrastructure cataloging.

---

## Step 3: Secure Mesh Networking Onboarding (Tailscale)

By default, the client configuration menu pre-selects the **Register Device in Tailscale** option. We highly recommend keeping this enabled to securely route out-of-band KVM traffic across untrusted networks without exposing open firewall ports.

1. Leave the **Register Device in Tailscale** checkbox active and click **Save & Connect**.
2. The client will automatically trigger a browser routing sequence to the official Tailscale authentication portal.
3. Authenticate using your organization's credentials to authorize the USBridge hardware as a trusted node within your secure tailnet mesh overlay.
4. *Alternative Workflow:* If your infrastructure deployment dictates air-gapped local isolation, uncheck this option to restrict data routing strictly to the local subnet.

---

## Setup Verification

Once the Tailscale handshake or local authentication cycle completes, the client app will securely bind the session. 

The primary interactive workspace will transition immediately to the **Control** tab, rendering the target server's real-time video pipeline. You now have complete, isolated, out-of-band command over the connected bare-metal infrastructure.
