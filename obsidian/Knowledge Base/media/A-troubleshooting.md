# A-troubleshooting.md — Quick Fixes

Short, practical fixes to common gotchas in this workflow.

## 1) MakeMKV shows 100+ titles (playlist obfuscation)

**Symptom:** Commercial discs list many “main” titles with similar durations.

### Fix (quick)

- In MakeMKV GUI, use **View → Preferred language** & **minimum length** to reduce noise.
- Prefer the **longest title** whose segments appear in a sensible order; avoid those with shuffled
    segment patterns.
- Cross‑check by **playing the disc** in a software player and noting the **playlist `.mpls`** shown
    in debug/logs (when available), then select that playlist in MakeMKV.
- For tough cases, rip the full disc (**backup --decrypt**) and inspect playlists with tools like
    **MediaInfo** or **tsMuxeR** to identify the correct `.mpls`.

## 2) Forced subtitles not auto‑selecting

**Symptom:** “Foreign‑parts‑only” subtitles don’t show automatically.

**Fix:** Set the **Forced** flag on the correct subtitle stream and set language properly.

```bash
mkvpropedit "Movie (2009) - A-1080p MKV.mkv" \
  --edit track:s1 --set language=eng --set flag-forced=1
```

Also check Jellyfin user **Playback preferences** (Subtitle mode: *Default* or *Forced only*).

## 3) Audio default not respected

**Symptom:** The wrong audio plays by default, or stereo commentary comes up first.

**Fix:** Mark your main audio as **Default** and give commentary tracks explicit titles.

```bash
mkvpropedit "Movie (2009) - A-1080p MKV.mkv" \
  --edit track:a1 --set flag-default=1 \
  --edit track:a2 --set name="Director Commentary"
```

In MP4 sidecars, map the **primary** track first and include **AAC stereo** as track 2 for Apple
compatibility.

## 4) MP4 won’t play HEVC on Apple unless tagged `hvc1`

**Symptom:** HEVC video plays audio‑only or fails on certain Apple players.

**Fix:** When **copying HEVC** into MP4/M4V, tag the video stream as `hvc1`.

```bash
ffmpeg -i in.mkv -map 0:v:0 -c:v copy -tag:v hvc1 -map 0:a:0 -c:a ac3 -b:a 640k out.m4v
```

This changes the **fourcc/brand** without re‑encoding.
