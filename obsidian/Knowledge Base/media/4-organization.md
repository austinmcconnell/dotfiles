# 4a-organization.md — Jellyfin Folder Layout, Naming, Versions, Extras

This is the **concise reference** for putting files on disk so Jellyfin scans cleanly and groups
versions correctly.

## Library (Movies)

- **Type:** Movies. Point to `/media/movies`. Enable **Embedded Image Extractor** if you embed art
  in MKV/MP4. Prefer **NFO‑first** metadata.

## Folder & naming

```text
/media/movies/
  Movie (2009)/
    Movie (2009) - A-1080p MKV.mkv       # archival default
    Movie (2009) - B-1080p AppleTV.mp4   # Apple-friendly remux
    Movie (2009) - C-720p iPhone.mp4     # mobile
    Movie (2009).nfo
    poster.jpg
    backdrop.jpg
```text
- Stick to `Title (Year)` folder.
- Append **“ - LABEL”** to group versions; **A/B/C** prefixes give predictable default order
  (alphabetical).
- Include the **resolution** in labels for clarity: `A-1080p MKV`, `B-1080p AppleTV`, `C-720p
  iPhone`.

## Multiple versions — ordering
- Jellyfin sorts versions by: **(1) resolution labels that end in `p`/`i` (desc), then (2)
  alphabetical.**
- To avoid surprises, rely on **A/B/C** prefixes for deterministic ordering (MKV‑first).
- Files with identical base name but **no label** may be treated as separate items. Always label.

Docs: <https://jellyfin.org/docs/general/server/media/movies/#multiple-versions>

## External subtitles & audio sidecars
Use language and flags in filenames (examples):
```text
Movie (2009).default.srt
Movie (2009).default.en.forced.ass
Movie (2009).en.sdh.srt
Movie (2009).English Commentary.en.mp3
```text
Flags: `default`, `forced|foreign`, `sdh|cc|hi`. (*Note:* `hi` can collide with Hindi; use `en.hi`.)
Docs: <https://jellyfin.org/docs/general/server/media/movies/#external-subtitles-and-audio-tracks>

## Extras
- **Folders:** `featurettes/`, `trailers/`, `behind the scenes/`, `deleted scenes/`, `interviews/`,
  `clips/`, `shorts/`, `other/`, `extras/`.
- **Suffixes:** `-trailer`, `-featurette`, `-clip`, etc.
Docs: <https://jellyfin.org/docs/general/server/media/movies/#extras>

## Images (local & embedded)
- Place **poster.jpg**, **backdrop.jpg** (multiple via `backdrop-1.jpg`), **logo.png**, etc., next
  to the movie.
- Embedded images are read when **Embedded Image Extractor** is enabled.
Docs: <https://jellyfin.org/docs/general/server/media/movies/#metadata-images>
