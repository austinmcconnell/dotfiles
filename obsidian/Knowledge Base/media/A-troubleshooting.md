# A-troubleshooting.md — Quick Fixes

Short, surgical fixes for common pain points.

## Playlist obfuscation (100+ titles; which playlist is real?)

- **Use the latest MakeMKV**; it handles most obfuscation automatically.
- In GUI: sort titles by **duration**; the main feature is usually the **longest** with **chapter
  markers** and expected **audio/subs**. Deselect the rest.
- In CLI: limit candidates with `--minlength`, e.g. `--minlength=3000` (50 min) to skip junk
  playlists.
- If still ambiguous, rip the **top 1–2 candidates** to a temp folder; preview in VLC/Infuse and
  keep the correct one.

### CLI example

```bash
makemkvcon -r --minlength=3000 mkv disc:0 all "/path/to/ripped"
```text

## “Forced” subtitles not auto-selecting
- Ensure the **correct subtitle stream** is actually **“forced”** (not just titled “forced”). Set it
  at the container level.
```bash
mkvpropedit "Movie (2009) - A-1080p MKV.mkv" \
  --edit track:s1 --set language=eng --set flag-forced=1
```text
- In Jellyfin, per-user **Playback** settings: set **Subtitle mode = Forced only** (or as desired).
  Test on Web and your tvOS/iOS client.

## Audio default not respected
- Mark the **primary audio** as **default** at the container level.
```bash
mkvpropedit "Movie (2009) - A-1080p MKV.mkv" \
  --edit track:a1 --set language=eng --set flag-default=1
```text
- Also check the user’s **Preferred audio language** in Jellyfin Playback settings; a strong
  language preference may override “default”.

## HEVC won’t play on Apple unless tagged `hvc1`
Some Apple players require the **`hvc1`** brand for HEVC in MP4/M4V.

#### Fix during remux/encode
```bash
ffmpeg -i in.mkv -map 0:v:0 -c:v copy -tag:v hvc1 -map 0:a:0 -c:a ac3 -b:a 640k -movflags +faststart out.m4v
```text
(For encodes with libx265, also add `-tag:v hvc1`.)

## PGS/VobSub subs in MP4
MP4 doesn’t support PGS/VobSub widely. Convert **PGS/VobSub → SRT** (OCR) then embed as
`mov_text`/WebVTT, or burn‑in if needed.
