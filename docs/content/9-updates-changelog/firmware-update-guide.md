# Firmware Update Guide

USBridge-KVM 2.0 updates itself over the network using a dual-partition (A/B) OTA mechanism — there's no manual flashing or physical media swap required for a routine update.

---

## 1. Checking for and Applying an Update

From the front panel: **Settings → Updates**.

| Button | Action |
| :--- | :--- |
| **[1] / OK** | Check for an update. The screen shows live status: `Downloading...` → `Installing...` → result. |

The screen also shows the appliance's current firmware version and its [license/trial status](../8-maintenance-support/faq.md).

> [!TIP]
> **Check right after first connecting to the network.** Run a manual **Check for update** here as a standard step of first-time setup (see [Quick Start Guide](../1-getting-started/quick-start.md)), not only when you suspect you're out of date.

> [!NOTE]
> The appliance has no battery-backed clock, so a **Check for update** run in the first minute or two after connecting to the network can fail with an error — it's waiting on an NTP time sync that hasn't finished yet, not an actual update failure. Give it a minute and try again if the very first check right after connecting errors out.

---

## 2. What Happens During an Update

1. The appliance checks in and downloads the new firmware if one is available.
2. It's written to the inactive partition — the currently-running system keeps operating normally throughout.
3. The device reboots into the new partition and automatically commits the update upon a successful boot.

Updates are cryptographically verified before being applied; a corrupted or unsigned update is rejected.

---

## 3. Licensing & Updates Are Independent

See [FAQ](../8-maintenance-support/faq.md) for how the trial/license works. The two are separate: a device still in trial (or locked) can check for and apply firmware updates same as a licensed one, and applying an update doesn't by itself change license state.

---

## 4. Full Reflash from Scratch (eMMC, via USB)

If the appliance is not booting, has no network path yet, or you need to completely wipe and reflash the eMMC from scratch, you must perform a full physical recovery reflash over USB (using Maskrom mode).

This is a separate process — see the **[USB Recovery Flashing Guide](./recovery-flashing-guide.md)** for step-by-step instructions.
