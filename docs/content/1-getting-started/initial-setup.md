# Initial Setup & Client Pairing

This guide covers the network configuration and secure client pairing required to establish encrypted out-of-band connectivity with your USBridge-KVM 2.0 appliance.
Before starting the software configuration, ensure that the USBridge device is correctly wired to the target host according to the [Quick Start Guide](./quick-start.md).

## Which Way to Set Up: Four Different Methods

Pairing means getting the KVM's **master key** (and its address) into a client. There are four ways to do it. They are **separate methods**, not steps of one procedure: pick one.

| # | Method | What you need | Where the key comes from | Use it for |
| :--- | :--- | :--- | :--- | :--- |
| **A1** | **Over USB** in the desktop client | The KVM's USB cable plugged into your computer | The client fetches it over the cable by itself, nothing to type or scan | One device, the usual way |
| **A2** | **Setup page** `http://10.55.0.1` in a browser | The same USB cable, any browser on that computer | The page shows it (text + QR code) or opens the web client already paired; it also has **Moonlight PIN entry** and **network settings** | No desktop client at hand, a phone, a NanoKVM, setting the network or pairing Moonlight with no screen |
| **B** | **Front-panel screen** | A device with a screen (not the NanoKVM: its small OLED shows status only) | **Settings → Authentication → Show Master Key**: QR code on the screen | Devices with a screen, no cable needed |
| **C** | **Provisioning file** `usbridge_provision.json` | A drive or card plugged into the device (on the NanoKVM: its own microSD card) | **You** choose the key and write it into the file: nothing is shown or scanned | Many devices at once, or a network set before first boot — see [Headless & Bulk Provisioning](./headless-provisioning.md) |

Things that are easy to mix up:
- **"The QR code"** exists in two places — on the front-panel screen (B) and on the USB setup page (A2). It's the same pairing QR (`usbridge://sync?...`) either way. A provisioning file (C) has no QR code at all.
- **`10.55.0.1` is not the KVM's network address.** It exists only on the USB cable, between the KVM and the one computer it's plugged into (§A). On your LAN the KVM has its own address (DHCP by default), and nothing in this section is reachable there.
- **The master key and the Moonlight PIN are different things.** The key pairs the USBridge clients and the API; the 4-digit PIN pairs a [Moonlight](../10-developer-api/security-model.md#3-moonlight-video-streaming--a-completely-separate-protocol) client and is entered on the KVM: in the client, on the front-panel screen, or on the setup page (§A2).
- A provisioning file **sets** a key; it doesn't hand one out. After it's applied, setup over USB is closed on devices with a screen (the key is the one you wrote).

---

## A. Over the USB Cable

A device that hasn't been set up yet (fresh from the box, freshly flashed, or after a factory reset), and any device with no network address yet, makes itself reachable over the USB cable that goes from it to a computer. **Connect the KVM's USB cable to the computer you're setting it up from** (usually the target PC it's going to control anyway) and power the KVM on. Within a few seconds the computer gets a new **network adapter** with an address in `10.55.0.x`, and the KVM is `10.55.0.1` on it — no driver to install on Windows 10 (version 2004 or newer) / 11, macOS or Linux. Your computer's internet connection is not affected: this adapter has no gateway. Then use A1 or A2.

### A1. In the Desktop Client: Over USB

In the [USBridge Client](https://github.com/USBridge-Technologies/USBridge-Remote/releases): **+ (Add Connection) → Over USB**. The client finds the KVM, receives its master key and address and fills in the fields by itself. Click **Save & Connect** (Tailscale registration works the same as in [Step 3](#step-3-secure-mesh-networking-onboarding-tailscale) below). **Over USB** is in the desktop clients (Windows, macOS, Linux); on a phone use A2.

### A2. In a Browser: the Setup Page at `http://10.55.0.1`

Open **`http://10.55.0.1`** in a browser on the computer the KVM is plugged into. The page has:

1. **Connect a client** — **Open the web client** opens the client the KVM serves itself, over https (`:9443`), with the key handed over: nothing to install, and the browser gets 1080p60. The browser warns once about the KVM's own certificate (Advanced → Proceed). Or open `http://10.55.0.1:8080/`: that client finds the KVM on the cable by itself (see [Web Client](../7-software-access/web-client.md#served-by-the-kvm-itself-no-internet-needed)).
2. **Connect a client** — shown as soon as the page opens: the QR code, the connect **link** (`usbridge://connect?internal_host=…&master_key=…`, the same one the Agent's QR code carries) with **Copy link**, the **key** (hidden, with show and copy) and the KVM's address — its Ethernet address when it has one. Scan the QR with the mobile app, or paste the link into a client (**Add Connection → Paste link**). On a first start, before the key exists, the page says it's waiting for it and reloads by itself.
   **Get the client** offers the download for the system you're on, as usbridge.io does; the others are under **Other platforms**.
3. **Moonlight pairing** — add the KVM in Moonlight (by its LAN address, or by `10.55.0.1` from this same computer). Moonlight shows a 4-digit PIN: type it into **PIN** and click **Send PIN**; Moonlight finishes pairing.
4. **Network** — loads by itself: the Ethernet (and Wi-Fi, where the board has it) status. Ethernet: DHCP or a static address (IP, netmask, gateway, DNS), **Apply Ethernet**. Wi-Fi: **Scan for networks**, pick one (or type a hidden network's name), password, **Connect**; its address DHCP or static.

There's nothing to log in to: the page has the key the KVM handed it, and signs the PIN and network changes with it, exactly as a client signs its requests. Where the key isn't handed out (another board, already set up), the page says so and offers a field to paste the key in instead.

### When the Key Is Handed Out over USB

| Device | Over the USB cable (A1, A2) |
| :--- | :--- |
| **Sipeed NanoKVM** | **Any time**, to anyone on the cable: it has no screen, the cable is its only local way in. Never over Ethernet or Wi-Fi. |
| **Other boards** | **Once**, to the first one asking, and only **within 30 minutes of the KVM powering on**. Too late? Power it off and on again. Anyone asking later gets **"already set up"** with the date: if that wasn't you, reset the KVM to factory settings (front panel → Settings → Factory Reset). |

Good to know:
- The setup page and the key are reachable **only over the cable**: the KVM serves them on its USB network interface alone, so nobody on the LAN can get to them, even by routing `10.55.0.0/24` to the KVM. See [Security Model §1](../10-developer-api/security-model.md#1-physical-pairing--the-root-of-trust-for-the-api).
- **When the USB network is there:** on the **NanoKVM**, always. On other boards while the device hasn't been set up, and while it has no network address (no Ethernet cable, no Wi-Fi); once it's set up *and* on the network, the USB adapter disappears the next time the KVM rebuilds its USB devices, and from then on you reach it at its LAN address — the same settings are in the client under **gear menu → KVM settings**.
- No network yet? Set it up from §A2 **Network** (or the client's **gear menu → KVM settings → Wi-Fi / Ethernet** while connected over USB), then connect over the LAN. Ethernet works by DHCP out of the box.
- Set up one new KVM at a time per computer: two KVMs plugged into the same computer at once both answer at `10.55.0.1`, and only one of them is reached.

> [!TIP]
> Setting up many devices the same way, or a device whose USB port isn't connected to anything you can use? Use a [provisioning file](./headless-provisioning.md) (method C) instead.

---

## B. With the Front-Panel Screen

### Step 1: Retrieve Authentication Credentials

To securely connect the client application to the physical KVM hardware, you must retrieve the authorization token from the device.

1. On the appliance front panel, navigate to **Settings** -> **Authentication** -> **Show Master Key**.
2. Upon selection, the KVM will automatically generate a secure pairing QR Code alongside an alphanumeric Access Token.
3. If scanning the QR code is difficult or impossible, press **Button 1** to display the token in a full plaintext format.

---

### Step 2: Client Connection Initialization

Before proceeding, ensure you have downloaded the latest version of the Client from the official releases [USBridge-Remote Releases](https://github.com/USBridge-Technologies/USBridge-Remote/releases) page.

1. Install and launch the **USBridge Client** application on your administrator workstation.
2. Click the **+ (Add Connection)** button to open the device provisioning menu.
3. Establish the secure handshake using one of the following methods:
   * **Automated Sync:** Scan the onscreen QR code using your workstation/mobile camera to instantly pull configuration parameters.
   * **Manual Entry:** Input the target appliance's assigned local IP address, the unique **Access Token** retrieved in Step 1, and assign a custom **Connection Name** *(Optional)* for easier infrastructure cataloging.

---

### Step 3: Secure Mesh Networking Onboarding (Tailscale)

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

> [!TIP]
> **No display?** Pair [over the USB cable](#a-over-the-usb-cable). **Configuring many appliances at once?** Drop a `usbridge_provision.json` file on a MicroSD card or USB flash drive instead — see [Headless & Bulk Provisioning](./headless-provisioning.md).
