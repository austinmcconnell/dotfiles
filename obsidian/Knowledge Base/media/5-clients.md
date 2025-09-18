# 4b — Jellyfin Clients & Playback Behavior (tvOS / iOS / Web)

This file explains **Direct Play vs remux/transcode**, and how **Swiftfin (AVKit vs VLCKit)** and
**Infuse** behave with MKV/MP4.

## Default version is not device-aware

Jellyfin selects the **first** version by its ordering rules; it does **not** auto-pick per client.
If the default isn’t compatible, the server **remuxes/transcodes that same version**. Use labels to
control the default.

Docs: <https://jellyfin.org/docs/general/server/media/movies/#multiple-versions>

## Apple clients at a glance

- **AVKit / system players (Safari, “Native” player)**: prefer `.mp4/.m4v/.mov`/HLS. MKV not natively
    supported.
- **Swiftfin (VLCKit)**: plays MKV directly in-app (demux/decoding provided by VLC).
- **Infuse (tvOS/iOS)**: plays MKV directly and decodes DTS/DTS-HD/TrueHD to multichannel PCM; Atmos
    via E-AC-3 only.

> **One-liner:** If your Apple clients are **Infuse**, MKV‑only is fine. Add MP4 versions only for
**AVKit‑based** clients.

## Matrix (labels, containers, subs)

| Client | Default label (if most-used) | Container/Video | Audio | Subtitles | Notes |
|---|---|---|---|---|---|
| **tvOS (Swiftfin)** | `- 1080p B-AppleTV` or keep MKV as default and pick MP4 when desired | MP4 (H.264/HEVC copy) | AC‑3 5.1 + AAC stereo | mov_text/WebVTT | Swiftfin can often play MKV too (VLCKit). |
| **iOS (Swiftfin)** | `- 720p C-iPhone` for mobile copy | MP4 (H.264/HEVC) 720p | AAC stereo | mov_text/WebVTT | User chooses version; not auto-picked. |
| **Web (browser)** | `- 1080p B-AppleTV` (MP4 often safest) | MP4 (H.264/HEVC) | AAC/AC‑3 (varies) | Text subs | Browser container support varies; MP4 tends to avoid remux. |

For details and exact containers/subtitle compat tables, see:
<https://jellyfin.org/docs/general/clients/codec-support/>

## Verify Direct Play

- In Web client: open **Playback Info** during playback to see Direct Play/Remux/Transcode.
- In tvOS/iOS (Swiftfin): check the playback overlay; consult server logs if something transcodes
    unexpectedly.
