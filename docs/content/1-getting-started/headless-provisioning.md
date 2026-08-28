# Headless & Bulk Provisioning (`usbridge_provision.json`)

For appliances with no attached display, or when you need to configure many units without pairing each one by hand through the client app, USBridge-KVM 2.0 supports fully unattended provisioning from a JSON file on a removable drive.

---

## How It Works

1. Create a file named `usbridge_provision.json` (see format below).
2. Copy it to the root of a MicroSD card or a plain USB flash drive — FAT32, exFAT, and ext4 are all supported, and the appliance scans both `mmcblk*` and `sd*` block devices, so any drive plugged into the unit is picked up.
3. Insert the drive into the appliance and power it on (or plug it in while already running).
4. On boot, the appliance finds the file, validates it, and applies it automatically.

If the appliance detects a physically connected front-panel display (via the button pull-up resistors), it shows a confirmation prompt before applying the config. With no display detected, the config is applied unattended — there's no way to answer a confirmation prompt without physical buttons.

---

## Example `usbridge_provision.json`

```json
{
  "master_key": "my-secret-key-123",
  "interfaces": {
    "eth0": {
      "mode": "static",
      "ip": "192.168.1.100/24",
      "gateway": "192.168.1.1",
      "dns": "8.8.8.8"
    },
    "wlan0": {
      "mode": "dhcp",
      "ssid": "MyWiFi",
      "password": "MyPassword"
    }
  },
  "users": [
    {
      "username": "admin",
      "password": "securepassword123"
    }
  ],
  "sshkvm_enabled": true,
  "mcp_enabled": true,
  "webrtc_enabled": true,
  "moonlight_enabled": true,
  "hdmi_passthrough": true,
  "no_change_config": false
}
```

- The `/24` suffix on `ip` is optional and sets the subnet mask (any prefix length works, e.g. `/16`); omit it and the mask defaults to `/24`.
- All five feature toggles at the bottom are optional — an absent field leaves the appliance's current setting untouched. `sshkvm_enabled`, `mcp_enabled`, and `hdmi_passthrough` take effect immediately; `webrtc_enabled` and `moonlight_enabled` are picked up on the next boot.

---

## Security: One-Shot Application by Default

> [!IMPORTANT]
> Once the config is applied, the appliance **deletes `master_key` from the file** and **renames it** to `usbridge_provision.applied.json` on the drive. This prevents the key from sitting around in plaintext and keeps the same config from silently re-applying on every future reboot. To push a new configuration, just drop a fresh `usbridge_provision.json` on the drive.

---

## Bulk Deployment: `no_change_config`

If you're provisioning a whole fleet of appliances from **one single drive** — plug it into unit A, power on, unplug, plug into unit B, and so on — the default one-shot behavior gets in the way, since the file is gone (renamed) after the very first unit.

Set `"no_change_config": true` to opt out of that cleanup:

```json
{
  "master_key": "my-secret-key-123",
  "sshkvm_enabled": true,
  "no_change_config": true
}
```

With `no_change_config: true`:
- `master_key` is **not** erased from the file.
- The file is **not** renamed to `usbridge_provision.applied.json`.
- `usbridge_provision.json` stays exactly as-is on the drive, ready to be applied again on the next appliance it's plugged into.

This is intended for controlled, manual bulk-deployment workflows (e.g. initial fleet setup on a bench) where the same master key and config are deliberately reused across units. Since the master key is never erased in this mode, treat the drive itself as a credential and store it accordingly once the rollout is done.

Default is `false` (or the field omitted entirely) — normal single-use behavior: erase the key and rename the file after applying.

---

For how the master key and Tailscale pairing secure the client-facing API, see [Initial Setup & Client Pairing](./initial-setup.md) and [Security & Authentication Model](../10-developer-api/security-model.md).
