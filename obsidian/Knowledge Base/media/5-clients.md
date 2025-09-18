# 4b-jellyfin-clients.md — Clients, Direct Play, and Version Defaults

This page explains **client behavior** (tvOS/iOS/Web), **Swiftfin player modes**, **Infuse**, and
how to make the **right version** play by default.

## Direct Play vs Remux vs Transcode (Jellyfin)

- **Direct Play:** client supports container + video + audio + subs as‑is → best quality/no server
  work.
- **Direct Stream (remux/partial):** small conversion (e.g., container ONLY, or audio ONLY).
- **Transcode:** re‑encode video and/or audio → highest server load.
Docs: <https://jellyfin.org/docs/general/clients/codec-support/> ·
<https://jellyfin.org/docs/general/post-install/transcoding/>

## Apple ecosystem — AVKit vs VLCKit vs Infuse

- **AVKit/AVPlayer** (Safari, system player, “Native” Swiftfin) favors **.mp4/.m4v/.mov/HLS**;
  **MKV** typically needs **remux** and **DTS/TrueHD** often needs **audio transcode**.
- **Swiftfin (VLCKit)** can **demux MKV** and decode many codecs in‑app → more MKV direct‑play
  scenarios.
- **Infuse** (tvOS/iOS) plays **MKV** directly and decodes DTS/TrueHD to multichannel PCM locally;
  great for MKV‑first libraries.

> **One‑liner:** If your Apple clients are **Infuse**, MKV‑only is fine. Add MP4 versions only for
> **AVKit‑based** clients.

## Picking the default version

Jellyfin plays **the first version** in its sorted list; it **does not** pick a version per device
automatically. Use **labels** for deterministic order:

- **MKV‑first (recommended for Infuse households)**
  - `- A-1080p MKV`  ← default
  - `- B-1080p AppleTV`
  - `- C-720p iPhone`

- **Apple‑first (for AVKit‑heavy households)**
  - `- A-1080p AppleTV`  ← default
  - `- B-1080p MKV`
  - `- C-720p iPhone`

Docs (multiple versions & ordering):
<https://jellyfin.org/docs/general/server/media/movies/#multiple-versions>

## Verify Direct Play

- **Web:** start playback → “...” → **Playback Info**; confirm **Direct Play**/**Direct
  Stream**/**Transcode**.
- **tvOS/iOS:** similar indicators in Swiftfin; server logs also note transcoding.
If you see unexpected transcodes, check: container, audio codec (DTS/TrueHD on Apple), and subtitle
type (PGS in MP4 forces work).
