# Remux vs Transcode on macOS — plus extra Apple & Mobile versions

## TL;DR

- **Remux** = change the **container only** (no re‑encode). Fast, lossless. FFmpeg calls this *stream copy*.
- **Transcode** = **re‑encode** the streams. Slow(er), lossy for video, but shrinks size and/or fixes compatibility.

FFmpeg docs on stream copy: <https://ffmpeg.org/ffmpeg.html#Stream-copy>

---

## Remux vs Transcode: When to use which?

### Remux (preferred when possible)

- **Use cases:** change MKV → MP4, fix container metadata, trim without re‑encoding.
- **Pros:** instant(ish), zero quality loss, tiny CPU use.
- **Cons:** **Container limitations remain.** MP4 can’t carry PGS; some audio formats (e.g., DTS‑HD) won’t direct‑play on Apple devices.

### Transcode

- **Use cases:** reduce size; convert DTS/TrueHD → AAC/AC‑3/E‑AC‑3; produce smaller mobile files; burn‑in or convert subtitles.
- **Pros:** high compatibility; big space savings; can downscale/resample.
- **Cons:** lossy for video; time/CPU heavy; choose settings carefully.

---

## Multiple versions in Jellyfin

Jellyfin **groups multiple versions** of a movie if filenames share the same base name and use a suffix like `- AppleTV`, `- 1080p`, etc. Files may have **different extensions** (e.g., MKV + M4V) in the same movie folder. Example from docs:
`Movie (2010)/Movie (2010).mp4`, `Movie (2010)/Movie (2010) - Directors Cut.mp4` and more.
Docs: <https://jellyfin.org/docs/general/server/media/movies/>

**Recommendation:** Keep an **MKV master** and add an **Apple‑friendly MP4/M4V** version to minimize on‑the‑fly transcoding for iOS/tvOS clients.

---

## Apple‑friendly MP4/M4V remux

Apple devices prefer MP4/MOV with **AAC/AC‑3/E‑AC‑3** audio and text subtitles (`tx3g`/WebVTT). For HEVC, tag the video as **`hvc1`** for best iOS/tvOS compatibility.

- Apple HEVC tag context: <https://apple.stackexchange.com/a/444288> (see also: <https://video.stackexchange.com/questions/36359/what-does-the-tag-tagv-hvc1-means> and <https://stackoverflow.com/questions/32152090/encode-h265-to-hvc1-codec>)

### Case A — pure remux (no audio change, works only if audio is already AAC/AC‑3/E‑AC‑3 and subs are text)

```bash
ffmpeg -i "Movie (2010).mkv"   -map 0 -c copy -tag:v hvc1   -c:s mov_text   "Movie (2010) - AppleTV.m4v"
```

> If your MKV has **PGS** subs, `-c:s mov_text` will fail. Use SRT/WebVTT or keep external `.srt` for MP4. Apple requires text subs in MP4/MOV. See: <https://discussions.apple.com/thread/250539722>

### Case B — copy video, **transcode audio** to AC‑3 (common for DTS‑only discs)

```bash
ffmpeg -i "Movie (2010).mkv"   -map 0:v -c:v copy -tag:v hvc1   -map 0:a:0 -c:a ac3 -b:a 640k -ac 6   -map 0:s? -c:s mov_text   "Movie (2010) - AppleTV.m4v"
```

- Keeps original video, replaces first audio with AC‑3 5.1 at 640 kb/s (widely supported on Apple TV).

---

## Mobile‑size encodes (iPhone/iPad)

For small screens, you can **downscale** and use HEVC (**`-tag:v hvc1`**) at modest bitrates/CRF. Two practical options:

### Option 1 — FFmpeg (software HEVC, quality‑oriented)

#### iPhone (720p target)

```bash
ffmpeg -i "Movie (2010).mkv" -map 0:v:0 -map 0:a:0? -map 0:s?   -vf "scale=-2:720" -c:v libx265 -preset slow -crf 26 -tag:v hvc1   -c:a aac -b:a 160k -ac 2   -c:s mov_text   "Movie (2010) - iPhone-720p.m4v"
```

#### iPad (1080p target)

```bash
ffmpeg -i "Movie (2010).mkv" -map 0:v:0 -map 0:a:0? -map 0:s?   -vf "scale=-2:1080" -c:v libx265 -preset slow -crf 24 -tag:v hvc1   -c:a aac -b:a 192k -ac 2   -c:s mov_text   "Movie (2010) - iPad-1080p.m4v"
```

### Option 2 — HandBrakeCLI (easy CRF workflow)

- HandBrake recommends CRF/RF ranges (x264/x265) for quality. See: <https://handbrake.fr/docs/en/latest/workflow/adjust-quality.html>

Examples:

```bash
# iPhone 720p, x265
HandBrakeCLI -i "Movie (2010).mkv" -o "Movie (2010) - iPhone-720p.m4v"   -e x265 -q 26 --width 1280 --height 720 --auto-anamorphic   --aencoder ca_aac --ab 160 --mixdown stereo --subtitle-lang-list eng --subtitle-burned=none

# iPad 1080p, x265
HandBrakeCLI -i "Movie (2010).mkv" -o "Movie (2010) - iPad-1080p.m4v"   -e x265 -q 24 --width 1920 --height 1080 --auto-anamorphic   --aencoder ca_aac --ab 192 --mixdown stereo --subtitle-burned=none
```

> Tip: validate Apple‑compatibility by ensuring HEVC tracks are tagged `hvc1`. See: <https://stackoverflow.com/questions/32152090/encode-h265-to-hvc1-codec>

---

## Space & CPU trade‑offs

Rule‑of‑thumb sizes for a **2‑hour** movie:

| Version | Typical bitrate | Rough size |
|---|---:|---:|
| MKV master (1080p BD) | 20–30 Mb/s video + audio | ~18–27 GiB |
| MP4 AppleTV (copy video, AC‑3 audio) | ≈ same as master video | similar to MKV (± a little) |
| iPad 1080p HEVC (CRF ~24) | ~5–8 Mb/s | ~4.5–7.2 GiB |
| iPhone 720p HEVC (CRF ~26) | ~2–3 Mb/s | ~1.8–2.7 GiB |

Computing size: **GiB ≈ (bitrate_Mb/s × duration_hr × 0.45)**.
BD bitrate limits (context): **max video 40 Mb/s**; **max A/V 48 Mb/s**. Wikipedia: <https://en.wikipedia.org/wiki/Blu-ray>

Whether keeping extra versions is “worth it” depends on your clients:

- If your primary client is Apple TV/iOS, an MP4 version prevents server transcoding and improves responsiveness.
- For occasional mobile viewing, a single small HEVC per title saves bandwidth & storage; Jellyfin picks the right one automatically.

---

## Sources

- FFmpeg docs: stream copy (“no decode/encode”): <https://ffmpeg.org/ffmpeg.html#Stream-copy>
- Jellyfin movie naming & multi‑version examples: <https://jellyfin.org/docs/general/server/media/movies/>
- Apple HEVC tag `hvc1` context: <https://video.stackexchange.com/questions/36359/what-does-the-tag-tagv-hvc1-means> • <https://stackoverflow.com/questions/32152090/encode-h265-to-hvc1-codec>
- HandBrake quality guidance: <https://handbrake.fr/docs/en/latest/workflow/adjust-quality.html>
- Blu‑ray bitrates (context): <https://en.wikipedia.org/wiki/Blu-ray>

## Apple devices & MKV: what actually works

- **Apple’s native playback (AVKit/AVPlayer)** focuses on **QuickTime/ISOBMFF containers**: `.mov`, `.mp4`, `.m4v`, and **HLS** (`.ts`/`fMP4`). Apple docs highlight these as the standard containers for Apple platforms. MKV is **not** listed as a supported native container.
  See Apple developer docs: **Video overview** (containers `.mov`/`.mp4`/HLS) and AVFoundation overview.
  <https://developer.apple.com/documentation/technologyoverviews/video/> · <https://developer.apple.com/av-foundation/>

- **Apple TV 4K tech specs** explicitly call out supported file formats as `.m4v`, `.mp4`, `.mov` (with H.264/HEVC video and AAC/AC‑3/E‑AC‑3 audio). No MKV listed.
  Apple Support: **Apple TV 4K (3rd gen) Tech Specs** → “Video Formats … in .m4v, .mp4, and .mov file formats.”
  <https://support.apple.com/en-us/111839>

- **Jellyfin’s Swiftfin app** offers two players:
  - **Native (AVKit)** → behaves like Apple’s built‑in player (no MKV container).
  - **Swiftfin (VLCKit)** → uses VLC’s demux/decoders, so **MKV + many codecs can direct‑play inside the app** (no server remux), subject to device performance.
  Swiftfin README & Player Differences:
  <https://github.com/jellyfin/Swiftfin> · <https://github.com/jellyfin/Swiftfin/blob/main/Documentation/players.md>

### What this means for you

- If you use **Swiftfin with VLCKit** on iOS/tvOS, you can often **play MKV directly** in‑app.
- If you (or a family member) use clients that rely on **AVKit** (e.g., Safari, Apple TV system player, or Native mode), MKV will typically require the server to **remux** (container‑only) and **transcode audio** if it’s DTS/TrueHD.
- Keeping a **remuxed MP4** alongside your **archival MKV** gives you the best of both: MKV for full fidelity; MP4 for **client‑agnostic direct‑play** on Apple platforms.
