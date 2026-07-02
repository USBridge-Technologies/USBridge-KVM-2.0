# BIOS Automation & AI Agent Integration

The **BIOS-in-Terminal** engine processes raw BIOS screen pixels into structured, machine-readable text data accessible via standard SSH, local scripts, or API protocols. This architecture fundamentally shifts pre-OS infrastructure management from manual visual observation to deterministic, programmatic control at Layer 0.

---

## 1. Automation Architecture: BIOS as Data

By transforming physical video frames into an interactive text grid while preserving semantic context, administrators can deploy advanced automation frameworks directly at the hardware level, completely eliminating fragile "pixel-hunting" macro scripts.

| Automation Layer | Technical Application & Execution |
| :--- | :--- |
| **Embedded Starlark Scripts** | Run native, non-blocking scripts written in Python syntax directly inside the USBridge client application to automate firmware settings. |
| **AI Agents via MCP Proxy** | Connect advanced Large Language Models (LLMs) directly to the physical server console using the Model Context Protocol[cite: 1]. |
| **Fleet Telemetry Pipelines** | Programmatically query hundreds of bare-metal servers simultaneously to audit BIOS versions and configurations without any OS or BMC dependencies[cite: 1]. |

---

## 2. In-Client Scripting (Starlark Engine)

Forget about legacy macro utilities that break when a UI element shifts by a single pixel[cite: 1]. The automation manager is embedded directly into the native USBridge application layer and executes robust **Starlark (Python syntax)** scripts[cite: 1].

Because the system operates on recognized text data rather than raw coordinates, your automation loops interact with actual strings[cite: 1]:
* The script reliably waits for a specific string (e.g., `"Aptio Setup Utility"`) to render in the terminal buffer[cite: 1].
* It verifies exact cell values (e.g., confirming a sub-menu status reads `"Disabled"`).
* It injects the precise hardware keyboard scan-codes (e.g., `Escape`, `Arrow Down`, `Enter`) to change boot orders, clear CMOS warnings, or toggle Secure Boot flags[cite: 1].

```python
# Example: Waiting for a specific BIOS menu state before navigation
def main():
    # Wait for the main AMI setup utility header to appear
    session.wait_for_text("Aptio Setup Utility", timeout_sec=30)
    
    # Navigate to the Boot options tab using physical keystrokes
    session.send_keystroke("ArrowRight")
    session.send_keystroke("ArrowRight")
    
    # Audit if the desired boot order item is highlighted
    if session.has_text("UEFI: Built-in EFI Shell"):
        session.send_keystroke("Enter")
```
## Hardware-Level AI Automation (Model Context Protocol)

[cite_start]Translating a live video stream into a structured console text path opens the door for autonomous machine management. [cite_start]Through the native integration of the **Model Context Protocol (MCP)**, you can bridge external context-aware AI agents (such as Claude) directly into the physical KVM session.

```text
[External AI Agent / LLM] 
       │ (Model Context Protocol / MCP)
       ▼
[USBridge On-Board MCP Proxy]
       │ (Real-Time Offline OCR)
       ▼
[Target Server BIOS Text Stream]
```

### Operational Capabilities

* [cite_start]**Autonomous Auditing:** The neural network can independently "read" the rendered terminal screen, navigate through complex tab arrays, and execute complete configuration audits[cite: 1].
* [cite_start]**Intelligent Triage:** Instead of executing blind macros, the AI agent dynamically interprets unpredictable error screens (e.g., detecting a `"RAID Critical"` flag or a dead CMOS battery due to a reset system date) and takes logical recovery actions[cite: 1].
* **Natural Language Control:** Instruct your AI infrastructure fleet manager to *"Verify boot priority settings on node-04 and enable Virtualization Extensions if turned off,"* allowing the agent to handle the low-level console navigation autonomously.
