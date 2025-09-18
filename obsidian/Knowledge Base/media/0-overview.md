# Overview — Disc → MKV → (Remux/Transcode) → Tag → Jellyfin

This is the quick start for the whole pipeline with links to the deeper docs.

```mermaid
flowchart LR
  A[Disc] --> B[MakeMKV to MKV]
  B --> C{Need Apple-native copy?}
  C -- Yes --> D[Remux to MP4]
  C -- No --> H[ ]
  B --> E{Need smaller mobile copy?}
  E -- Yes --> F[Transcode to 720p/1080p]
  E -- No --> H
  B --> G[Set flags; verify]
  D --> I[Tag MP4]
  F --> I
  G --> J[Organize & label (A/B/C)]
  I --> J
  J --> K[Jellyfin scan]
```

## Two common paths

- **Infuse household (tvOS/iOS):**
Keep **MKV-only**. Infuse (and Swiftfin with VLCKit) play MKV directly. Add MP4 only if you
introduce **AVKit-based** clients (Safari/system players).
→ See: `2-transcode.md` (“Should I keep MP4 only?”) and `5-clients.md`.

- **Mixed Apple clients:**
Keep **MKV master** + **Apple-friendly MP4** (copy video; AC‑3 5.1 + AAC stereo; text subs) +
**mobile 720p**. Label so the default sorts how you want.
→ See: `2-transcode.md`, `4-organization.md`, `5-clients.md`.

## Table of contents

- `1-rip.md` — Disc formats → MKV: audio/subs you’ll get, and why MKV first.
- `2-transcode.md` — Remux vs transcode; Apple-friendly copies; decision tables; storage math.
- `3-metadata.md` — Strategy: Embedded vs NFO vs Jellyfin scraping (+ tool commands).
- `4-organization.md` — Folder layout, naming, multiple versions, extras, images, NFO.
- `5-clients.md` — Client behavior: tvOS/iOS/Web, Swiftfin AVKit vs VLCKit, Infuse.
- `6-automation.md` — Hazel rules + scripts; standardized labels enforced.
- `7-uhd-4k.md` — Separate UHD notes.

## Standardized version labels (MKV-first)

Because your household uses **Infuse**, we’ll make **MKV sort first** by default:

- `- 1080p A-MKV.mkv`  ← default (archive, all tracks)
- `- 1080p B-AppleTV.mp4`  ← Apple-friendly remux (copy video; AC‑3 + AAC; text subs)
- `- 720p C-iPhone.mp4`  ← mobile copy (HEVC/H.264)

See `4-organization.md` for version ordering rules and `6-automation.md` for Hazel rename steps.

> **One-liner:** If your Apple clients are **Infuse**, MKV‑only is fine. Add MP4 versions only for
**AVKit‑based** clients.

## Appendices

- [A‑troubleshooting.md](A-troubleshooting.md)
- [A‑naming-style.md](A-naming-style.md)
