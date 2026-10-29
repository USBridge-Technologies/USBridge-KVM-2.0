# Web Client (Browser, Zero-Install)

**[web.usbridge.io](https://web.usbridge.io)** runs the same USBridge-Remote client directly in a browser — no download, no install, works from a locked-down machine you can't put software on. Video/audio go over WebRTC with NAT traversal (STUN), so it also works off your local network without a VPN hop, same as the [desktop](./desktop-app.md) and [mobile](./mobile-app.md) clients.

> [!NOTE]
> The web client trades off some feature and performance headroom for running inside a browser's security sandbox — browser WebRTC/security constraints mean it isn't a strict 1:1 replacement for the native desktop/mobile apps. For the most demanding low-latency sessions (e.g. fast-paced BIOS navigation, gaming-grade input timing), prefer a native client when one is available to you.

## Connecting

1. Open [web.usbridge.io](https://web.usbridge.io) — **Google Chrome** is the only browser currently verified to work; other Chromium-based or WebRTC-capable browsers may work but haven't been tested.
2. Connect using the appliance's IP address or by scanning the front-panel pairing QR code — same pairing flow as the native clients; see [Initial Setup & Client Pairing](../1-getting-started/initial-setup.md).

The appliance needs **WebRTC enabled** to accept this kind of session — it's on by default (**Settings → Authentication → WebRTC** on the front panel). If the web client can't connect but the desktop/mobile clients work fine, that toggle is the first thing to check.

Once connected, the web client provisions the same **Device**, **Control**, and **Snapshots** modules described in the [Desktop Client](./desktop-app.md) page.

Browser sessions authenticate the same way as the REST API and are always encrypted in transit at the WebRTC layer — see [Security & Authentication Model](../10-developer-api/security-model.md).

## Served by the KVM Itself (No Internet Needed)

Every KVM also serves the web client on its own address — nothing to install, and no internet connection required:

* **`https://<kvm-ip>:9443/`** — the full client. The KVM's certificate is self-signed, so the browser warns once; accept it to continue.
* **`http://<kvm-ip>:8080/`** — same client without the certificate warning, but browsers keep some features to secure (`https`) pages only: gamepad, clipboard and microphone don't work there. Video, keyboard, mouse and every setting do.
* **On every address the KVM has**, both ports: Ethernet, Wi-Fi, the USB cable (`10.55.0.1`) and its Tailscale address. The self-signed certificate covers the KVM's current addresses (it's renewed when DHCP hands out a new one); on a tailnet `https://<tailscale-name>:9443/` gets a real Tailscale certificate. With **Tailscale-only mode** on (and the KVM on the tailnet), only the Tailscale address answers: Ethernet, Wi-Fi and USB are closed. This is the web client and the API, which want the key or a signed-in session; the setup page that hands the key out (`http://10.55.0.1`, port 80) is on the USB cable only.
* **Over the USB cable** (on the computer the KVM's USB cable is plugged into; `10.55.0.1` is the KVM's address on that cable only, not on your network):
  * **`http://10.55.0.1:8080/`** — the client finds the KVM on the cable by itself: it takes the key from it and opens **Add Connection** already filled in. The address is the KVM's **Ethernet** address when it has one; the menu under the fields switches to the **USB cable** (`10.55.0.1`). Click **Connect**: once connected, the KVM is saved to your connections (and synced to your account, if connection sync is on). A KVM that's already among your connections isn't offered again — it's in the list.
  * **The USB setup page** `http://10.55.0.1` → **Open the web client** — opens `https://10.55.0.1:9443/` (or the KVM's Ethernet address) with the key handed over in the link, in the same **Add Connection** dialog. Over https the browser warns once about the KVM's own certificate (Advanced → Proceed); in return the browser gets the 1080p60 stream (WebTransport). See [Initial Setup §A2](../1-getting-started/initial-setup.md#a2-in-a-browser-the-setup-page-at-http105501).

Opened from the KVM, the client talks to that same KVM directly (API and WebRTC on the same address), so it also works on an isolated network. The version is the one that came with the KVM's firmware and updates with it. The in-browser AI-vision overlay isn't included in this copy.

> [!NOTE]
> On the **NanoKVM** the browser gets **1080p60** by default, over WebTransport — on the `https://<kvm-ip>:9443/` client in a Chromium-based browser (Chrome, Edge). Where WebTransport can't run — the plain `http://` client (`:8080`, also the one the USB setup page opens), Firefox, Safari, or with **WebRTC** picked in the client — the stream falls back to WebRTC at 720p and up to 30 fps: its single CPU core encrypts WebRTC in software. The desktop and mobile clients always get 1080p60.
