# Automation on macOS with Hazel (Consolidated Rules + Scripts)

This document **consolidates** the previous automation pieces (Hazel rules + shell toolkit) into a
single, easy‑to‑apply guide. It uses **only Hazel** for orchestration and standardizes folder paths
as requested.

## Standard Folders

Set these once and use them everywhere:

```text
/path/to/ripped/       # MakeMKV writes MKV rips here
/path/to/remuxed/      # MP4 remuxes for Apple direct-play
/path/to/transcoded/   # smaller mobile copies (use “transcoded”, not “encoded”)
/path/to/tagged/       # optional staging after tagging
/media/movies          # Jellyfin movies library root
```text

### Why “transcoded” (not “encoded”)?

Both are common, but **transcoded** is clearer for “derived lower‑bitrate copies”; **encoded** can
mean any encode, including the original. Using `/path/to/transcoded/` avoids ambiguity in logs and
rules.

---

## End‑to‑End Flow

```text
[Disc] → MakeMKV → /path/to/ripped/
              └─(Hazel)→ post_mkv.sh (flags/verify)
                 └─→ /path/to/remuxed/     (ffmpeg copy video; Apple‑friendly MP4)
                 └─→ /path/to/transcoded/  (ffmpeg H.264/HEVC 720p for mobile)
                 └─→ /path/to/tagged/      (SublerCLI/AtomicParsley)
                       └─(Hazel)→ file_into_library.sh → /media/movies/Title (Year)/
```text

- **Rips** remain your **archival MKVs**.
- **Remuxed** MP4 aims to **avoid Jellyfin transcoding** on Apple devices (copy video, fix
  audio/subs).
- **Transcoded** copy is small for phones/tablets.
- **Tagged** stage is optional—if you embed iTunes‑style tags in MP4s.
- Final **library filing** creates the `Title (Year)` folder and drops all versions inside.

---

## Hazel Rule Definitions (pseudo‑JSON)

> Recreate these in Hazel’s UI. Hazel’s “Run shell script” passes the matched file as `$1`. Docs:
> <https://www.noodlesoft.com/kb/hazel-user-guide/using-scripts/>

### 1) Post‑rip: set flags, verify, and move to remux/transcode staging

```json
{
  "name": "PostMKV: flags + verify",
  "folder": "/path/to/ripped/",
  "if": [
    { "extension": "mkv" },
    { "size_greater_than_mb": 1000 }
  ],
  "do": [
    { "run_shell_script": "/usr/local/bin/post_mkv.sh", "args": ["{file}"] },
    { "move": "/path/to/remuxed/" }
  ]
}
```text

### 2) Create Apple‑friendly MP4 remux (copy video; AAC/AC‑3)

```json
{
  "name": "Remux to MP4 (AppleTV)",
  "folder": "/path/to/remuxed/",
  "if": [ { "extension": "mkv" } ],
  "do": [
    { "run_shell_script": "/usr/local/bin/remux_mp4.sh", "args": ["{file}"] }
  ]
}
```text

### 3) Make a smaller mobile copy (optional 720p)

```json
{
  "name": "Mobile 720p transcode",
  "folder": "/path/to/remuxed/",
  "if": [ { "extension": "mkv" } ],
  "do": [
    { "run_shell_script": "/usr/local/bin/mobile_encode.sh", "args": ["{file}"] }
  ]
}
```text

### 4) Tag MP4s (optional; SublerCLI or AtomicParsley) and stage

```json
{
  "name": "Tag MP4 (optional)",
  "folder": "/path/to/remuxed/",
  "if": [ { "name_matches": ".*AppleTV\\.mp4$" } ],
  "do": [
    { "run_shell_script": "/usr/local/bin/tag_mp4.sh", "args": ["{file}"] },
    { "move": "/path/to/tagged/" }
  ]
}
```text

### 5) File into Jellyfin library (creates Title (Year) folder)

```json
{
  "name": "File into Library",
  "folder": "/path/to/tagged/",
  "if": [
    { "name_regex": "^(?P<title>.+) \\((?P<year>\\d{4})\\)" }
  ],
  "do": [
    { "run_shell_script": "/usr/local/bin/file_into_library.sh", "args": ["{title}", "{year}", "{file}"] }
  ]
}
```text

> If you skip tagging, point rule 5 at `/path/to/remuxed/` and/or `/path/to/transcoded/` instead.

---

## Shell Toolkit

> Put scripts in `/usr/local/bin` or `~/bin`, `chmod +x`, and adjust paths if your Homebrew lives at
> `/opt/homebrew` (Apple Silicon). These scripts are **idempotent** and safe on re‑runs.

### Common config (optional): `~/.video-pipeline.conf`

```bash
# Standard folders
RIPPED_DIR="/path/to/ripped"
REMUXED_DIR="/path/to/remuxed"
TRANSCODED_DIR="/path/to/transcoded"
TAGGED_DIR="/path/to/tagged"
LIB_DIR="/media/movies"
```text

Each script will source it if present: `[[ -f ~/.video-pipeline.conf ]] && . ~/.video-pipeline.conf`

---

### `post_mkv.sh` — set basic flags and verify

```bash
#!/usr/bin/env bash
set -euo pipefail
[[ -f ~/.video-pipeline.conf ]] && . ~/.video-pipeline.conf

IN="$1"
# Example: mark first audio default; leave subs as-is (adjust per preference)
if command -v mkvpropedit >/dev/null; then
  mkvpropedit "$IN" --edit track:a1 --set flag-default=1 || true
fi

# Quick sanity report (non-fatal)
if command -v mediainfo >/dev/null; then
  mediainfo "$IN" | sed -n '1,60p' || true
fi
```text

---

### `remux_mp4.sh` — Apple‑friendly MP4 (copy video; AC‑3 + AAC)

```bash
#!/usr/bin/env bash
set -euo pipefail
[[ -f ~/.video-pipeline.conf ]] && . ~/.video-pipeline.conf

IN="$1"
BASENAME="$(basename "$IN" .mkv)"
OUT="${REMUXED_DIR:-/path/to/remuxed}/${BASENAME} - AppleTV.mp4"

mkdir -p "${REMUXED_DIR:-/path/to/remuxed}"

# Copy video, produce AC-3 5.1 and AAC stereo; skip subs by default (PGS not supported in MP4)
ffmpeg -hide_banner -y -i "$IN" \
  -map 0:v:0 -c:v copy \
  -map 0:a:0 -c:a:0 ac3 -b:a:0 640k \
  -map 0:a:0 -c:a:1 aac -b:a:1 160k -ac:a:1 2 \
  -movflags +faststart \
  "$OUT"

echo "[remux_mp4] Wrote: $OUT"
```text

> If you have **SRT** sidecars you want embedded, extend with `-i subtitles.srt -c:s mov_text -map
> 1:0` (don’t try to force PGS → mov_text; use OCR to SRT first).

---

### `mobile_encode.sh` — smaller 720p HEVC for iPhone/iPad

```bash
#!/usr/bin/env bash
set -euo pipefail
[[ -f ~/.video-pipeline.conf ]] && . ~/.video-pipeline.conf

IN="$1"
BASENAME="$(basename "$IN" .mkv)"
OUT="${TRANSCODED_DIR:-/path/to/transcoded}/${BASENAME} - iPhone-720p.mp4"

mkdir -p "${TRANSCODED_DIR:-/path/to/transcoded}"

ffmpeg -hide_banner -y -i "$IN" \
  -map 0:v:0 -vf "scale=-2:720" -c:v libx265 -preset slow -crf 24 \
  -map 0:a:0 -c:a aac -b:a 128k -ac 2 \
  -movflags +faststart \
  "$OUT"

echo "[mobile_encode] Wrote: $OUT"
```text

*Alternative AVC (H.264) version:* replace video line with `-c:v libx264 -preset slow -crf 21`.

---

### `tag_mp4.sh` — tag MP4 using SublerCLI (AtomicParsley fallback)

```bash
#!/usr/bin/env bash
set -euo pipefail
[[ -f ~/.video-pipeline.conf ]] && . ~/.video-pipeline.conf

IN="$1"
POSTER="${POSTER:-}"

mkdir -p "${TAGGED_DIR:-/path/to/tagged}"

# Write tags in-place, then move to TAGGED_DIR
if command -v SublerCLI >/dev/null 2>&1; then
  if [[ -n "$POSTER" && -f "$POSTER" ]]; then
    SublerCLI -source "$IN" -dest "$IN" -poster "$POSTER" -optimize
  else
    SublerCLI -source "$IN" -dest "$IN" -optimize
  fi
elif command -v AtomicParsley >/dev/null 2>&1; then
  AtomicParsley "$IN" --overWrite
fi

mv -f "$IN" "${TAGGED_DIR:-/path/to/tagged}/"
echo "[tag_mp4] Moved to: ${TAGGED_DIR:-/path/to/tagged}/"
```text

---

### `file_into_library.sh` — file items into `/media/movies/Title (Year)/`

```bash
#!/usr/bin/env bash
set -euo pipefail
[[ -f ~/.video-pipeline.conf ]] && . ~/.video-pipeline.conf

TITLE="$1"
YEAR="$2"
SRC="$3"
LIB="${LIB_DIR:-/media/movies}"

DEST="${LIB}/${TITLE} (${YEAR})"
mkdir -p "$DEST"

# Move the matched file and any siblings sharing the base name
BASE="${SRC%.*}"
DIR="$(dirname "$SRC")"

shopt -s nullglob
for f in "$BASE"*; do
  mv -v "$f" "$DEST/"
done
echo "[file_into_library] Filed into: $DEST"
```text

---

## Setup & Test

1. **Install dependencies** (Homebrew):

```bash brew install --cask makemkv subler sublercli brew install ffmpeg mkvtoolnix mediainfo
atomicparsley ```

1. **Create folders**:

```bash mkdir -p /path/to/{ripped,remuxed,transcoded,tagged} /media/movies ```

1. **Create config** (optional):

```bash cat > ~/.video-pipeline.conf <<'EOF' RIPPED_DIR="/path/to/ripped"
REMUXED_DIR="/path/to/remuxed" TRANSCODED_DIR="/path/to/transcoded" TAGGED_DIR="/path/to/tagged"
LIB_DIR="/media/movies" EOF ```

1. **Install scripts**:

```bash install -m 0755 post_mkv.sh remux_mp4.sh mobile_encode.sh tag_mp4.sh file_into_library.sh
/usr/local/bin/ ```

1. **Create Hazel rules** using the JSON above as a guide, pointing to your folders.

1. **Smoke test** on a single title before bulk runs.

### Notes

- Hazel runs scripts in a non‑interactive shell; always use **absolute paths**.
- Use **`mediainfo`** to verify language/default/forced flags and streams before filing.
- For HEVC MP4s, if Apple playback is picky, add `-tag:v hvc1` to the `remux_mp4.sh` ffmpeg command.
