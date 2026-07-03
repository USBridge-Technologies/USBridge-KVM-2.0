# BIOS Automation & AI Agent Integration

The **BIOS-in-Terminal** engine processes raw BIOS screen pixels into structured, machine-readable text data accessible via standard SSH, local scripts, or API protocols. This architecture fundamentally shifts pre-OS infrastructure management from manual visual observation to deterministic, programmatic control at Layer 0.

---

## Automation Architecture: BIOS as Data

By transforming physical video frames into an interactive text grid while preserving semantic context, administrators can deploy advanced automation frameworks directly at the hardware level, completely eliminating fragile "pixel-hunting" macro scripts.

| Automation Layer | Technical Application & Execution |
| :--- | :--- |
| **Embedded Starlark Scripts** | Run native, non-blocking scripts written in Python syntax directly inside the USBridge client application to automate firmware settings. |
| **AI Agents via MCP Proxy** | Connect advanced Large Language Models (LLMs) directly to the physical server console using the Model Context Protocol. |
| **Fleet Telemetry Pipelines** | Programmatically query hundreds of bare-metal servers simultaneously to audit BIOS versions and configurations without any OS or BMC dependencies. |

---

## In-Client Scripting (Starlark Engine)

The automation manager is embedded directly into the native USBridge application layer and executes robust scripts using **Starlark** (a dialect of Python). Because the system operates on recognized text data rather than raw screen coordinates, automation loops interact with actual terminal strings, preventing scripts from breaking due to minor UI shifting.

### Step 1: Managing Scripts in the Interface

To manage your automation routines, navigate to the management interface inside the client app:

1. Open your native USBridge-Remote client application.
2. Click on the **Scripts** tab in the main navigation menu.
3. Use the action controls to manage your deployment:
   * **Create:** Click the **+ New (eMMC)** or **+ New (SD)** buttons to initialize a new script file (`.star`) on the chosen storage media.
   * **Run:** Click the green **Play** button next to any script to execute it immediately against the active KVM session.
   * **Edit:** Click the **Pencil** icon to open the embedded code editor.
   * **Delete:** Click the red **Trash** icon to permanently remove the script file.

![USBridge Client Scripting](https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Client_Scripting.png)

---
### Step 2: Writing and Editing Starlark Scripts

Clicking the **Edit** icon opens the built-in IDE environment where you can write your low-level macros using structured Python syntax.

![USBridge Client Scripting](https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Client_Scripting2.png)

When writing automation scripts, the engine provides direct hooks into the target hardware session:
* **String Detection:** The engine reliably scans the screen state and waits for explicit strings (e.g., waiting for `"Aptio Setup Utility"` to render in the buffer before executing commands).
* **Keystroke Injection:** It injects exact hardware keyboard scan-codes (e.g., standard keys, arrows, or combinations like `Ctrl+Alt+Del`) via the USB-HID emulation layer to bypass manual inputs.

#### Production Script Example
Below is a standard automation script designed to force-reboot a server and spam the necessary key scan-codes until the host safely enters the BIOS menu:

```python
# name: Enter BIOS
# desc: Ctrl+Alt+Del, then spam DEL/F2 until a BIOS screen appears (up to 60s).
#       Automatically closes the "Previous Values?" dialog if it pops up.

# USB HID key codes used below:
#   0x4C = Delete  0x3B = F2  0x29 = Escape
# Modifier bits: Ctrl=0x01  Alt=0x04  Ctrl+Alt=0x05

def main():
    print("Sending Ctrl+Alt+Del...")
    key_combo(0x05, 0x4C)   # Ctrl+Alt+Del
    sleep(8000)              # Wait for reboot / USB reconnect

    print("Spamming DEL + F2 to enter BIOS...")
    for i in range(120):     # 120 * ~500 ms = ~60 seconds total
        key_press(0x4C)      # Delete
        sleep(150)
        key_press(0x3B)      # F2
        sleep(150)

        if screen_match("bios|aptio|setup utility|uefi|firmware|boot manager"):
            print("BIOS detected!")

            # Some boards show a "Previous Values?" / "Load Previous Values?" dialog
            # right after POST. Close it with a single ESC so we land on the main menu.
            sleep(300)
            if screen_contains("Previous Values"):
                print("Closing Previous Values dialog (ESC)...")
                key_press(0x29)   # Escape
                sleep(500)

            print("Done.")
            return

        sleep(200)

    print("Timed out — BIOS screen not detected within 60 s")

main()

```
Click Save to commit changes to the USBridge appliance storage, or click Run to instantly execute and test the logic in real-time.

## Integrating AI Agents via Model Context Protocol (MCP)

To enable autonomous debugging, auditing, or remediation, you can bridge external context-aware AI agents (such as Anthropic Claude) directly into the physical server session. The USBridge-Remote application includes an embedded **MCP Proxy** that translates the live OCR text stream and hardware control layer into structured tools that an LLM can understand.

Once connected, the AI agent gains the ability to:
* **Read the Screen:** Analyze the live text-grid representation of the BIOS/UEFI console.
* **Inject Keystrokes:** Programmatically send keystrokes (arrows, Enter, Function keys) to navigate menus.
* **Control Media:** Mount or unmount virtual ISO/IMG drives via hardware storage emulation for autonomous OS provisioning or recovery.

### Configuration Steps

1. Open the USBridge-Remote client and navigate to the **Scripts** tab.
2. Toggle the **MCP Proxy Server** switch to **Enabled**.
3. Click the **Copy Connection String** button to copy the local server endpoint URL to your clipboard.

![USBridge Client Scripting](https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Client_Scripting_MCP.png)

5. Paste the connection string into your AI Agent's configuration file (e.g., your local Claude Desktop configuration `claude_desktop_config.json` or custom developer pipeline):

## Operational Capabilities

* **Autonomous Auditing:** The neural network can independently "read" the rendered terminal screen, navigate through complex tab arrays, and execute complete configuration audits.
* **Intelligent Triage:** Instead of executing blind macros, the AI agent dynamically interprets unpredictable error screens (e.g., detecting a `"RAID Critical"` flag or a dead CMOS battery due to a reset system date) and takes logical recovery actions.
* **Natural Language Control:** Instruct your AI infrastructure fleet manager to *"Verify boot priority settings on node-04 and enable Virtualization Extensions if turned off,"* allowing the agent to handle the low-level console navigation autonomously.
