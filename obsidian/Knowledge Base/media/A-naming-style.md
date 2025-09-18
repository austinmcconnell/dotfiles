# A-naming-style.md — Naming & Labels (Jellyfin-friendly)

A tiny style guide so every title scans cleanly and sorts the way we expect.

## Base pattern

```text
Title (Year) - LABEL.ext
```text
- **One folder per movie:** `Title (Year)`
- **Version label required** after a space‑hyphen‑space.
- **Provider IDs** optional in folder/filename: `[imdbid-tt1234567]`, `[tmdbid-12345]`

## Standard labels (A/B/C; MKV‑first)
- `A-<resolution> MKV` — archival (e.g., `A-1080p MKV`, `A-480p MKV` for DVD NTSC, `A-576p MKV` for
  PAL)
- `B-<resolution> AppleTV` — Apple‑friendly MP4 remux (copy video; AC‑3 + AAC; text subs)
- `C-<resolution> iPhone` — small mobile HEVC/H.264

#### Examples
```text
Movie (2009) - A-1080p MKV.mkv
Movie (2009) - B-1080p AppleTV.mp4
Movie (2009) - C-720p iPhone.mp4
```text

## Allowed/reserved tokens
- **Resolutions:** `480p`, `576p`, `720p`, `1080p`
- **Types:** `MKV`, `AppleTV`, `iPhone`
- Optional cuts (add after the type): `Directors Cut`, `Extended Cut`
Example: `Movie (2009) - A-1080p MKV Directors Cut.mkv`

## Disallowed characters (filesystem)
Avoid characters: `< > : " / \ | ? *`

## Extras (same folder)
Use recognized subfolders **or** suffixes:
- Folders: `featurettes/`, `trailers/`, `behind the scenes/`, `deleted scenes/`, `interviews/`,
  `clips/`, `shorts/`, `other/`, `extras/`
- Suffixes: `-trailer`, `-featurette`, `-clip`, etc.

## Sidecars (subs/audio)
```text
Movie (2009).en.srt
Movie (2009).default.en.forced.srt
Movie (2009).English Commentary.en.mp3
```text

## Why labels matter
Jellyfin chooses the **first** version by its ordering rules; the **A/B/C prefixes** guarantee a
deterministic default (MKV‑first in this scheme). See 4a‑organization.md for details.
