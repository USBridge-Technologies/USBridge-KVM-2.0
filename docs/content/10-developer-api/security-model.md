# Security & Authentication Model

USBridge doesn't rely on one shared credential for everything. Pairing/API access, Moonlight video streaming, and the browser Web Client are **three separate, independent protocols**, each with its own authentication — they don't route through each other, and compromising one doesn't hand over the others. Tailscale is a fourth, optional layer that wraps some of these paths but not others.

---

## 1. Physical Pairing — the Root of Trust for the API

Every appliance generates its own high-entropy master secret the first time it boots. That secret is never sent out over an open network on its own — it only ever leaves the device through a **physical** channel:

* **QR code** on the front-panel screen, scanned by the client's camera.
* **Manual entry**, for setups where scanning isn't convenient.

Both require someone to be physically present at the device (or trusted with the code) — there's no way to remotely guess or intercept it off the network. See [Initial Setup & Client Pairing](../1-getting-started/initial-setup.md).

## 2. Every API Request Is Individually Signed

Once paired, the client doesn't hold a session cookie or bearer token that grants standing access on its own. Every request to the appliance's REST/MCP API is individually signed using the paired secret, with a short validity window — see [REST API Reference: Authentication](./rest-api-reference.md#2-authentication) for the exact scheme. A captured request can't simply be replayed indefinitely, and there's no long-lived token that could leak and keep working on its own.

---

## 3. Moonlight Video Streaming — a Completely Separate Protocol

Video/input streaming to the desktop and mobile clients runs over **Moonlight**, which is not the API from §1–2 at all — it's a distinct network path with its own pairing step, unrelated to the master secret:

* **Its own pairing:** a one-time PIN-based handshake — the same protocol model used by NVIDIA GameStream-compatible clients — establishes a Moonlight-specific credential the first time a client connects. Getting the master secret from §1 doesn't skip this step, and pairing Moonlight doesn't grant any API access from §1–2.
* **Manage it independently:** **Paired Clients** (front panel, under Moonlight settings) lists every client paired this way and lets you **Unpair** one immediately — worth reviewing periodically, same as rotating any other credential. See [Streaming Settings](../2-kvm-vkm/video-streaming-quality.md#6-streaming-settings).

## 4. The Web Client — Also Its Own Protocol, Not Related to Moonlight

The browser-based [Web Client](../7-software-access/web-client.md) does **not** go through Moonlight pairing at all — it's a third, independent path:

* **Authentication:** the browser session is authenticated with the same request-signing scheme as the REST API (§2), reusing the master secret from §1 — not a Moonlight PIN.
* **Media transport:** real WebRTC, which mandates encryption (DTLS-SRTP) at the protocol level — browser sessions are always encrypted in transit, independent of anything else on this page.

Moonlight and the Web Client run side by side, not through one another — a Moonlight pairing has no bearing on Web Client access, and vice versa.

---

## 5. Tailscale — an Additional Layer, but Not for Every Path

Routing a session over [Tailscale](../1-getting-started/initial-setup.md#step-3-secure-mesh-networking-onboarding-tailscale) wraps the connection in its own encrypted tunnel, on top of whichever protocol above is carrying it — an additional layer, not a replacement for any of them. Being reachable on the same tailnet doesn't by itself grant access; you still need the credential each path above requires.

This applies to the API (§1–2) and Moonlight (§3) sessions routed through a tailnet address. The Web Client (§4) doesn't get this extra layer — a browser can't establish a Tailscale tunnel on its own — so its security stands entirely on its own request signing plus WebRTC's mandatory encryption, regardless of whether Tailscale is otherwise in use.

> [!TIP]
> For end-to-end encryption of the Moonlight video stream itself on an untrusted or shared network, connect over Tailscale (or your own VPN) rather than directly over a bare LAN — recommended for any session outside a network you fully trust. The Web Client is already encrypted in transit by WebRTC regardless.

### 5.1 Tailscale-Only Access — Closing the LAN Surface Entirely

Everything above still leaves the API and KVM SSH console reachable on the LAN, credential-gated but network-reachable. **Tailscale-Only Access** (front panel: **Settings → Authentication → Tailscale**) goes a step further and removes that surface instead of just gating it:

* Once the appliance is **registered on a tailnet**, every LAN-facing listener for both the REST/MCP API and the KVM SSH console is torn down — only `127.0.0.1` (local/on-device access) and the appliance's tailnet IP stay reachable. There is no longer a LAN route to try a credential against in the first place.
* It's **one switch** for both surfaces — the same toggle governs the API and SSH console together, so there's no way to lock down one and forget the other.
* **Bootstrap safety:** if you turn this on *before* the device has finished registering (no tailnet IP yet), LAN is deliberately kept reachable — otherwise a device that already has this set (e.g. restored from a saved config) could have no way to be reached to register at all. The moment registration completes, the very next reconcile pass (a few seconds later) closes LAN on its own — no extra step, no restart, and no window where you have to remember to come back and lock it down yourself.
* Turning the switch back off reopens LAN immediately, registered or not.

### 5.2 Paranoia Mode

**Tailscale-Only Access (§5.1) + WebRTC turned off** (same Authentication menu — see [Web Client](../7-software-access/web-client.md)) together are what we call **Paranoia Mode**: no LAN-facing API or SSH listener, and no local WebRTC signaling endpoint either — the entire appliance is reachable only through an already-authenticated tailnet session. The trade-off is the Web Client stops working (it depends on WebRTC and can't establish a Tailscale tunnel itself, per §4 above) — use the desktop/mobile client over Tailscale instead.

---

## 6. Practical Recommendations

* **Treat the pairing QR/secret like a root credential.** Anyone who scans it can pair a new client with full API access — but even full API access doesn't put your snapshot history at risk: there's no API or screen path that deletes or formats existing snapshots, only physical access to the device or the card itself. See [Security & Data Protection](../4-snapshots-state-management/security-storage.md#3-no-automated-deletion-and-no-remote-way-to-erase-snapshots).
* **Give each administrator their own login** via [Users Control](../3-bios-in-terminal/technology-overview.md) instead of sharing one account.
* **Prefer Tailscale** for API/Moonlight sessions outside a network you fully control.
* **For the strictest lockdown, enable Paranoia Mode** (§5.2) — Tailscale-Only Access plus WebRTC off — so the appliance has no LAN-reachable API/SSH surface at all.
* **Periodically review Paired Clients** and unpair anything you don't recognize or no longer use.
