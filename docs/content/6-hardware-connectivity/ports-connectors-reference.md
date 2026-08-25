# Ports & Connectors Reference

![USBridge Physical Ports Reference](https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Ports.png)

| Port | Type | What it's for |
| :--- | :---: | :--- |
| **USB-C (OTG / Power)** | Input / Output | Powers the appliance (5V/3A) and is the line the target host sees — [keyboard, mouse, and virtual drives](../2-kvm-vkm/keyboard-mouse-control.md) all emulate through here. |
| **USB-C (Host)** | Input | Connects the [HDMI capture dongle](../2-kvm-vkm/video-streaming-quality.md). Need this port for something else too (RNDIS uplink, external storage)? Route both through an external hub — see [USB-LAN Network Bridge](../2-kvm-vkm/network.md#1-core-use-cases). |
| **8-pin GPIO Port** | Control | Connects the [Power Management Module](./power-management-module-control.md) for remote Power/Reset control on the target. |
| **MicroSD Slot** | Storage | Backing media for [immutable snapshots](../4-snapshots-state-management/snapshots-overview.md). |
| **Micro HDMI Port** | Output | Local monitor passthrough — mirrors the captured signal at the rack without a client session. |

See [Core Hardware Architecture](./architecture.md) for what's driving all of this, and [What's in the Box](../1-getting-started/whats-in-the-box.md) for what ships with the unit.
