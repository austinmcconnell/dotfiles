# Full‑Quality Disc Ripping on macOS (DVD / Blu‑ray)

## Overview

Goal: **lossless, full‑quality** backups of DVDs and 1080p Blu‑rays, preserving **all audio and subtitle tracks** where practical. Final containers: **MKV** (preferred for fidelity & features) and **MP4** only when you specifically need it (Apple device compatibility), because MP4 doesn’t pass through certain subtitle types.

## Why MKV first

- **No re‑encode**: MakeMKV remuxes video/audio into an MKV container **without changing quality** (“stream copy”). [MakeMKV](https://www.makemkv.com/)
- **Holds everything**: multiple audio tracks, PGS/VobSub subtitles, chapters, and attachments (fonts, cover art). [Matroska](https://www.matroska.org/) · [LoC FDD](https://www.loc.gov/preservation/digital/formats/fdd/fdd000342.shtml)
- **Best for Jellyfin**: direct‑play friendly; disc folders (VIDEO_TS/BDMV) also work but don’t support multiple versions or external tracks. [Jellyfin Movies](https://jellyfin.org/docs/general/server/media/movies/)

---

## Audio (DVD vs Blu‑ray; MKV vs MP4)

### At a glance

| Source / Container | Common audio formats you’ll encounter | Container support | Apple/tvOS native? | Notes |
|---|---|---|---|---|
| **DVD-Video** | **AC‑3 (Dolby Digital)**, **DTS**, **LPCM**, (PAL often **MP2**) | MKV ✅ · MP4 ✅ (AC‑3/AAC only) | AC‑3/AAC ✅ · DTS ❌ | MP4 cannot hold DTS/TrueHD for Apple native playback; MKV keeps all. |
| **Blu‑ray** | **DTS(-HD MA)**, **Dolby TrueHD**, **AC‑3**, **LPCM** | MKV ✅ (all) · MP4 ⚠️ | AC‑3/AAC ✅ · DTS/TrueHD ❌ | Keep DTS‑HD/TrueHD in MKV; for MP4, convert to AC‑3/AAC. |
| **MKV (archival)** | Any of the above | — | Depends on client | Ideal for **preserving** every track bit‑perfect. |
| **MP4 (Apple‑friendly)** | H.264/HEVC video + **AC‑3**/**AAC** audio | — | iOS/tvOS native | Great for **direct‑play** on Apple; drop/convert DTS/TrueHD. |

**What you gain/lose if you keep only MP4 on the server**

- ✅ Likely **direct‑play** on iOS/tvOS (no server transcoding).
- ❌ You’ll generally **lose DTS/TrueHD/LPCM** tracks (must transcode or drop).
- ❌ You’ll **standardize** to **AC‑3 5.1** (plus stereo AAC) for compatibility—good for Apple, but not a bit‑perfect archive.
- ❌ You can’t keep **multiple commentary tracks** in exotic formats as‑is without converting. (You *can* keep many tracks in MP4, but the codec support is limited.)

**Recommendation:** Keep an **MKV archival** with **all original audio tracks**. Optionally add an **MP4 remux** per title with **AC‑3 5.1 + AAC stereo** for Apple direct‑play.

### Practical audio patterns

- **DVD main**: AC‑3 5.1 (keep), plus optional DTS 5.1 (keep in MKV; convert to AC‑3 for MP4).
- **Blu‑ray main**: DTS‑HD MA or TrueHD (keep in MKV). For MP4, create **AC‑3 5.1** and **AAC stereo** copies of the *primary* track; keep the MKV for the originals.
- **Commentary**: Often 2.0 AC‑3; can be copied to MP4 as‑is. Label the track (“Director Commentary”) with MKVToolNix or MP4 tags.

### Example FFmpeg audio mapping for Apple‑friendly MP4

Copy video; generate AC‑3 5.1 + AAC stereo from the first audio track:

```bash
ffmpeg -i "Movie (2009).mkv" \
  -map 0:v:0 -c:v copy \
  -map 0:a:0 -c:a:0 ac3 -b:a:0 640k \
  -map 0:a:0 -c:a:1 aac -b:a:1 160k -ac:a:1 2 \
  -movflags +faststart \
  "Movie (2009) - AppleTV.mp4"
```

---

## Subtitles (DVD vs Blu‑ray; MKV vs MP4)

### Subtitle formats you’ll see

- **DVD** → **VobSub** (image/bitmap).
- **Blu‑ray** → **PGS** (image/bitmap).
- **Text‑based** → **SRT**, **ASS/SSA**, **WebVTT** (UTF‑8 text).
- **“Forced”** → a subset showing only foreign‑language bits; marked with a **forced flag** on a subtitle stream (or a dedicated “forced only” stream).

### Container support & trade‑offs

| Subtitle type | MKV | MP4 | Notes |
|---|---|---|---|
| **PGS (Blu‑ray)** | ✅ | ❌ | MP4 cannot carry PGS for typical players; for MP4, **OCR to SRT** or **burn‑in**. |
| **VobSub (DVD)** | ✅ | ❌* | Generally not supported by MP4; prefer OCR to SRT (text). |
| **SRT (text)** | ✅ | ✅ (as `mov_text` or WebVTT) | Convert SRT→`mov_text` for MP4; keep SRT external if you prefer. |
| **ASS/SSA** | ✅ | ⚠️ | Limited in MP4 players; MKV supports embedded fonts via attachments. |
| **WebVTT** | ✅ | ✅ | Great for web/iOS/tvOS; not native on discs—used post‑rip. |

\* There are edge cases/boxes that accept VobSub in MP4, but it’s not widely supported—avoid.

**What you gain/lose if you keep only MP4 on the server**

- ✅ Apple/tvOS **text subtitles** (mov_text/WebVTT) are light and direct‑play.
- ❌ You **cannot keep PGS/VobSub** image subs **inside MP4**. To bring subs along, you must **OCR to SRT** or **burn‑in** (sacrifices toggling).
- ❌ You **lose ASS/SSA styling** and **font attachments** commonly used in MKV (especially for anime).

**Recommendation:** Keep **image‑based subs (PGS/VobSub)** in your **MKV** archive. For your MP4 copy, either:

1) **OCR to SRT** and embed as **mov_text** or **WebVTT**, or
2) Skip subs in MP4 (rely on MKV version when subs matter), or
3) Burn‑in a “forced only” SRT for convenience (at the cost of flexibility).

### Forced/default flags

- In **MKV**, use `mkvpropedit` to set **language**, **default**, and **forced** flags per track. Jellyfin respects these flags and user playback preferences.
- For **MP4**, “default” behavior is client‑side; rely on correct stream ordering and player defaults. Subler can set a track as default and embed chapter names.

**Set flags in MKV (example)**

```bash
mkvpropedit "Movie (2009).mkv" \
  --edit track:a1 --set language=eng --set flag-default=1 \
  --edit track:s2 --set language=eng --set flag-forced=1
```

### OCR tools (macOS‑friendly)

- **macSubtitleOCR** (PGS/VobSub → SRT; macOS Vision/Tesseract based).
- **Subler** can create **TX3G (mov_text)** tracks from SRT and embed them in MP4, along with metadata.
(If you already have SRT, convert to mov_text/WebVTT at remux time.)

**Embed SRT as mov_text during remux**

```bash
ffmpeg -i "Movie (2009).mkv" -i "Movie (2009).en.srt" \
  -map 0:v:0 -c:v copy \
  -map 0:a:0 -c:a:0 ac3 -b:a:0 640k \
  -map 1:0   -c:s mov_text \
  -movflags +faststart \
  "Movie (2009) - AppleTV.mp4"
```

---

## Output Containers

### MKV (recommended archival)

- **Lossless remux** from disc, keeps everything (all audio/subs/chapters/attachments). Ideal for Jellyfin and long‑term storage.
- Fine‑tune track titles, languages, default/forced flags post‑rip without remux (`mkvpropedit`).

### MP4 (only when you need it)

- Use **remux** (no re‑encode) when streams are compatible; otherwise re‑encode explicitly. MP4 **does not support PGS/VobSub**; prefer SRT→`mov_text` or WebVTT for MP4, or burn‑in if necessary.
- Add `-movflags +faststart` so metadata is front‑loaded for progressive streaming; consider `-tag:v hvc1` when copying HEVC for better Apple compatibility.

---

## Recommended Tools (macOS)

- **MakeMKV** — Ripper/Decrypter. *Closed‑source; free while in beta; paid license available.* GUI + `makemkvcon` CLI. <https://www.makemkv.com/download/>
- **MKVToolNix** — Edit MKV headers/flags (`mkvpropedit`), merge/split. *Open‑source.* <https://mkvtoolnix.download/>
- **FFmpeg** — Remux/encode/transcode; stream‑copy (`-c copy`) for lossless container changes. *Open‑source.* <https://ffmpeg.org/>
- **MediaInfo** — Inspect tracks, codecs, languages, flags. *Open‑source.* <https://mediaarea.net/en/MediaInfo>
- **Subler/SublerCLI** — MP4 muxing, metadata, and text subtitle embedding. *Open‑source.* <https://subler.org/>

---

## MakeMKV: Common CLI Tasks

List disc info (drive 0):

```bash
makemkvcon -r info disc:0
```

Rip **all titles** longer than 20 minutes to MKV (lossless):

```bash
makemkvcon -r --minlength=1200 mkv disc:0 all "/path/to/ripped"
```

Make a **full decrypted backup** of a disc (BD/DVD → folder structure):

```bash
makemkvcon backup --decrypt disc:0 "/path/to/backup/FolderName"
```

---

## After‑Rip Fixups (MKVToolNix)

```bash
mkvpropedit "Movie (2010).mkv" \
  --edit track:a1 --set language=eng --set flag-default=1 \
  --edit track:s2 --set language=eng --set flag-forced=1
```

---

## Recommended macOS Workflow (lossless, automation‑ready)

1. **Rip with MakeMKV** (GUI or CLI) → MKV with all tracks.
2. **(Optional) Remux MKV→MP4** for Apple‑only workflows (no PGS). Use FFmpeg stream copy plus audio/sub handling as above.
3. **Tag/flags**: use MKVToolNix to set languages/default/forced; MediaInfo to verify.
4. **Organize** for Jellyfin (see `4-jellyfin.md`).
