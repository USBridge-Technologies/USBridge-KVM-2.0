# Audio Redirection

USBridge captures the target's HDMI audio alongside its video and streams both together over [Moonlight](./video-streaming-quality.md) — you hear the target the same way you see it, with no separate audio setup on your side.

---

## Target-Side Requirement

The target's OS has to actually be sending audio out over HDMI/DisplayPort for there to be anything to capture. In the target's audio settings, select the **HDMI/DisplayPort digital output** corresponding to the USBridge connection as the playback device — same as you would for any external HDMI display or capture card.

> [!NOTE]
> No signal below the OS. Legacy text-mode BIOS menus don't generate an audio signal at all — this is a target-hardware limitation, not something USBridge can work around. Audio shows up the moment the target's own audio driver initializes, whether that's early UEFI graphics or a fully booted OS.

---

## Multiple Capture Devices

If the appliance has more than one audio-capture-capable device attached, pick which one to stream from — see [`GET /api/audio/devices`](../10-developer-api/rest-api-reference.md#7-video--audio) in the REST API Reference. Most setups only ever see one (the HDMI capture path) and never need to touch this.
