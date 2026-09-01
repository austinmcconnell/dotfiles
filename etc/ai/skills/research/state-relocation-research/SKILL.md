---
name: state-relocation-research
description: Research US states and their metros as domestic relocation destinations with per-state directory structure, five-phase workflow, and subagent delegation patterns. Use when researching US states for relocation, evaluating metros for a domestic family move, or comparing states as relocation destinations.
---

# State Relocation Research

Conventions for researching US states as domestic relocation destinations. Follows the
`create-research` skill for general research workflow, frontmatter, citations, and subagent
delegation. This skill adds the family profile reference, per-state directory structure, and section
requirements specific to domestic relocation research.

This is the domestic counterpart to `country-relocation-research`. State is the primary research
unit because the family's highest-priority filters (cold climate, education quality, healthcare
access, nature) eliminate or qualify whole states before metro-level detail matters. Metros are
researched within qualifying states.

## Family Profile

The target family is defined in the shared profile:
[relocation-shared/family-profile.md](../relocation-shared/family-profile.md). Read it for household
composition and constant priorities. This skill covers the domestic-move priorities below.

### Priorities for Domestic Moves

**Must-haves** (a state failing these is likely disqualified):

- Highly rated public education — strong elementary, middle, and high schools
- Cold-to-temperate climate — Northern states preferred, Middle states acceptable; hot Southern
  states are disqualified (heat trend under climate change is a dealbreaker)
- Strong healthcare ecosystem — physician supply and availability, not declining. Track
  physician-per-capita and migration trends (doctors leaving certain states for others)

**Nice-to-haves** (differentiators among qualifying states/metros):

- Public transit (rail, metro), not car-dependent
- Bikeable and walkable neighborhoods
- Proximity to airports with direct flights to DFW and AUS (family currently in Texas)
- Proximity to nature — national/state parks, lakes, wilderness — ideally a short bike ride to
  extensive trail networks connecting parks
- Broad adoption of Accessory Dwelling Units (ADUs) for rental income and multigenerational use

## Per-State Directory Structure

```text
_research_/states/
├── README.md                          ← states index
├── rankings.md                        ← cross-state comparison (see below)
├── <state>/
│   ├── README.md                      ← topic index (phase 5)
│   ├── state-overview.md              ← phase 1
│   ├── <metro-1>.md                   ← phase 2 (one file per metro)
│   ├── <metro-2>.md
│   ├── ...
│   ├── education-and-family.md        ← phase 3
│   ├── adu-and-investment.md          ← phase 4
│   └── recommendations.md            ← phase 5
└── <state>/
    └── ...
```

## Five-Phase Workflow

Run phases in order. Each phase reads the output of prior phases to avoid duplication.

**Before starting any phase**, check the state directory (`_research_/states/<state>/`) for existing
files. Read all files from prior phases — they contain data, metro selections, and recommendations
that the current phase must build on. If a prior phase is missing, stop and complete it first. If a
phase is partially complete (e.g., 3 of 5 metro files exist), complete only the missing parts. If
orphaned `.tmp-*` files exist from a failed phase 1 assembly, clean them up and re-run phase 1.

| Phase | File(s)                           | Template                                | Depends On |
| ----- | --------------------------------- | --------------------------------------- | ---------- |
| 1     | `state-overview.md`               | `state-relocation-overview-template.md` | —          |
| 2     | `<metro>.md` (one per metro)      | `metro-profile-template.md`             | Phase 1    |
| 3     | `education-and-family.md`         | `education-and-family-template.md`      | Phases 1–2 |
| 4     | `adu-and-investment.md`           | `adu-and-investment-template.md`        | Phases 1–2 |
| 5     | `recommendations.md`, `README.md` | *(no template — synthesis)*             | Phases 1–4 |

Phases 3 and 4 are independent and can run in parallel.

**Execution order:** Phase 1 → Phase 2 → Phases 3 + 4 (parallel) → Phase 5. Wait for each step (the
parallel 3 + 4 pair counts as one step) to complete before starting the next.

### Phase 1 — State Overview

Covers state-level data only: geography, climate by region (with the cold-bias filter front and
center), population, education system quality (state rankings, funding, school-district landscape,
homeschooling/online-school law), healthcare ecosystem (physician supply, physician migration
trends, hospital networks, access), cost of living and housing (state averages), state tax stack
(income, property, sales), safety, nature and public land (parks, lakes, wilderness, trail systems
at state level), ADU enabling legislation (does state law permit/encourage ADUs?), internet
infrastructure, and airport access to DFW/AUS. This file is the single source for state-level facts
— metro files must not duplicate it.

**Disqualification check:** State the verdict up front — does this state pass the must-haves
(education, cold-to-temperate climate, healthcare access)? If it fails a must-have, say so plainly
and note whether metro-level research is still warranted (e.g., a state that's mostly too hot but
has one high-elevation metro that qualifies).

**Subagent delegation:** Although this is a single file, it covers many independent research domains
that require heavy web fetching. Delegate to parallel subagents by topic area (e.g.,
geography/climate/nature, education/healthcare, tax/COL/housing, ADU-law/internet/airports). Each
subagent prompt must specify which template sections it owns, include the path to the
`state-relocation-overview-template.md` template, and instruct the subagent to read it and use the
exact `##` headings from the template. Subagents must write output to a temp file — not return it as
text. This keeps the orchestrator's context clean for assembly.

**Temp-file assembly pattern:** Use the pattern defined in the `create-research` skill (Step 0,
"Temp files for assembly," and the assembly steps under "After subagents complete"). In brief:

1. Each subagent writes two files in the state directory: `.tmp-<topic>.md` (body sections only,
   inline `[source-key]` citations, no YAML frontmatter) and `.tmp-<topic>-sources.yaml` (source
   keys and URLs only).
1. Each subagent returns only its temp filenames — not the content.
1. The orchestrator merges the small `-sources.yaml` files into a single YAML frontmatter block
   (`created`, `last_updated`, `last_verified`, `update_summary`, combined `sources`), writes it to
   `.tmp-frontmatter.md`, then shell-concats in the section order defined by the
   `state-relocation-overview-template.md` template. The orchestrator must not read, rewrite, or
   re-synthesize the body sections.
1. Verify the assembled file (`wc -l` of output vs sum of temp line counts) before deleting temps.
1. Delete all `.tmp-*` files after successful assembly.

### Phase 2 — Metro Profiles

One file per metro.

**Disqualification gate:** Before selecting metros, check Phase 1's disqualification verdict. If the
state failed a must-have with **no** qualifying-metro exception, stop — do not run Phase 2. If it
failed but Phase 1 named specific qualifying-exception metros, run Phase 2 only for those metros.
Only a passing state runs Phase 2 for its full recommended list.

**Metro selection:** Use the metros listed in the state overview's Recommendations section (3–6
metros). The orchestrator reads only that section (not the full file) to extract the metro list,
then delegates one subagent per metro. The phase 1 author applies the selection criteria (see Phase
1 Recommendations). Recommendations is always the last `##` section in the file — grep for
`^## Recommendations` and read from that line to EOF.

**Scope:** Metro-specific data only. Reference the state overview for state-level context (tax,
state education landscape, state ADU law, state parks system). Do not repeat it.

**Subagent delegation:** Each metro is independent — delegate all metros to parallel subagents. Each
subagent prompt must include the path to the `metro-profile-template.md` template and instruct the
subagent to read it and follow its structure. Include per-metro research hints extracted from the
Recommendations section — the one-line rationale for each metro identifies its key differentiators
(e.g., strong transit, notable trail network, high ADU adoption, specific school districts) and
should be passed to the subagent so it focuses on what matters. Each subagent writes directly to its
output file (e.g., `minneapolis.md`, `madison.md`) and returns only the filename to the orchestrator
— not the content.

### Phase 3 — Education & Family

Read the state overview and all metro files first. Cross-cutting analysis of education across all
profiled metros. Covers public school-district ratings (elementary/middle/high), magnet and charter
options, extracurriculars, pediatric healthcare access, and general kid-friendliness. Ranks metros
for this family.

**Subagent delegation:** Single subagent. Prompt must include the path to the
`education-and-family-template.md` template. Subagent writes directly to `education-and-family.md`
and returns only the filename.

### Phase 4 — ADU & Investment

Read all prior files first. Cross-cutting analysis of Accessory Dwelling Unit adoption and property
investment across all profiled metros. Covers local ADU ordinances (are ADUs permitted by right?
size/permit constraints), ADU adoption rates and prevalence in the housing stock, purchase prices,
rental yields, and the multigenerational-use angle (future flexibility to host aging parents, adult
children, or guests — the profile defines no current extended-family member, so treat this as
optionality, not a fixed requirement). Also covers general buy-to-rent viability. Identifies best
metros for a property with ADU potential.

**Subagent delegation:** Single subagent. Prompt must include the path to the
`adu-and-investment-template.md` template. Subagent writes directly to `adu-and-investment.md` and
returns only the filename.

### Phase 5 — Synthesis & Indexing

1. `recommendations.md` — Cross-cutting analysis ranking metros for this family. Scoring weights:
   education (35%), climate fit (20%), healthcare access (15%), livability (15%: transit, bike,
   walk, nature/trails), ADU & investment (10%), cost of living (5%). Be direct and opinionated. Use
   inline citations referencing data from other files.
1. `README.md` — Topic index with summary table linking all files.
1. Update root `_research_/README.md` master index.

**Subagent delegation:** Delegate `recommendations.md` to a single subagent. The subagent reads all
prior phase files (state overview + metro profiles + education & family + ADU & investment), writes
`recommendations.md`, and returns only the filename. The orchestrator then writes `README.md` (topic
index) and updates the root `_research_/README.md` master index — these are small cross-cutting
files the orchestrator can handle directly.

## Cross-State Rankings

`_research_/states/rankings.md` compares all researched states side-by-side. This is separate from
the per-state five-phase workflow — it runs on demand, not automatically after a state completes.

**Input:** The `recommendations.md` file from each state that has completed all 5 phases. The
subagent reads only these files — not the full research corpus for each state.

**Content:** Rank states using the same weighted criteria as per-state recommendations (see Phase 5
scoring weights). Include a summary table, per-dimension winners, key tradeoffs, and a direct
overall recommendation for this family. Use inline citations referencing each state's
recommendations file.

**Subagent delegation:** Single subagent. Prompt must include the path to the
`cross-state-rankings-template.md` template. The subagent reads all `<state>/recommendations.md`
files, writes `rankings.md`, and returns only the filename. The orchestrator updates
`states/README.md` to link to it. The subagent must **not** read any existing `rankings.md` — always
generate fresh to avoid anchoring to previous rankings.

**When to run:** Manually triggered when the user wants a comparison. Requires at least 2 states
with completed research.

## Citation and Verification Rules

Inherited from `create-research` skill — no additions needed. Use inline `[source-key]` citations,
YAML `sources` frontmatter, and `[UNVERIFIED]` markers.

## Prompt Shorthand

Once this skill and templates exist, prompts can be as short as:

```text
Research <state> for relocation — phase 1 (state overview).
```

```text
Continue <state> relocation — phase 2 (metro profiles).
```

```text
Research <state> for relocation — all phases.
```

```text
Update state rankings.
```

The agent loads the `create-research` skill (for general conventions) and this skill (for domestic
relocation workflow), then uses the appropriate template.
