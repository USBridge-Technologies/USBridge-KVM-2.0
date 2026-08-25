# Security & Authentication Model

USBridge doesn't rely on one shared credential for everything. Pairing, API access, video/input streaming, and (optionally) network transport are four separate trust boundaries, each independently secured — compromising one doesn't hand over the others.

---

## 1. Physical Pairing — the Root of Trust

Every appliance generates its own high-entropy master secret the first time it boots. That secret is never sent out over an open network on its own — it only ever leaves the device through a **physical** channel:

* **QR code** on the front-panel screen, scanned by the client's camera.
* **Manual entry**, for setups where scanning isn't convenient.

Both require someone to be physically present at the device (or trusted with the code) — there's no way to remotely guess or intercept it off the network. Everything else described below derives from proving you hold this secret. See [Initial Setup & Client Pairing](../1-getting-started/initial-setup.md).

---

## 2. Every API Request Is Individually Signed

Once paired, the client doesn't hold a session cookie or bearer token that grants standing access on its own. Every request to the appliance's API is individually signed using the paired secret, with a short validity window — see [REST API Reference: Authentication](./rest-api-reference.md#2-authentication) for the exact scheme. A captured request can't simply be replayed indefinitely, and there's no long-lived token that could leak and keep working on its own.

---

## 3. Moonlight & Web Streaming Use Their Own Independent Pairing

* **Moonlight/video streaming** uses its own separate PIN-based pairing step — the same protocol model used by NVIDIA GameStream-compatible clients — establishing a distinct credential from the master pairing secret above. Compromising one doesn't automatically hand over the other.
* **The [Web Client](../7-software-access/web-client.md)**'s connection is authenticated with the same request-signing scheme as the REST API, and its media transport is standard WebRTC, which mandates encryption (DTLS-SRTP) at the protocol level — browser sessions are always encrypted in transit regardless of anything else.
* **[Paired Clients](../2-kvm-vkm/video-streaming-quality.md#6-streaming-settings)** lets you review and revoke stale Moonlight pairings from the front panel — worth checking periodically, same as rotating any other credential.

---

## 4. Tailscale — an Additional, Independent Encrypted Layer

Routing a session over [Tailscale](../1-getting-started/initial-setup.md#step-3-secure-mesh-networking-onboarding-tailscale) wraps the entire connection in its own encrypted tunnel, on top of everything above — an additional layer, not a replacement for it. Being reachable on the same tailnet doesn't by itself grant access to the appliance; you still need the paired secret for every request.

> [!TIP]
> For end-to-end encryption of the video stream itself on an untrusted or shared network, connect over Tailscale (or your own VPN) rather than directly over a bare LAN — recommended for any session outside a network you fully trust.

---

## 5. Practical Recommendations

* **Treat the pairing QR/secret like a root credential.** Anyone who scans it can pair a new client with full access.
* **Give each administrator their own login** via [Users Control](../3-bios-in-terminal/technology-overview.md) instead of sharing one account.
* **Prefer Tailscale** for sessions outside a network you fully control.
* **Periodically review Paired Clients** and unpair anything you don't recognize or no longer use.
