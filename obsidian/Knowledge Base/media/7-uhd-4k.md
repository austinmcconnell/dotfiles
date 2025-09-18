# UHD (4K) — Separate Notes

> You asked to keep all UHD discussion in one place. The rest of the docs focus on standard DVDs &
> 1080p Blu‑rays.

## Storage

- UHD releases are commonly on **66 GB (dual‑layer) or 100 GB (triple‑layer)** Blu‑ray discs (BDXL).
  General Blu‑ray capacities: **25 GB per layer**, with triple‑layer **100 GB**. See [Blu‑ray —
  Wikipedia](https://en.wikipedia.org/wiki/Blu-ray). Expect very large remuxes if you keep full
  video/audio.

## Drives & LibreDrive (high‑level)

- UHD ripping typically requires a drive/firmware combination that supports **LibreDrive** mode.
  LibreDrive is a drive mode where the disc data is read without firmware restrictions. See
  MakeMKV forum: **What is LibreDrive?** <https://forum.makemkv.com/forum/viewtopic.php?t=18856>
  and the **LibreDrive/UHD drive** sections/threads (e.g., the long‑running **Ultimate UHD Drives
  Flashing Guide**: <https://forum.makemkv.com/forum/viewtopic.php?t=19634>).

## Workflow (same shape, bigger files)

- **Rip to MKV with MakeMKV** (as in the main guide). Plan for **very large** files and slow I/O.
- **Apple‑friendly copies**: If you remux HEVC video to MP4 for tvOS, consider adding `-tag:v hvc1`
  while copying the HEVC bitstream to improve acceptance by Apple players.
- Subtitles/audio compatibility caveats are the same as in the main docs (MP4 no PGS, DTS/TrueHD not
  native on Apple).
