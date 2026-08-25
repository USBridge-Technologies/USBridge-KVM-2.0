# Firmware Update Guide

USBridge-KVM 2.0 updates itself over the network using **[Mender](https://mender.io)**, an open-source, A/B (dual-partition) OTA update framework — the same class of mechanism used on production IoT/embedded fleets. There is no manual flashing or physical media swap required for a routine update.

---

## 1. Checking for and Applying an Update

From the front panel: **Settings → Updates**.

| Button | Action |
| :--- | :--- |
| **[1] / OK** | Check for an update. The screen polls Mender's own service logs and shows live status: `Downloading...` → `Installing...` → result. |
| **[2]** | Commit the currently-running update. |

The screen also shows the appliance's current firmware version and its [license/trial status](../8-maintenance-support/faq.md).

> [!IMPORTANT]
> **Why the separate Commit step matters.** Mender's A/B model installs an update to the *inactive* partition and boots into it — but the update is not made permanent until you explicitly **Commit** it. This is a safety net: if the new firmware fails to boot or misbehaves, the device can fall back to the previous, known-good partition instead of being stuck on a bad update. Don't skip the Commit step once you've confirmed the device is working normally on the new version — an uncommitted update is not yet the durable state of the device.

---

## 2. What Happens During an Update

1. The appliance checks in with the update server and downloads the new artifact if one is available.
2. The artifact is written to the inactive partition — the currently-running system keeps operating normally throughout.
3. The device reboots into the new partition.
4. You verify the device is healthy, then **Commit** from the Updates screen to make the switch permanent.

Updates are cryptographically verified before being written; a corrupted or unsigned artifact is rejected rather than applied.

---

## 3. Licensing & Updates Are Independent

The trial/licensing mechanism (see [FAQ](../8-maintenance-support/faq.md)) uses the same class of device-authentication infrastructure as the update system, but the two are separate concerns: a device stuck in trial or locked state can still check for and apply firmware updates. Confirming a device's license (Accept) does not require an update, and updating does not by itself change license state.
