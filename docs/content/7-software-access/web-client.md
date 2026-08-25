# Web Client (Browser, Zero-Install)

**[web.usbridge.io](https://web.usbridge.io)** runs the same USBridge-Remote client directly in a browser — no download, no install, works from a locked-down machine you can't put software on. Video/audio go over WebRTC with NAT traversal (STUN), so it also works off your local network without a VPN hop, same as the [desktop](./desktop-app.md) and [mobile](./mobile-app.md) clients.

> [!NOTE]
> The web client trades off some feature and performance headroom for running inside a browser's security sandbox — browser WebRTC/security constraints mean it isn't a strict 1:1 replacement for the native desktop/mobile apps. For the most demanding low-latency sessions (e.g. fast-paced BIOS navigation, gaming-grade input timing), prefer a native client when one is available to you.

## Connecting

1. Open [web.usbridge.io](https://web.usbridge.io) in any modern browser.
2. Connect using the appliance's IP address or by scanning the front-panel pairing QR code — same pairing flow as the native clients; see [Initial Setup & Client Pairing](../1-getting-started/initial-setup.md).

The appliance needs **WebRTC enabled** to accept this kind of session — it's on by default (**Settings → Authentication → WebRTC** on the front panel). If the web client can't connect but the desktop/mobile clients work fine, that toggle is the first thing to check.

Once connected, the web client provisions the same **Device**, **Control**, and **Snapshots** modules described in the [Desktop Client](./desktop-app.md) page.
