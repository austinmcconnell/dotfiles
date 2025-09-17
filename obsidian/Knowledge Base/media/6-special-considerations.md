# Special Considerations (DVDs & 1080p Blu‑rays)

## Subtitles

- **PGS/VobSub**: great for MKV archives; **not** supported in MP4. For Apple‑friendly copies, use SRT → `mov_text`/WebVTT, or skip subs. See: [MP4 text subs](https://trac.ffmpeg.org/wiki/HowToBurnSubtitlesIntoVideo) and community notes on PGS in MP4 ([example thread](https://superuser.com/questions/1194678/ffmpeg-convert-subtitle-to-mov-text)).

## Audio

- Apple platforms direct‑play AAC/AC‑3 far more reliably than DTS/TrueHD. Convert in the MP4 copy if needed. Specs: [Apple TV 4K](https://support.apple.com/guide/appletv/specifications-atvb2c01ea38/tvos), [iPhone 15 Pro](https://www.apple.com/iphone-15-pro/specs/).

## HandBrake vs FFmpeg

- Both are excellent for **transcoding**. **HandBrake** provides polished presets/filters; **FFmpeg** gives you maximal control/automation. HandBrake does **not** decrypt discs; it expects unencrypted sources (ripped first). See: [HandBrake supported sources](https://handbrake.fr/docs/en/latest/technical/source-formats.html).
- For H.264/HEVC CRF guidance, see FFmpeg wiki: [H.264](https://trac.ffmpeg.org/wiki/Encode/H.264), [H.265](https://trac.ffmpeg.org/wiki/Encode/H.265).

## Disk & Size Planning

- Blu‑ray layers are **25 GB** each; dual‑layer discs are **50 GB**. Your archival MKV often sits near the main feature’s share of that space. [Blu‑ray — Wikipedia](https://en.wikipedia.org/wiki/Blu-ray).
- Keeping both **MKV + MP4 remux** roughly **doubles** storage per title. A mobile copy is comparatively tiny (often a couple of GB).
