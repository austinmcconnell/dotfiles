# Metadata & Tagging (macOS)

## Goals

- Automatic metadata on final files (title, year, cast, artwork, genres, ratings).
- CLI‑first where possible.
- Preserve track languages/flags in MKV; add iTunes‑style metadata to MP4 copies.

## Recommended Tools

- **Subler (macOS)** — Free, open‑source. Mux MP4, create **TX3G/WebVTT** subtitles, **fetch metadata from TMDb/TVDB/iTunes**, and write iTunes‑style atoms. GUI + automation‑friendly.
  - Site/Docs: <https://subler.org/> and <https://github.com/SublerApp/Subler/wiki>
- **SublerCLI** — Command‑line helper for Subler tagging. Install via Homebrew cask.
  - Cask: <https://formulae.brew.sh/cask/sublercli>
- **AtomicParsley** — Open‑source CLI for MP4 iTunes‑style metadata. Handy for scripting artwork/atoms.
  - <https://github.com/wez/atomicparsley>
- **MKVToolNix** — For MKV track titles/flags/languages (`mkvpropedit`).
  - <https://mkvtoolnix.download/>
- **MediaInfo** — For verifying streams and tags.
  - <https://mediaarea.net/en/MediaInfo>

## MKV metadata (flags/titles) with MKVToolNix

```bash
# Set title and default track flags
mkvpropedit "Movie (2009).mkv" \
  --set title="Movie (2009)" \
  --edit track:a1 --set flag-default=1 \
  --edit track:s1 --set flag-forced=1
```

Doc: <https://mkvtoolnix.download/doc/mkvpropedit.html>

## MP4 metadata with SublerCLI (preferred on macOS)

Subler can auto‑lookup metadata (TMDb/TVDB/iTunes) and embed **iTunes‑style** tags compatible with Apple devices. It also creates **TX3G/WebVTT** subtitle tracks when needed. See feature list on <https://subler.org/> and wiki.

**Example (tag an existing MP4):**

```bash
# Basic: write title, year, genre, artwork
SublerCLI -source "Movie (2009) - AppleTV.mp4" \
  -dest "Movie (2009) - AppleTV.tagged.mp4" \
  -metadata "Name=Movie" \
  -metadata "Release Date=2009" \
  -metadata "Genre=Action,Adventure" \
  -poster "/path/poster.jpg" \
  -optimize
```

> For automated lookups, drive Subler via GUI batch or wrappers (e.g., Python/Node bindings) that call SublerCLI under the hood.

## MP4 metadata with AtomicParsley (script‑friendly fallback)

```bash
AtomicParsley "Movie (2009) - AppleTV.mp4" \
  --title "Movie" --year "2009" --stik "Movie" \
  --genre "Action, Adventure" --artwork "/path/poster.jpg" \
  --overWrite
```

AtomicParsley repo: <https://github.com/wez/atomicparsley>.

## CLI: Generate `.nfo` + `poster.jpg`/`backdrop.jpg` with TMDb (`curl` + `jq`)

If you want a scriptable, deterministic path, use TMDb’s API with `curl` + `jq`. The helper script
below writes **Kodi/Jellyfin‑style NFO** and downloads **poster/backdrop** next to your movie.

**Dependencies**: `curl`, `jq`, a TMDb API key (`TMDB_API_KEY`).

**Install**:

```bash
brew install jq
install -m 0755 /mnt/data/fetch_nfo_art.sh /usr/local/bin/
```

**Use**:

```bash
# Using folder name "Title (Year)"
fetch_nfo_art.sh -d "/media/movies/Inception (2010)"

# Explicit title/year
fetch_nfo_art.sh -d "/media/movies/Inception (2010)" -t "Inception" -y 2010

# Using a TMDb ID or IMDb ID
fetch_nfo_art.sh -d "/media/movies/Inception (2010)" -m 27205
fetch_nfo_art.sh -d "/media/movies/Inception (2010)" -i tt1375666
```

The script creates `Title (Year).nfo` (or `movie.nfo` if it can’t parse the folder), plus `poster.jpg`
and `backdrop.jpg`. Jellyfin prefers **local images** when present, so this fits the **NFO‑first**
strategy here. See recognized image names in the organization doc.
