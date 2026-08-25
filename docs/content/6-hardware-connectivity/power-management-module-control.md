# Power Management Module Control

The Power Management Module is what turns USBridge from "watch and type" into full out-of-band control: it wires into the target's own front-panel headers, so you can power-cycle or hard-reset a machine that's completely unresponsive — no OS, no BMC, no one physically at the rack required.

---

## What It Does

* **Cold-boot recovery.** Power/Reset control that works even when the target is fully frozen — this is the path for hosts a graceful OS-level reboot can't reach.
* **Galvanic isolation.** Dual optocouplers keep the appliance's control circuit electrically separate from the target's — ground loops, voltage spikes, and EMI from the managed machine don't reach USBridge.
* **Full signal monitoring, not just control.** Wires into Power SW, Reset SW, Power LED, and HDD LED — so beyond pressing the button, you can read the target's actual LED state back. See [`pcpanel.leds`/`pcpanel.button`](../10-developer-api/rest-api-reference.md#11-hardware-rndis-powerreset-panel) in the REST API, or the equivalent [MCP tools](../3-bios-in-terminal/mcp-ai-agents.md#4-tool-catalog) for driving it from a script or an AI agent.
* **One connector, no wiring puzzle.** Plugs straight into the appliance's [8-pin GPIO port](./ports-connectors-reference.md) with the included ribbon cable.
* **Confirmation before anything destructive.** The [client app](../7-software-access/desktop-app.md) requires a 2-second press-and-hold on a **Hold to Confirm** button before it actually presses Power or Reset — power-cycling a live server isn't a misclick away.

---

## Specifications

| Parameter | Specification |
| :--- | :--- |
| **Output Type** | Dual-channel optoisolated (MOSFET/SSR) |
| **Signal Lines** | Power SW, Reset SW, Power LED, HDD LED |
| **Interface** | 8-pin 2.54mm GPIO header (ribbon cable included) |
| **Protection** | Galvanic isolation, up to 3.75kV |
| **Mounting** | Direct-to-case or standalone PCB |

Manufacturing files (Gerbers, schematics) are public: see [3D Models & PCB Files](../9-updates-changelog/3d-models-pcb-files.md).
