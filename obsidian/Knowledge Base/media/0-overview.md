# Overview — Disc to Jellyfin (v2)

This is the **starting point**. It shows the entire flow, the two common "paths", and links into the
details.

## Goals (recap)

- **MKV-first** archival rips (bit-perfect video/audio, full subtitles).
- **Optional** Apple-friendly MP4 remuxes (copy video; AC-3/AAC audio; text subs) and **optional**
  smaller mobile encodes.
- **Jellyfin**-friendly naming/versions, **NFO-first** metadata, and **Hazel** automation.

> **If your Apple clients are Infuse, MKV-only is fine. Add MP4 versions only for AVKit-based
> clients (e.g., Safari, Native players).**

## Flow

```mermaid
flowchart LR
  A[Disc] --> B[MakeMKV to MKV]
  B --> C{Need Apple-native?}
  C -- Yes --> D[Remux to MP4 (copy video; AC-3 & AAC, mov_text/VTT)]
  C -- No --> H
  B --> E{Need small mobile?}
  E -- Yes --> F[Transcode to HEVC / H.264 720p/1080p]
  E -- No --> H[ ]
  B --> G[Set flags (mkvpropedit); verify (MediaInfo)]
  D --> I[Tag (Subler/AtomicParsley)]
  F --> I
  G --> J[Organize & label (A/B/C) to 4a-organization.md]
  I --> J
  J --> K[Jellyfin scan]
```text

## Paths

### Path A — **Infuse household (MKV-first)**
- Keep only the **MKV** archive per title, labeled as **`- A-1080p MKV`** (or the correct `p` for
  DVDs).
- Optionally add a **mobile 720p** for iPhone: **`- C-720p iPhone`**.
- Skip MP4 unless you also use **AVKit-based** players.

### Path B — **Mixed Apple clients**
- Keep **MKV** archive (**`- A-1080p MKV`**).
- Add **MP4 remux** (**`- B-1080p AppleTV`**) for native iOS/tvOS/Safari direct-play.
- Optionally add **mobile** (**`- C-720p iPhone`**).

## Standard labels (enforced via Hazel)
- `A-<resolution> MKV` — archival default (e.g., `A-1080p MKV`, `A-480p MKV`).
- `B-<resolution> AppleTV` — Apple-friendly remux.
- `C-<resolution> iPhone` — small mobile encode.

## Where to go next
- **1-rip.md** — What actually comes off the disc (DVD vs Blu-ray audio/subs), why MKV preserves
  everything.
- **2-transcode.md** — How to adapt for Apple/mobile; decision tables; storage math.
- **3-metadata.md** — NFO-first strategy, embedded vs scraping, Subler vs NFO side-by-side.
- **4a-organization.md** — Folder structure, naming, versions, extras, local images/NFO.
- **4b-jellyfin-clients.md** — tvOS vs iOS vs Web; Swiftfin AVKit vs VLCKit; Infuse.
- **5-automation.md** — Hazel rules + scripts (label enforcement, resolution detection).
- **7-uhd-4k.md** — UHD-only notes (separate).


## Appendices
- [A-naming-style.md](sandbox:/mnt/data/A-naming-style.md)
- [A-troubleshooting.md](sandbox:/mnt/data/A-troubleshooting.md)
