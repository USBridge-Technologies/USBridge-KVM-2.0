# USB-LAN Network Bridge (RNDIS)

USBridge can present itself to the target host as a **USB-to-LAN network adapter**, sharing its own uplink (Wi-Fi or a wired USB-Ethernet adapter) with the target over the same USB line used for keyboard/mouse/drives. Driver-wise it's a standard USB Ethernet interface — CDC-ECM on Linux/macOS, RNDIS on Windows — so there's nothing to install on the target.

---

## 1. Core Use Cases

* **Bare-Metal OS Deployment:** when an installer lacks a driver for the server's real NIC, USBridge exposes a compatible USB-Ethernet link instead, so the installer can still fetch packages or reach a network install source.
* **Emergency Rescue Shells:** outbound network access for diagnostic/recovery tools when the host's own production network is down or misconfigured.
* **Pre-OS Automation:** a network path for BIOS/firmware validation or bootloader automation before the primary OS (and its own NIC drivers) is even up.

---

## 2. Turning It On

| Where | What you can do |
| :--- | :--- |
| **Client app** | Toggle the network adapter on/off, and pick the bridge/router mode (see below) — device card → network adapter. |
| **Front panel** | Not currently exposed as its own toggle. |
| **REST API** | `POST /api/device/start` with `{"device": "rndis"}` (add to your existing devices with `merge: true`); `POST /api/device/stop` to tear everything down. See the [REST API Reference](../10-developer-api/rest-api-reference.md#4-usb-gadget--device-management). |
| **MCP** | `rndis.set` tool (`{"enabled": true}`) — see [AI Agent Integration (MCP)](../3-bios-in-terminal/mcp-ai-agents.md#4-tool-catalog). |

---

## 3. Bridge vs. Router — and Why Wi-Fi Only Gets One of Them

Mode is currently a **client-app-only** setting: device card → network adapter → mode menu — **Auto**, **Ether Bridge**, **Ether Router**, **Wi-Fi Router**.

| Mode | Uplink | What the target sees |
| :--- | :--- | :--- |
| **Ether Bridge** | Wired USB-Ethernet | The target's USB-Ethernet interface is bridged at Layer 2 straight onto your LAN — it gets its own IP from your LAN's DHCP server and appears as just another device on the network, same as if it were plugged directly into your switch. |
| **Ether Router** | Wired USB-Ethernet | USBridge NATs/routes between the target and your LAN instead of bridging — the target gets an IP on a private subnet from USBridge itself. Use this when true bridging isn't available or desired on your network. |
| **Wi-Fi Router** | Wi-Fi | NAT/routing only — **there's no Wi-Fi bridge mode**. A Wi-Fi client (station) association is tied to the radio's own MAC address; transparently bridging a second, foreign MAC (the target's) across that link isn't something Wi-Fi station mode supports the way a wired link does. Routing sidesteps that entirely. |
| **Auto** | Either | Picks between the above based on what uplink is actually active. |

If you specifically need the target to appear as a first-class device on your LAN (own IP from your real DHCP server, reachable directly by other machines on that LAN), that requires **Ether Bridge** — plan for a wired uplink if that's a hard requirement.

---

## 4. Performance Notes

* The bridge/NAT relay itself adds negligible overhead — it's simple packet forwarding, not a factor worth budgeting latency for on its own. Whatever latency the target experiences to the rest of the network/internet is essentially your own uplink's latency (Wi-Fi vs. wired, and whatever's beyond your gateway) — not something specific to routing it through USBridge.
* This is a separate USB function from the [video/KVM streaming path](./video-streaming-quality.md) — it doesn't share the streaming pipeline's latency characteristics.
* The Rockchip RK3566 SoC shares compute between USB networking and the real-time UVC video/encode pipeline. Sustained, high-bandwidth transfers over the USB network bridge (e.g. a large package mirror sync) can compete with that and show up as frame drops or latency spikes on your KVM video stream — this bridge is meant for diagnostic/staging traffic, not as a permanent high-throughput production link.

---

## 5. Scope

This is a temporary, diagnostic-oriented network path for system initialization, staging, and recovery — not intended as a permanent production gateway or router replacement.
