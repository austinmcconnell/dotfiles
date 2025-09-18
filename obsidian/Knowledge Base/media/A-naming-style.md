# A-naming-style.md — Naming Rules & Label Whitelist

A one‑page reference your automation can enforce.

## Folder structure

```text
/media/movies/Title (Year)/
```

## Base filename

```text
Title (Year)
```

## Version labels (deterministic, MKV‑first)

Append **`- LABEL`** with a single space, hyphen, space.

### Whitelist (order matters)

- `A-<res> MKV` — archival default (e.g., `A-1080p MKV`, `A-480p MKV`)
- `B-<res> AppleTV` — Apple‑friendly MP4/M4V remux (copy video; AAC/AC‑3; mov_text/WebVTT)
- `C-<res> iPhone` — small mobile encode (HEVC/H.264)

### Examples

```text
Movie (2009) - A-1080p MKV.mkv
Movie (2009) - B-1080p AppleTV.mp4
Movie (2009) - C-720p iPhone.mp4
```

## Extras (three supported forms)

1. **Subfolders**: `featurettes/`, `trailers/`, `behind the scenes/`, `deleted scenes/`, `interviews/`, `clips/`, `shorts/`, `extras/`
1. **Suffixes**: `-trailer`, `-featurette`, `-clip`, `-interview`, `-deleted`, `-short`, `-other`, `-extra`
1. **Special filenames**: `trailer`, `sample`, `theme`

## Subtitles & audio sidecars

Use language codes and flags as dot‑segments:

```text
Title (Year).default.en.forced.srt
Title (Year).en.sdh.srt
Title (Year).English Commentary.en.mp3
```

## Unsafe characters (avoid in names)

`< > : " / \ | ? *` and trailing dots/spaces. Keep ASCII where possible.

## Provider IDs (optional but precise)

```text
Title (Year) [imdbid-tt1234567]
Title (Year) [tmdbid-12345]
```

## Regex helpers

- **Movie folder**: `^(?P<title>.+) \((?P<year>\d{4})\)$`
- **Version label**: `^.+ - (?P<label>[ABC]-\d{3,4}p .*?)\.(mkv|mp4|m4v)$`
- **Extras suffix**: `^.+[-._
    ](trailer|featurette|clip|interview|deleted(scene)?|short|other|extra)\.`
