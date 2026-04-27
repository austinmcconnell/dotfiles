# Relocation Research Conventions

Conventions for researching countries as relocation destinations. Follows the `create-research`
skill for general research workflow, frontmatter, citations, and subagent delegation. This doc adds
the family profile, per-country directory structure, and section requirements specific to relocation
research.

## Family Profile

All relocation research targets this family unless the user specifies otherwise:

- US family of 5 (two adults, three children — oldest age 9)
- Primary earner works remotely as a software developer
- All English-speaking; no local language proficiency assumed
- Interested in rental property investment as secondary goal
- Priorities: quality education with strong language integration for non-native speakers (public
  schools with integration programs preferred over international schools), reliable internet for
  remote work, family safety, walkable/transit-friendly environment, reasonable cost of living

## Per-Country Directory Structure

```text
_research_/<country>/
├── README.md                      ← topic index (phase 5)
├── country-overview.md            ← phase 1
├── <city-1>.md                    ← phase 2 (one file per city)
├── <city-2>.md
├── ...
├── education-and-family.md        ← phase 3
├── rental-property-investment.md  ← phase 4
└── recommendations.md             ← phase 5
```

## Five-Phase Workflow

Run phases in order. Each phase reads the output of prior phases to avoid duplication.

| Phase | File(s)                           | Template                                  | Depends On |
| ----- | --------------------------------- | ----------------------------------------- | ---------- |
| 1     | `country-overview.md`             | `country-relocation-overview-template.md` | —          |
| 2     | `<city>.md` (one per city)        | `city-profile-template.md`                | Phase 1    |
| 3     | `education-and-family.md`         | `education-and-family-template.md`        | Phases 1–2 |
| 4     | `rental-property-investment.md`   | `rental-property-investment-template.md`  | Phases 1–2 |
| 5     | `recommendations.md`, `README.md` | *(no template — synthesis)*               | Phases 1–4 |

Phases 3 and 4 are independent and can run in parallel.

### Phase 1 — Country Overview

Covers country-level data only: geography, climate by region, population, language, education system
(including national language integration framework for foreign students), cost of living (national
averages), healthcare, safety, quality of life, internet infrastructure, residency/visa pathways
(especially digital nomad visa), and tax obligations (both local and US). This file is the single
source for country-level facts — city files must not duplicate it.

### Phase 2 — City Profiles

One file per city.

**City selection:** Start with the country's 5–8 largest or most notable cities. Drop any that are
clearly irrelevant (e.g., purely industrial, no residential infrastructure). Add any the country
overview suggests are worth including (e.g., known expat hubs, digital nomad hotspots, cities with
strong school integration programs). Read the country overview before selecting cities.

**Scope:** City-specific data only. Reference the country overview for national-level context (visa,
tax, national healthcare, national internet stats, national education framework). Do not repeat it.

**Subagent delegation:** Each city is independent — delegate all cities to parallel subagents.

### Phase 3 — Education & Family

Read the country overview and all city files first. Cross-cutting analysis of education options
across all profiled cities. Covers public school integration programs (preferred), international
schools, extracurriculars, pediatric healthcare, kid-friendliness. Ranks cities for this family.

### Phase 4 — Rental Property Investment

Read all prior files first. Cross-cutting analysis of rental property investment across all profiled
cities. Covers purchase prices, rental yields, legal restrictions on US buyers, tax on rental
income, property management options. Identifies best cities for buy-to-rent.

### Phase 5 — Synthesis & Indexing

1. `recommendations.md` — Cross-cutting analysis ranking cities for this family. Weight: education
   options > internet reliability > livability > rental investment opportunity. Be direct and
   opinionated. Use inline citations referencing data from other files.
1. `README.md` — Topic index with summary table linking all files.
1. Update root `_research_/README.md` master index.

## Citation and Verification Rules

Inherited from `create-research` skill — no additions needed. Use inline `[source-key]` citations,
YAML `sources` frontmatter, and `[UNVERIFIED]` markers.

## Prompt Shorthand

Once this steering doc and templates exist, prompts can be as short as:

```text
Research <country> for relocation — phase 1 (country overview).
```

```text
Continue <country> relocation — phase 2 (city profiles).
```

The agent reads this steering doc, loads the `create-research` skill, and uses the appropriate
template.
