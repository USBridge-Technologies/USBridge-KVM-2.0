# Automation & AI Agents: Overview

Because BIOS-in-Terminal turns the target's screen into structured, machine-readable text instead of raw video, the same recognized-text feed backs three layers of automation — from a human clicking one script on the front panel, up to an LLM agent driving the console autonomously.

---

## 1. The Three Layers

| Layer | What it is | Where it runs | Reference |
| :--- | :--- | :--- | :--- |
| **On-device Event Log** | Chronological record of device activity, authentication events, and system errors — including the `print()` output of any script that runs, live. | Front panel **Event Log** menu; see [Onboard Device Status & Menu Navigation](../1-getting-started/device-status-menu.md). | — |
| **Starlark scripts** | Small `.star` programs that read the screen via OCR and drive the keyboard/mouse/media directly on the appliance — no host-side agent, no "pixel-hunting" macros. | Executed on the appliance itself; started from the front panel, the client app, or the REST/MCP APIs. | [Starlark Scripting Reference](./scripting-automation.md) |
| **MCP AI agents** | The appliance's built-in Model Context Protocol server, giving an LLM agent (e.g. Claude) the same screen-read/keyboard/media tools a script has, driven by natural-language instructions instead of a fixed program. | The agent runs wherever you run it (locally, in an SSH tunnel, or on your LAN/tailnet) and talks to the appliance's JSON-RPC endpoint. | [AI Agent Integration (MCP)](./mcp-ai-agents.md) |

A script and an MCP agent can both call the same underlying operations (`key_press`/`keyboard.send`, `screen_text`/`screen.get`, `insert_media`/`media.insert`, …) — a script is the deterministic, repeatable version of a task; an MCP agent is the flexible, ask-it-anything version. In practice, an agent asked to do something non-trivial should itself prefer writing and running a script over looping raw keystrokes turn by turn — see [Prefer Scripts Over a Raw Tool-Call Loop](./mcp-ai-agents.md#5-prefer-scripts-over-a-raw-tool-call-loop).

---

## 2. Boot Automation Example

A common pattern combines all three: a Starlark script waits for POST, spams the vendor's "enter setup" key until the BIOS/UEFI screen is recognized by OCR, makes the required change, and reboots — with every step's `print()` output landing in the Event Log so you can audit exactly what happened, whether the script was triggered by a person on the front panel or by an AI agent calling `scripts.run` over MCP.

See the full example in the [Scripting Reference](./scripting-automation.md#4-example-script).
