# Jellyfin Organization & Settings (Movies) — MKV/MP4, Audio/Subs, Versions, Extras

> This guide focuses on **movie libraries** in Jellyfin and aligns with your workflow (lossless MKV rips, optional Apple‑friendly MP4 remuxes, and small mobile transcodes). It covers **naming**, **folder layout**, **how Jellyfin treats MKV vs MP4**, **audio/subtitle handling**, **multiple versions**, **extras/related media**, and **local metadata**.

---

## TL;DR (What matters most)

- Use a **Movies** library with one folder per movie: `Title (Year)`.
- Name the main file **exactly** like the folder, then suffix **versions** with `" - Label"` (e.g., `- AppleTV`, `- iPhone-720p`). Jellyfin groups versions automatically.
- MKV is the best archival container. Add an **MP4 remux** if you want **Apple devices** to direct‑play without server transcoding.
- Keep **embedded tracks** (audio + subs) in MKV; use **external sidecars** only when needed (e.g., SRT for MP4).
- Extras can live in **recognized subfolders** (e.g., `featurettes/`, `trailers/`) or use **suffix tags** like `-trailer`.
- You can provide **local images** (`poster.jpg`, `backdrop.jpg`, `logo.png`) and/or **.nfo** metadata. Jellyfin supports both and **prefers local images when present**.

**Official docs referenced below:**

- Movies (naming, versions, extras, images): <https://jellyfin.org/docs/general/server/media/movies/>
- Codec support (direct play/stream/transcode; subtitle/container support): <https://jellyfin.org/docs/general/clients/codec-support/>
- Local `.nfo` metadata: <https://jellyfin.org/docs/general/server/metadata/nfo/>

---

## 1) Create a Movies Library (once)

When adding a library in the Dashboard:

- **Content type**: **Movies**.
- **Folders**: point to your `/media/movies`.
- **Image extractors**: If you embed artwork inside MKV, enable **Embedded Image Extractor** so Jellyfin can read it from the container. (The Movies doc notes embedded images are used when that extractor is enabled.)
- **Metadata downloaders**: TMDb, OMDb, etc., as desired. You can also rely entirely on **local .nfo** if you generate it yourself.
- **Metadata savers / images**: If you want Jellyfin to save images **alongside your media**, turn on “Save artwork into media folders”; otherwise leave it off to keep media folders clean.

**Reference:** Movies organization & metadata providers; embedded image extractor note in **Metadata Images** section.
<https://jellyfin.org/docs/general/server/media/movies/>

**NFO**: Jellyfin reads/writes `.nfo` and can prioritize artwork referenced there (local paths/URLs override remote providers).
<https://jellyfin.org/docs/general/server/metadata/nfo/>

---

## 2) Folder Layout & Naming (Movies)

**Canonical layout** (one folder per movie):

```text
/media/movies/
  Inception (2010)/
    Inception (2010).mkv
```

- Avoid special characters in names that **cause problems**: `< > : " / \ | ? *`
- **Disc structures** (`VIDEO_TS`, `BDMV`) are supported, but they **don’t** support **multiple versions** or **external** subtitle/audio tracks. Prefer MKV for flexibility.
- You may append **provider IDs** either in the folder or filename for perfect matching: `[imdbid-tt1375666]`, `[tmdbid-27205]` (you can include multiple).

**Examples** (from docs):

```text
Movie (2021) [imdbid-tt12801262]/
  Movie (2021) [imdbid-tt12801262].mkv
```

Docs: <https://jellyfin.org/docs/general/server/media/movies/>

---

## 3) Multiple Versions (MKV + MP4 + Mobile)

Jellyfin groups versions when filenames share the **exact same prefix** (including year and IDs) and differ only by a **“ - Label”** suffix (space, hyphen, space). Brackets around the label also work.

```text
Movie (2009).mkv
Movie (2009) - AppleTV.mp4
Movie (2009) - iPhone-720p.mp4
```

- The **hyphen** after the base name is **required**; periods/commas are **not** supported in the label.
- **Sorting**: version names ending in `p`/`i` are sorted by resolution descending; other labels sort alphabetically; the first shown is selected by default.

Docs: <https://jellyfin.org/docs/general/server/media/movies/#multiple-versions>

**Why keep multiple versions?**

- **MKV** is your archival master (all tracks).
- **MP4** remux labeled `- AppleTV` helps Apple clients **direct‑play** (copy video; AAC/AC‑3 audio; text subs) to avoid server transcoding.
- **Mobile** encodes (`- iPhone-720p`) are small and great for slow networks or offline sync.

Codec/container behavior: <https://jellyfin.org/docs/general/clients/codec-support/>

---

## 4) External Subtitles & External Audio (sidecars)

Place sidecar files **next to the movie** using suffix **flags** and **language codes**. Examples from the docs:

```text
Film (1986)/
  Film.mkv
  Film.default.srt
  Film.default.en.forced.ass
  Film.forced.en.dts
  Film.en.sdh.srt
  Film.English Commentary.en.mp3
```

**Flags** (use as suffix segments):

- Default: `default`
- Forced: `forced`, `foreign`
- Hearing‑impaired: `sdh`, `cc`, `hi`  (Note: `hi` alone collides with the Hindi language code; combine it with another language token, e.g., `.en.hi.srt`.)

> **Note:** *Flags are ignored on containers with more than one stream.* (This warning is for sidecars that are containers containing multiple streams.)

Docs: <https://jellyfin.org/docs/general/server/media/movies/#external-subtitles-and-audio-tracks>

**When to use sidecars vs embedded:**

- **Embedded (MKV)** is ideal for archival and Jellyfin playback.
- **Sidecars** are useful when making **MP4** copies (MP4 can’t carry PGS subs; prefer **SRT/WebVTT/mov_text**). See subtitle/container table: <https://jellyfin.org/docs/general/clients/codec-support/>

---

## 5) MKV vs MP4 in Jellyfin (Direct Play vs Direct Stream vs Transcode)

**Goal:** **Direct Play** (no server work). If a small mismatch exists (e.g., container or audio/sub format), Jellyfin **Direct Streams** (remuxes or converts just that stream). If the **video codec** is incompatible with the client, Jellyfin must **transcode video** (most CPU‑intensive).

### Containers

- **MKV**: very flexible; widely supported; may be **remuxed for streaming** in some clients (e.g., Web Firefox).
- **MP4**: one of the few containers that often **won’t remux**; great for Apple devices.
Docs (Container & general codec support): <https://jellyfin.org/docs/general/clients/codec-support/>

### Subtitles (by container)

- **MKV** supports **SRT, ASS/SSA, VobSub, PGS (PGSSUB)**, EIA‑608/708.
- **MP4** supports **SRT, VobSub, EIA‑608/708**; **PGS is not supported** in MP4 (will force remux/transcode or require burn‑in/convert).
Docs (subtitle compatibility table): <https://jellyfin.org/docs/general/clients/codec-support/>

### Practical guidance

- Use **MKV** for the master archive (keep PGS/VobSub, all audio).
- Add **MP4 remux** for Apple Direct Play (copy video; convert audio to AAC/AC‑3; convert subtitles to **text** or omit).
- Expect **Direct Stream** or **Transcode** if you try to play a PGS‑subbed MP4 on many clients.

---

## 6) Extras & Related Media (trailers, featurettes, etc.)

You can store extras either in **recognized subfolders** or by using **filename suffixes** in the same folder.

### A) Extras subfolders (recommended)

Place extra content in child folders named with these recognized types:

```text
behind the scenes
deleted scenes
interviews
scenes
samples
shorts
featurettes
clips
other
extras
trailers
```

Example:

```text
Best_Movie_Ever (2019)/
  Best_Movie_Ever (2019).mkv
  featurettes/
    Making the Score.mkv
  trailers/
    Trailer 1.mp4
```

### B) Single “special name” files (same folder)

If you only have one of a type, you can name files with a **special filename**:

- `trailer`
- `sample`
- `theme` (audio theme song; e.g., `theme.mp3`)

### C) Suffix tags (same folder)

Append a **suffix** to the filename (no spaces, except the special “ trailer” case) such as:

```text
-trailer, .trailer, _trailer,  (or space) trailer
-sample,  .sample,  _sample,   (or space) sample
-scene, -clip, -interview, -behindthescenes, -deleted, -deletedscene, -featurette, -short, -other, -extra
```

Docs (all three methods): <https://jellyfin.org/docs/general/server/media/movies/#extras>

---

## 7) Local Images & Embedded Artwork

Jellyfin supports **external images** (files next to your media) and **embedded images** (inside MKV). When external images are present, Jellyfin **uses them in preference** to other sources.

**Common filenames** (Movies):

```text
poster.jpg        # Primary cover (also 'folder.jpg', 'cover.jpg', 'default.jpg', 'movie.jpg')
backdrop.jpg      # Also 'fanart.jpg', 'background.jpg' (multiple: backdrop-1.jpg, backdrop2.jpg ...)
logo.png
```

There are additional recognized names (banner, landscape, thumb, etc.) and client‑specific behaviors. See the **Metadata Images** table in the Movies doc.
<https://jellyfin.org/docs/general/server/media/movies/#metadata-images>

> If you embed images in MKV, enable **Embedded Image Extractor** in the library’s Image Extractors so Jellyfin reads the artwork directly from your files (as noted in the Movies doc).

---

## 8) Local `.nfo` Metadata (optional but powerful)

You can drive metadata fully from your local files if you wish (useful when you want **exact posters/plots** and deterministic matches). Key points:

- Name `.nfo` correctly (per the doc’s table) alongside each movie.
- **Artwork referenced in .nfo** via local paths/URLs is **prioritized** over remote providers and images found in the media folder.
Docs: <https://jellyfin.org/docs/general/server/metadata/nfo/>

Tip: Tools like *tinyMediaManager* can pre‑generate `.nfo` and images for strict control.

---

## 9) Audio & Subtitle Selection (defaults, forced, preferences)

- **Container flags** matter: set **`default`** and **`forced`** flags correctly on embedded tracks (e.g., with `mkvpropedit`).
- **External sidecars** can signal `default/forced/sdh/cc/hi` via filename suffixes as shown above.
- **Per‑user playback preferences** (Preferred audio language, subtitle mode) also affect selection. Behavior can vary by client; when in doubt, set container flags the way you want defaults to behave.

Docs:

- External sidecar flags: <https://jellyfin.org/docs/general/server/media/movies/#external-subtitles-and-audio-tracks>
- Subtitle/container behavior & transcoding implications: <https://jellyfin.org/docs/general/clients/codec-support/>

---

## 10) Putting it all together (your use‑case)

**Target:** archival MKV + Apple‑friendly MP4 remux + small mobile file, all grouped as versions.

```text
/media/movies/
  The Matrix (1999)/
    The Matrix (1999).mkv                 # archival (all tracks; PGS OK)
    The Matrix (1999) - AppleTV.mp4       # MP4 remux (copy video; AAC/AC-3; text subs if needed)
    The Matrix (1999) - iPhone-720p.mp4   # small H.265/H.264 encode
    featurettes/
      Making The Matrix.mkv
    trailers/
      The Matrix (1999) - Trailer.trailer.mp4
    poster.jpg
    backdrop-1.jpg
    backdrop-2.jpg
```

- Jellyfin will **group** the three main files as **versions** of *The Matrix (1999)*.
- Apple devices will usually **direct‑play** the MP4 remux; other clients can use the MKV.
- Mobile devices can use the 720p encode.
- Local images & extras are visible immediately.

Docs:

- Multiple versions & naming: <https://jellyfin.org/docs/general/server/media/movies/#multiple-versions>
- Extras: <https://jellyfin.org/docs/general/server/media/movies/#extras>
- Images: <https://jellyfin.org/docs/general/server/media/movies/#metadata-images>
- Codec/subtitle compatibility: <https://jellyfin.org/docs/general/clients/codec-support/>

---

## 11) What “the first version is selected by default” actually means

Per the Movies docs, **Jellyfin orders versions** and then **selects the first in that list by default** — this is a **global default**, not per‑client.
Order rules: **resolution labels** that **end with `p` or `i`** (e.g. `1080p`, `720p`) sort **highest→lowest**; other labels are sorted **alphabetically**. The **first** is the default. There is **no automatic per‑client version pick** (e.g. “serve MP4 to Apple TV and MKV elsewhere”) as of 10.10 — the user can switch versions in the UI.
Source: Movies → Multiple Versions (ordering and default).

**Implication:** If you keep `Movie (2009) - 1080p.mkv` and `Movie (2009) - AppleTV.mp4`, the **1080p** one will be first (default) because resolution labels sort first; `AppleTV` is a named label sorted after resolution labels.

> If you want a specific version to be the default, **name it so it sorts first** by the above rules (examples below). You can also manually “Group Versions” and then pick the version when playing in a client.

### 11.1 Recommended labeling strategies

Pick **one** strategy for consistency across the library:

- **Archive‑first default (recommended if most clients can handle MKV):**
  - `Movie (2009) - 1080p.mkv`  ← default (first)
  - `Movie (2009) - AppleTV.mp4`
  - `Movie (2009) - iPhone-720p.mp4`

- **Apple‑first default (recommended if most playback is tvOS/iOS):**
  - `Movie (2009) - 1080p.mp4`   ← default (first)
  - `Movie (2009) - MKV.mkv`
  - `Movie (2009) - iPhone-720p.mp4`

> **Important:** To group automatically, **all versions should have a label** (i.e., include the `- LABEL` suffix). Files without a label are treated as **separate movies** unless you **manually group** them. Source: Movies → Multiple Versions.

---

## 12) Client‑specific recommendations (labels, containers, subs)

Below is a concise matrix for the three clients you asked about. This assumes 1080p sources.

| Client | Recommended “default” label (if using that client most) | Container/Codec (for direct‑play) | Audio | Subtitles | Notes |
|---|---|---|---|---|---|
| **tvOS (Swiftfin)** | `- 1080p.mp4` (Apple‑first) **or** keep MKV default and manually pick MP4 when needed | MP4 (H.264/HEVC video copy), `-movflags +faststart` | AAC stereo + AC‑3 5.1 (copy/encode) | Prefer **SRT → mov_text** (or WebVTT). Avoid PGS in MP4. | Swiftfin can Direct Play MP4 broadly. MKV often works too (esp. VLCKit engine), but DTS/TrueHD & PGS can trigger remux/transcode. See Codec Support and Swiftfin repo. |
| **iOS (Swiftfin)** | `- iPhone-720p.mp4` for mobile copy (kept as a **second** version) | MP4 (H.264 or HEVC), 720p CRF encode | AAC stereo | mov_text/WebVTT | Smaller CRF copy saves bandwidth and battery; Jellyfin will **not** auto‑pick it—you or the user selects the version. |
| **Web (browser)** | depends on browser; safe default is `- 1080p.mp4` | MP4 is the most universally direct‑play in browsers | AAC/AC‑3 (AC‑3 passthrough varies by browser/OS) | SRT (external) or mov_text; VTT via HLS | Firefox/Safari may **remux** MKV; MP4 avoids that. See Codec Support → Container Compatibility table. |

**Underlying references:**

- Movies → Multiple Versions (ordering, grouping).
- Clients → Codec Support (Direct Play vs remux/transcode; subtitle container support; container table).
- Swiftfin (iOS/tvOS client) project page.

### 12.1 Example final layout (Archive‑first)

```text
/media/movies/Movie (2009)/
  Movie (2009) - 1080p.mkv         # default (archive)
  Movie (2009) - AppleTV.mp4       # remux (copy video; AAC/AC-3)
  Movie (2009) - iPhone-720p.mp4   # small mobile transcode
  poster.jpg
  backdrop.jpg
```

### 12.2 Example final layout (Apple‑first)

```text
/media/movies/Movie (2009)/
  Movie (2009) - 1080p.mp4         # default (Apple direct-play)
  Movie (2009) - MKV.mkv           # archive
  Movie (2009) - iPhone-720p.mp4   # small mobile transcode
```

**Trade‑off:** Apple‑first minimizes server work on Apple clients at the cost of making MP4 the default for **all** clients. Archive‑first keeps the lossless MKV first; Apple clients can still select the MP4 version from the **Versions** menu.

**Swiftfin player note (MKV on Apple devices):** Swiftfin offers **two players** — **Native (AVKit)** and **Swiftfin (VLCKit)**.

- **Native (AVKit)** follows Apple’s built‑in container support (MOV/MP4/HLS); **MKV** typically requires server **remux** (and often audio transcode for DTS/TrueHD).
- **Swiftfin (VLCKit)** can **demux MKV directly** and play many codecs **in‑app**, increasing chances of true direct‑play on iOS/tvOS.
Docs: Swiftfin README + Player Differences.
<https://github.com/jellyfin/Swiftfin> · <https://github.com/jellyfin/Swiftfin/blob/main/Documentation/players.md>
