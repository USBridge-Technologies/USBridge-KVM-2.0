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
* **Over the USB cable**, on a KVM that isn't set up yet: open `http://10.55.0.1` and click **Open the web client** — it opens the client served by the KVM and pairs it with the key straight away (see [Initial Setup §A](../1-getting-started/initial-setup.md#a-no-screen-needed-over-the-usb-cable)).

Opened from the KVM, the client talks to that same KVM directly (API and WebRTC on the same address), so it also works on an isolated network. The version is the one that came with the KVM's firmware and updates with it. The in-browser AI-vision overlay isn't included in this copy.

> [!NOTE]
> On the **NanoKVM** the browser gets 720p at up to 30 fps (its single CPU core encrypts the WebRTC stream in software); the desktop and mobile clients keep 1080p60 there.
