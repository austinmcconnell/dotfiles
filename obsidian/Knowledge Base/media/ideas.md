Weaknesses
    •   Overlap between 1-rip.md and 2-transcode.md: Audio/subtitle handling is split across both, which may confuse readers (should they look in rip or transcode doc for “what to do with DTS?”).
    •   Metadata doc is thin compared to others: It focuses on tools, not strategy (e.g. “when to rely on embedded vs external metadata, or how Jellyfin interacts with tags”).
    •   Jellyfin doc is very long and internally detailed — could overwhelm new readers without an up-front flow diagram.
    •   Sever places hav sections that are answers to questions I asked previously. e.g. `## 11) What “the first version is selected by default” actually means`. It feels weird to new readers because the answer appears to a question that wasn't asked
    •   No master overview doc — newcomers might not know which file to read first or how the pieces flow.

Suggested Improvements

Structural

1. Add a 0-overview.md
    •   Summarize the entire pipeline in 1–2 pages.
    •   Include a flow diagram (Disc → MKV → [Remux/Transcode] → Tag → Library).
    •   Link out to the detailed docs (like a table of contents).
    •   This will anchor the reader and prevent “where do I start?” confusion.
2. Merge or cross-reference audio/subtitle material
    •   Right now “Audio” lives partly in rip and partly in transcode.
    •   keep rip.md focused on “what comes off the disc” (formats, quirks), and transcode.md focused on “how to adapt audio/subs to device-friendly versions.”
    •   Add cross-links between the two to help readers navigate
3. Strengthen 3-metadata.md
    •   Add a section: “Embedded metadata vs Jellyfin scraping”. Clarify that embedded tags are mostly for Apple ecosystem / iTunes, while Jellyfin prefers NFOs and file naming.
    •   Show side-by-side examples: MP4 with Subler tags vs Jellyfin .nfo
4. Break up Jellyfin doc for readability
    •   4a-organization.md (folder structure, versions, extras).
        - Instead of "answers" sections like `## 11) What “the first version is selected by default” actually means`, incorporate the information and improve the clarity of the original section that caused the question.
    •   4b-jellyfin-clients.md (Apple TV vs others, direct play/transcode notes).

Content
    •   Add decision tables: e.g.
    •   “You ripped DTS audio. Options: (a) keep DTS in MKV → Jellyfin transcodes for Apple, (b) transcode audio to AC-3 → direct play.”
    •   Helps users choose paths without reading walls of text.
    •   Explicit “storage math” section: put numbers side-by-side (DVD ~4–8 GB, Blu-ray ~25–40 GB, 1080p H.264 CRF18 ~6–12 GB, HEVC ~3–6 GB). Users like quick heuristics.

Please ask me any clarifying questions or suggest your own recommendations to improve the documents before beginning on these changes.
