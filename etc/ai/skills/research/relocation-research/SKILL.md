---
name: relocation-research
description: Research countries as relocation destinations with per-country directory structure, five-phase workflow, and subagent delegation patterns. Use when researching countries for relocation, evaluating cities for a family move, or comparing relocation destinations.
---

# Relocation Research

Conventions for researching countries as relocation destinations. Follows the `create-research`
skill for general research workflow, frontmatter, citations, and subagent delegation. This skill
adds the family profile, per-country directory structure, and section requirements specific to
relocation research.

## Family Profile

All relocation research targets this family unless the user specifies otherwise:

- US family of 5 (two adults, three children — oldest age 9)
- Primary earner works remotely as a software developer
- All English-speaking; no local language proficiency assumed
- Interested in rental property investment as secondary goal
- EU citizenship is a possibility but not guaranteed; research should cover the digital nomad visa
  pathway as primary and note where EU citizenship would simplify or change the picture
- Priorities: quality education with strong language integration for non-native speakers (public
  schools with integration programs preferred over international schools), reliable internet for
  remote work, family safety, walkable/transit-friendly environment, reasonable cost of living

## Per-Country Directory Structure

```text
_research_/countries/
├── README.md                          ← countries index
├── rankings.md                        ← cross-country comparison (see below)
├── <country>/
│   ├── README.md                      ← topic index (phase 5)
│   ├── country-overview.md            ← phase 1
│   ├── <city-1>.md                    ← phase 2 (one file per city)
│   ├── <city-2>.md
│   ├── ...
│   ├── education-and-family.md        ← phase 3
│   ├── rental-property-investment.md  ← phase 4
│   └── recommendations.md            ← phase 5
└── <country>/
    └── ...
```

## Five-Phase Workflow

Run phases in order. Each phase reads the output of prior phases to avoid duplication.

**Before starting any phase**, check the country directory (`_research_/countries/<country>/`) for
existing files. Read all files from prior phases — they contain data, city selections, and
recommendations that the current phase must build on. If a prior phase is missing, stop and complete
it first. If a phase is partially complete (e.g., 3 of 5 city files exist), complete only the
missing parts. If orphaned `.tmp-*` files exist from a failed phase 1 assembly, clean them up and
re-run phase 1.

| Phase | File(s)                           | Template                                  | Depends On |
| ----- | --------------------------------- | ----------------------------------------- | ---------- |
| 1     | `country-overview.md`             | `country-relocation-overview-template.md` | —          |
| 2     | `<city>.md` (one per city)        | `city-profile-template.md`                | Phase 1    |
| 3     | `education-and-family.md`         | `education-and-family-template.md`        | Phases 1–2 |
| 4     | `rental-property-investment.md`   | `rental-property-investment-template.md`  | Phases 1–2 |
| 5     | `recommendations.md`, `README.md` | *(no template — synthesis)*               | Phases 1–4 |

Phases 3 and 4 are independent and can run in parallel.

**Execution order:** Phase 1 → Phase 2 → Phases 3 + 4 (parallel) → Phase 5. Wait for each step to
complete before starting the next.

### Phase 1 — Country Overview

Covers country-level data only: geography, climate by region, population, language, education system
(including national language integration framework for foreign students), cost of living (national
averages), healthcare, safety, quality of life, internet infrastructure, residency/visa pathways
(especially digital nomad visa), and tax obligations (both local and US). This file is the single
source for country-level facts — city files must not duplicate it.

**Subagent delegation:** Although this is a single file, it covers many independent research domains
that require heavy web fetching. Delegate to parallel subagents by topic area (e.g.,
geography/COL/QoL, healthcare/safety/education/internet, visa/tax/recommendations). Each subagent
prompt must specify which template sections it owns, include the path to the
`country-relocation-overview-template.md` template, and instruct the subagent to read it and use the
exact `##` headings from the template. Subagents must write output to a temp file — not return it as
text. This keeps the orchestrator's context clean for assembly.

**Temp-file assembly pattern:**

1. Each subagent writes **two files** in the country directory:
   - `.tmp-<topic>.md` — body sections only (complete, publication-ready markdown with inline
     `[source-key]` citations, no YAML frontmatter, no sources block)
   - `.tmp-<topic>-sources.yaml` — just the YAML source keys and URLs for that subagent's citations
     (e.g., `source-key:\n  url: "https://..."\n  verified: 2026-05-02`)
1. Each subagent returns only its temp filenames to the orchestrator — not the content.
1. The orchestrator builds the final file **without reading the body temp files into context:**
   - Read only the small `-sources.yaml` files to merge into a single YAML frontmatter block (with
     `created`, `last_updated`, `last_verified`, `update_summary`, and combined `sources`)
   - Write the frontmatter to `.tmp-frontmatter.md`
   - Shell-concat in the section order defined by the `country-relocation-overview-template.md`
     template (read the template's `##` headings to determine the correct sequence):
     `cat .tmp-frontmatter.md .tmp-geography.md .tmp-healthcare.md .tmp-visa.md > country-overview.md`
   - The orchestrator must not read, rewrite, re-summarize, or re-synthesize the body sections. If a
     section needs corrections after review (phase 5 or later), fix the specific issues in the final
     file; do not replace sections wholesale.
1. Verify the assembled file: compare `wc -l` of the output against the sum of the temp file line
   counts. If the output is significantly shorter, the concat failed — investigate before deleting
   temps.
1. The orchestrator deletes all `.tmp-*` files after successful assembly.

### Phase 2 — City Profiles

One file per city.

**City selection:** Use the cities listed in the country overview's Recommendations section. The
orchestrator reads only that section (not the full file) to extract the city list, then delegates
one subagent per city. No manual intervention needed — the phase 1 author applies the selection
criteria (see Phase 1 Recommendations). Recommendations is always the last `##` section in the file
— grep for `^## Recommendations` and read from that line to EOF.

**Scope:** City-specific data only. Reference the country overview for national-level context (visa,
tax, national healthcare, national internet stats, national education framework). Do not repeat it.

**Subagent delegation:** Each city is independent — delegate all cities to parallel subagents. Each
subagent prompt must include the path to the `city-profile-template.md` template and instruct the
subagent to read it and follow its structure. Include per-city research hints extracted from the
Recommendations section — the one-line rationale for each city identifies its key differentiators
(e.g., expat community, specific schools, transit system, climate concern) and should be passed to
the subagent so it focuses on what matters rather than producing generic coverage. Each subagent
writes directly to its output file (e.g., `oslo.md`, `bergen.md`) and returns only the filename to
the orchestrator — not the content. This keeps the orchestrator's context clean for index updates
and follow-up phases.

### Phase 3 — Education & Family

Read the country overview and all city files first. Cross-cutting analysis of education options
across all profiled cities. Covers public school integration programs (preferred), international
schools, extracurriculars, pediatric healthcare, kid-friendliness. Ranks cities for this family.

**Subagent delegation:** Single subagent. Prompt must include the path to the
`education-and-family-template.md` template. Subagent writes directly to `education-and-family.md`
and returns only the filename.

### Phase 4 — Rental Property Investment

Read all prior files first. Cross-cutting analysis of rental property investment across all profiled
cities. Covers purchase prices, rental yields, legal restrictions on US buyers, tax on rental
income, property management options. Identifies best cities for buy-to-rent.

**Subagent delegation:** Single subagent. Prompt must include the path to the
`rental-property-investment-template.md` template. Subagent writes directly to
`rental-property-investment.md` and returns only the filename.

### Phase 5 — Synthesis & Indexing

1. `recommendations.md` — Cross-cutting analysis ranking cities for this family. Scoring weights:
   education (40%), livability (25%), internet infrastructure (15%), rental investment (10%), cost
   of living (10%). Be direct and opinionated. Use inline citations referencing data from other
   files.
1. `README.md` — Topic index with summary table linking all files.
1. Update root `_research_/README.md` master index.

**Subagent delegation:** Delegate `recommendations.md` to a single subagent. The subagent reads all
prior phase files (country overview + city profiles + education & family + rental investment),
writes `recommendations.md`, and returns only the filename. The orchestrator then writes `README.md`
(topic index) and updates the root `_research_/README.md` master index — these are small
cross-cutting files the orchestrator can handle directly.

## Cross-Country Rankings

`_research_/countries/rankings.md` compares all researched countries side-by-side. This is separate
from the per-country five-phase workflow — it runs on demand, not automatically after a country
completes.

**Input:** The `recommendations.md` file from each country that has completed all 5 phases. The
subagent reads only these files — not the full research corpus for each country.

**Content:** Rank countries using the same weighted criteria as per-country recommendations (see
Phase 5 scoring weights). Include a summary table, per-dimension winners, key tradeoffs, and a
direct overall recommendation for this family. Use inline citations referencing each country's
recommendations file.

**Subagent delegation:** Single subagent. Prompt must include the path to the
`cross-country-rankings-template.md` template. The subagent reads all `<country>/recommendations.md`
files, writes `rankings.md`, and returns only the filename. The orchestrator updates
`countries/README.md` to link to it. The subagent must **not** read any existing `rankings.md` —
always generate fresh to avoid anchoring to previous rankings.

**When to run:** Manually triggered when the user wants a comparison. Requires at least 2 countries
with completed research.

## Citation and Verification Rules

Inherited from `create-research` skill — no additions needed. Use inline `[source-key]` citations,
YAML `sources` frontmatter, and `[UNVERIFIED]` markers.

## Prompt Shorthand

Once this skill and templates exist, prompts can be as short as:

```text
Research <country> for relocation — phase 1 (country overview).
```

```text
Continue <country> relocation — phase 2 (city profiles).
```

```text
Research <country> for relocation — all phases.
```

```text
Update country rankings.
```

The agent loads the `create-research` skill (for general conventions) and this skill (for relocation
workflow), then uses the appropriate template.
