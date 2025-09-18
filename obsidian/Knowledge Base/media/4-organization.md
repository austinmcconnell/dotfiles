# 4a — Jellyfin Organization (Movies)

This file covers **folder layout, naming, multiple versions, extras, local images, and NFO** so
items scan cleanly and group correctly.

## Library & folders

- Library type: **Movies**. Point it at `/media/movies`.
- One movie per folder: `Title (Year)`
- Prefer **MKV/MP4** over `ISO`/`VIDEO_TS`/`BDMV` if you need multiple versions or sidecars.
- Enable **Embedded Image Extractor** if you embed artwork in MKV.

Docs: <https://jellyfin.org/docs/general/server/media/movies/>

### Canonical layout

```text
/media/movies/
  Inception (2010)/
    Inception (2010) - 1080p A-MKV.mkv
    Inception (2010) - 1080p B-AppleTV.mp4
    Inception (2010) - 720p C-iPhone.mp4
    poster.jpg
    backdrop-1.jpg
    extras/
      Making-of.featurette.mp4
      Trailer.trailer.mp4
```

## Multiple versions (grouping + ordering)

**Grouping rule:** files share the **exact same prefix** (folder + base name) and add a **`-
Label`** suffix. Different extensions are fine.

- **Order rules:** if labels end in `p`/`i` (e.g., `1080p`, `720p`), Jellyfin sorts those by
    **resolution descending**. When resolution is equal, sort is **alphabetical by the remaining
    label**.
- **Default:** Jellyfin plays the **first** version in that order.

### Standard labels (MKV-first default)

- `- 1080p A-MKV.mkv`  (archive, all tracks)
- `- 1080p B-AppleTV.mp4`  (Apple-friendly remux)
- `- 720p C-iPhone.mp4`  (mobile)

This guarantees the MKV is first. If you want Apple-first later, swap the letters: `A-AppleTV`,
`B-MKV`.

Docs: <https://jellyfin.org/docs/general/server/media/movies/#multiple-versions>

## External subtitles & external audio sidecars

Use language + flags in filenames:

```text
Movie (2009) - 1080p A-MKV.en.srt
Movie (2009) - 1080p A-MKV.default.en.forced.ass
Movie (2009) - English Commentary.en.mp3
```

Flags: `default`, `forced|foreign`, `sdh|cc|hi`. Unrecognized tokens become the stream title.

Docs: <https://jellyfin.org/docs/general/server/media/movies/#external-subtitles-and-audio-tracks>

## Extras (trailers, featurettes)

Prefer **extras subfolders** under the movie folder:

```text
extras/, featurettes/, trailers/, behind the scenes/, deleted scenes/, clips/, interviews/, shorts/
```

You can also use **file suffixes** like `-trailer`, `-featurette`, `-clip`, etc.

Docs: <https://jellyfin.org/docs/general/server/media/movies/#extras>

## Local images

Common names: `poster.jpg`, `backdrop.jpg` (`backdrop-1.jpg`, `backdrop-2.jpg`), `logo.png`, etc.
External images override remote art. If using embedded artwork, enable **Embedded Image Extractor**.

Docs: <https://jellyfin.org/docs/general/server/media/movies/#metadata-images>

## Local `.nfo` (recommended)

NFO gives **deterministic** titles, plots, and artwork. Place `Movie (Year).nfo` next to the video
and store `poster.jpg`/`backdrop.jpg` in the same folder. Turn on **Local NFO** in library settings
if you want Jellyfin to consume it first.

Docs: <https://jellyfin.org/docs/general/server/metadata/nfo/>
