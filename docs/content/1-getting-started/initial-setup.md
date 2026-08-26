# Initial Setup & Client Pairing

This guide covers the network configuration and secure client pairing required to establish encrypted out-of-band connectivity with your USBridge-KVM 2.0 appliance.
Before starting the software configuration, ensure that the USBridge device is correctly wired to the target host according to the [Quick Start Guide](./quick-start.md).

---

## Step 1: Retrieve Authentication Credentials

To securely connect the client application to the physical KVM hardware, you must retrieve the authorization token from the device.

1. On the appliance front panel, navigate to **Settings** -> **Authentication** -> **Show Master Key**.
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
2. The appliance isn't yet logged into a tailnet, so it generates a one-time **Tailscale login link** and hands it back to the client (it's the same `tailscale up` login flow Tailscale itself uses — nothing USBridge-specific about the link). The client polls the appliance for this link and, the moment it appears, **opens it automatically** in your workstation's default browser (or via an app-to-app link on Android) — you shouldn't need to copy anything by hand.
3. Authenticate using your organization's credentials on that page to authorize the USBridge hardware as a trusted node within your secure tailnet mesh overlay.
4. *Alternative Workflow:* If your infrastructure deployment dictates air-gapped local isolation, uncheck this option to restrict data routing strictly to the local subnet.

> [!NOTE]
> **If the browser doesn't open on its own** (no default browser set on that workstation, a popup blocker, or you're pairing from a headless/remote session), you can pull up the identical login link directly on the appliance instead: front panel → **Settings → Authentication → Tailscale → Manual registration**. The device requests the same one-time link and displays it on-screen — open it (or type it) into a browser on any machine to complete the same authorization step. Useful any time you need to (re-)register without going through the client's own connection flow at all.

> [!TIP]
> **Locking access down to the tailnet only:** once you're registered, front panel → **Settings → Authentication → Tailscale → Tailscale-Only Access** closes off the REST/MCP API and the KVM SSH console to everything except `127.0.0.1` and your tailnet IP — LAN is kept reachable only as a bootstrap path until registration completes, then it's torn down automatically. Combine it with turning off **WebRTC** (same Authentication menu) for what we call **Paranoia Mode**: no LAN surface at all, and no unauthenticated local WebRTC signaling endpoint either — the appliance is reachable only through an authenticated tailnet session. See [Security & Authentication Model §5](../10-developer-api/security-model.md#5-tailscale--an-additional-layer-but-not-for-every-path).

---

## Setup Verification

Once the Tailscale handshake or local authentication cycle completes, the client app will securely bind the session. 

The primary interactive workspace will transition immediately to the **Control** tab, rendering the target server's real-time video pipeline. You now have complete, isolated, out-of-band command over the connected bare-metal infrastructure.

For how this pairing step, API access, and streaming sessions are secured end-to-end, see [Security & Authentication Model](../10-developer-api/security-model.md).
