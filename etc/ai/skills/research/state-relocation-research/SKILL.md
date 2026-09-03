---
name: state-relocation-research
description: Research US states and their metros as domestic relocation destinations with per-state directory structure, six-phase workflow, and subagent delegation patterns. Use when researching US states for relocation, evaluating metros for a domestic family move, or comparing states as relocation destinations.
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

## Templates

All templates live in this skill's `references/` directory. When a phase or subagent prompt names a
template by bare filename, resolve it to
`~/.dotfiles/etc/ai/skills/research/state-relocation-research/references/<name>.md` (equivalently,
`references/<name>.md` relative to this skill):

- **[state-relocation-overview-template.md](references/state-relocation-overview-template.md)** —
  Phase 1 state overview
- **[metro-profile-template.md](references/metro-profile-template.md)** — Phase 2 per-metro (CBSA)
  profile
- **[place-profile-template.md](references/place-profile-template.md)** — Phase 3 per-place
  (city/suburb) profile
- **[education-and-family-template.md](references/education-and-family-template.md)** — Phase 4
- **[adu-and-investment-template.md](references/adu-and-investment-template.md)** — Phase 5
- **[cross-state-rankings-template.md](references/cross-state-rankings-template.md)** — on-demand
  cross-state rankings

Note the distinction from the research corpus: templates live beside this skill under `references/`,
while `_research_/states/…` paths (the metrics JSON, `*-classification.md` files, and generated
output) live in the research repo. Do not look for templates under `_research_/`.

**Passing templates to subagents:** Subagents run with no skill context — they cannot resolve
`references/<name>.md` on their own. Whenever a phase delegates to a subagent, the orchestrator must
pass the **absolute** template path
(`~/.dotfiles/etc/ai/skills/research/state-relocation-research/references/<name>.md`), not a bare
filename or a skill-relative path.

## Family Profile

The target family is defined in the shared profile:
[relocation-shared/family-profile.md](../relocation-shared/family-profile.md). Read it for household
composition and constant priorities. This skill covers the domestic-move priorities below.

### Priorities for Domestic Moves

**Must-haves** (a state failing these is likely disqualified):

- Highly rated public education, measured by **state NAEP scale scores** (2024, grade-4 reading and
  grade-8 math), classified into three tiers by statistical significance versus the national public
  average on each axis (national: reading ~214, math ~272; test
  `|state − national| > 1.96 × √(state_se² + national_se²)`, typical critical difference ~2.8
  reading / ~2.7 math):
  - **Strong** — significantly **above** national on at least one axis and not below on the other
    (e.g. MA, MN, WI, CO, CT, NH, OH, the Dakotas, MT, IL, VT). Demonstrably above-average schools.
    **This is the bar to be a primary relocation candidate on education** — because improving
    schooling is a leading motivation for the move.
  - **Acceptable** — statistically indistinguishable from national on both axes (e.g. ME, MI, NY,
    RI). Not a liability, not a draw; a state here can still merit research for strong healthcare or
    climate, but its schools are not a reason to move. Drops to the secondary list.
  - **Weak / penalize** — significantly **below** national on **both** axes (e.g. New Mexico, West
    Virginia, Oklahoma, Alaska). Flag prominently; pursue only if a specific district demonstrably
    bucks the state trend.
  - This is a **penalize**, not disqualify, filter at the metro/district level (Phases 3–4 are where
    education is really judged), but the *state prior* uses "strong" as the primary bar because
    education is the priority dimension. Flag strong-tier states whose NAEP scores declined year
    over year. See `_research_/states/education-classification.md` for the significance method,
    standard errors, and state distribution.
- Cold-to-temperate climate, measured by **IECC/ASHRAE 169 climate zone** (county-resolved, based on
  heating/cooling degree days):
  - **Pass** — predominantly IECC zone 5, 6, or 7 (Cool / Cold / Very Cold; e.g. MN, WI, MI, MT, VT,
    CO's higher elevations, northern New England)
  - **Marginal** — predominantly zone 4 (Mixed; e.g. VA, KY, MO). Not disqualified, but a specific
    metro must independently reach zone 5+ to qualify (usually via elevation or latitude). Marine
    zone 4C (Puget Sound, Willamette Valley) is marginal-favorable given mild summers.
  - **Disqualified** — predominantly zone 3 or warmer (Warm / Hot / Very Hot; e.g. TX, FL, AZ, GA,
    the Carolinas), unless a specific high-elevation metro independently reaches zone 5+ (the
    Colorado/Steamboat carve-out). The family's Texas baseline is zone 2A–3B — disqualified.
  - **Warming-margin flag** — flag thin-margin qualifiers (borderline zone 4/5) as a climate-change
    risk; the 2021 IECC remap moved ~10% of counties to *warmer* zones, so borderline states trend
    hotter. Prefer states with margin.
  - Heat severity is reported (not filtered) at the metro level via IECC zone, 1% summer design
    temperature, average July high, and days/year ≥90 °F — see the metro profile template.
- Strong healthcare ecosystem, measured by **AAMC direct-patient-care physicians per 100k** (2024;
  national average 255):
  - **Pass** — ≥ 220 direct-patient-care physicians per 100k. Adequate-to-comfortable supply.
  - **Marginal (flag)** — 190–219. The chosen metro must have a real hospital network or academic
    medical center to compensate.
  - **Disqualify (hard floor)** — < 190. Statewide scarcity a metro cannot escape (e.g. Mississippi
    184, Idaho 188, Oklahoma 189; Nevada 195 sits in the marginal band).
  - This is a **hard-floor disqualify** filter — unlike education, a specific metro cannot redeem a
    state below the floor. Use direct-patient-care (not "active") per 100k — it measures access to a
    treating doctor. Flag any state whose ratio is declining year over year. See
    `_research_/states/healthcare-classification.md` for the rubric and state distribution.

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
│   ├── README.md                          ← topic index (phase 6)
│   ├── state-overview.md                  ← phase 1
│   ├── <metro-1>-metro.md                 ← phase 2 (one prose profile per metro/CBSA)
│   ├── <metro-1>-metro-metrics.json       ← phase 2 (companion metro data, same slug)
│   ├── <metro-2>-metro.md
│   ├── <metro-2>-metro-metrics.json
│   ├── ...
│   ├── <place-1>-place.md                 ← phase 3 (one prose profile per evaluated city/suburb)
│   ├── <place-1>-place-metrics.json       ← phase 3 (companion place data, same slug)
│   ├── <place-2>-place.md
│   ├── <place-2>-place-metrics.json
│   ├── ...
│   ├── education-and-family.md            ← phase 4
│   ├── adu-and-investment.md              ← phase 5
│   └── recommendations.md                ← phase 6
└── <state>/
    └── ...
```

## Six-Phase Workflow

Run phases in order. Each phase reads the output of prior phases to avoid duplication. Phase 0 is a
skippable pre-screen that nominates candidate states before the six per-state research phases (1–6)
begin; skip it when the user names a state to research directly.

**Before starting any phase**, check the state directory (`_research_/states/<state>/`) for existing
files. Read all files from prior phases — they contain data, metro/place selections, and
recommendations that the current phase must build on. If a prior phase is missing, stop and complete
it first. If a phase is partially complete (e.g., 3 of 5 metro files exist), complete only the
missing parts. If orphaned `.tmp-*` files exist from a failed phase 1 assembly, clean them up and
re-run phase 1.

| Phase | File(s)                           | Template                                                                                  | Depends On |
| ----- | --------------------------------- | ----------------------------------------------------------------------------------------- | ---------- |
| 0     | *(none — in-conversation screen)* | `_research_/states/state-metrics.json` (research corpus, not `references/`)               | —          |
| 1     | `state-overview.md`               | [state-relocation-overview-template.md](references/state-relocation-overview-template.md) | Phase 0    |
| 2     | `<metro>-metro.md` (one per CBSA) | [metro-profile-template.md](references/metro-profile-template.md)                         | Phase 1    |
| 3     | `<place>-place.md` (one per city) | [place-profile-template.md](references/place-profile-template.md)                         | Phase 2    |
| 4     | `education-and-family.md`         | [education-and-family-template.md](references/education-and-family-template.md)           | Phases 1–3 |
| 5     | `adu-and-investment.md`           | [adu-and-investment-template.md](references/adu-and-investment-template.md)               | Phases 1–3 |
| 6     | `recommendations.md`, `README.md` | *(no template — synthesis)*                                                               | Phases 1–5 |

Each tier recommends the next down: Phase 1 (state) recommends **metros**; Phase 2 (metro)
recommends **places** (cities/suburbs within it); Phase 3 profiles those places. Phases 4 and 5 are
independent and can run in parallel.

**Subagent batching:** when a phase delegates N parallel subagents (N metros in Phase 2, N places in
Phase 3), launch them in tranches of at most **4 concurrent** (adjust down for token-heavy units);
wait for a tranche to finish before launching the next. The phases are already sequential, so metros
and places never compete for the same slots — a per-phase tranche cap is sufficient.

Template links in the table above point to this skill's `references/` directory (see
[Templates](#templates)). Phase 0's `state-metrics.json` is the one exception — it lives in the
research corpus, not `references/`.

**Execution order:** Phase 0 (pre-screen, skip if a state is named) → Phase 1 → Phase 2 → Phase 3 →
Phases 4 + 5 (parallel) → Phase 6. Wait for each step (the parallel 4 + 5 pair counts as one step)
to complete before starting the next.

### Phase 0 — Candidate Pre-Screening

Runs *before* any per-state research to decide **which** states are worth a Phase 1 deep-dive. Where
Phase 1 evaluates a single named state in depth, Phase 0 filters all 50 states at once on the three
must-haves so effort goes to states that can actually clear the bar. Skip Phase 0 only when the user
names a specific state to research directly.

**Data source:** `_research_/states/state-metrics.json` — all 50 states (DC excluded) with verified
raw metrics (IECC populated-zone integer, NAEP 2024 grade-4 reading and grade-8 math, AAMC
direct-patient-care physicians per 100k) plus a `thresholds` block. The file stores raw metrics
only; apply the thresholds at query time so a verdict never goes stale. The three
`*-classification.md` files remain the authoritative method and rationale; this JSON is the data
they are applied to. Check the file's `metadata.last_verified` — if the metric sources have since
updated (NAEP is biennial, AAMC annual), refresh the values before relying on the screen. This file
is queried by path with `jq`, not semantic search, so it is intentionally left out of the research
knowledge base (indexed as `**/*.md` only). Rule of three: revisit indexing JSON only once three or
more small, flat data files live in the corpus. Beyond the raw metrics and `thresholds`, each record
also carries a `fips` join key and four derived verdict fields — see
[The `state-metrics.json` Record](#the-state-metricsjson-record) for their conventions.

**Screen:** Apply all three must-have thresholds (climate, education, healthcare) to each state.
Sort the result into two lists:

- **Primary candidates** — pass **all three** must-haves: climate zone ≥ 5 AND direct-patient-care ≥
  220 AND education in the **strong** tier (significantly above national on at least one axis and
  not below on the other). Education uses the strong bar — not merely "not weak" — because improving
  schooling is a leading motivation for the move. Research these first.
- **Secondary candidates** — pass **exactly two of three**, with the failing dimension named per
  state. This includes states whose education is only *acceptable* (indistinguishable from national,
  not strong) even if they pass climate and healthcare — worth considering when the primary list is
  short or when a state is exceptional on another axis (e.g. Rhode Island and New York have top-tier
  healthcare but only acceptable schools). Name why each missed: `edu(acceptable)`, `edu(weak)`,
  `climate(zone N)`, or `hc(NNN)`. An education miss is *penalize*, not disqualify, so it is a
  softer fail than a healthcare-floor or climate miss.

A `jq` filter over the JSON produces both lists directly; the two thresholds that behave specially
still apply — education never hard-disqualifies (a strong district can redeem it later), and the
healthcare floor (< 190) has no metro exception. Name the failing dimension(s) for every secondary
state so the reader sees *why* it missed. States below the healthcare hard floor should be called
out explicitly even if they clear the other two — Idaho is the standing example (passes climate and
education, fails the healthcare floor).

The pre-screen is deliberately limited to the three must-haves. Nice-to-haves (transit, bike/walk,
nature/trails, ADU adoption, DFW/AUS flights) are tie-breakers applied later, when Phase 6 compares
a short list of already-qualifying metros and places — they do not belong in a 50-state filter.

**Output:** A ranked candidate list (primary, then secondary with failing dimensions) that seeds
Phase 1. This is a lightweight, in-conversation step; it does not produce a research file of its
own. When the user wants a durable comparison of *researched* states, that is the separate on-demand
`rankings.md` (see Cross-State Rankings) — do not conflate the two: Phase 0 nominates candidates
from metric data *before* research, `rankings.md` compares states *after* full research.

## The `state-metrics.json` Record

Each state record in `_research_/states/state-metrics.json` carries three kinds of field: the **raw
metrics** (the verified facts described under Phase 0), a **FIPS join key**, and the **derived
verdict fields**. The metrics are the source of truth; the FIPS key and the verdicts are supporting
fields documented below. The field names below are copied from the live file — mirror them exactly
(run `jq '.states[0]' _research_/states/state-metrics.json` to confirm before editing). A real
record (Minnesota), showing the existing fields plus the `fips` and verdict fields to be added:

```jsonc
{
  "state": "Minnesota",
  "abbr": "MN",
  "fips": "27",                  // ADD: 2-digit zero-padded Census state code (string)
  // ---- raw metrics (source of truth — already in the file) ----
  "climate_zone": 6,             // IECC/ASHRAE zone integer (NOT "iecc_zone")
  "climate_zone_note": "Twin Cities 6A; northern Minnesota 7; predominantly 6A",
  "naep_g4_reading": 214.4,
  "naep_g4_reading_se": 1.49,    // standard error — REQUIRED for the education significance test
  "naep_g8_math": 282.1,
  "naep_g8_math_se": 1.59,       // standard error — REQUIRED for the education significance test
  "aamc_dpc_per_100k": 287,      // direct-patient-care physicians/100k (NOT "physicians_per_100k")
  // ---- derived verdict fields (ADD: regenerated, never hand-authored) ----
  "education_verdict": "strong",
  "climate_verdict": "pass",
  "healthcare_verdict": "pass",
  "candidate_tier": "primary"
}
```

The `naep_*_se` standard-error fields are **not** cosmetic: the education verdict is a significance
test (`|state − national| > 1.96 × √(state_se² + national_se²)`), so it cannot be computed from the
scale scores alone. Any verdict regeneration must read the `_se` fields and the `national_reference`
block in `thresholds`. The record also already carries `abbr` (postal code) — a name-independent
handle, but `abbr` is **not** the geometry join key; FIPS is (see below).

### FIPS Code (the map join key)

A **FIPS code** (Federal Information Processing Standard) is the Census Bureau's stable numeric
identifier for a geographic area. The **state FIPS** is the **2-digit, zero-padded** code — e.g.
`27` = Minnesota, `06` = California, `01` = Alabama. Counties extend it to a 5-digit code (state +
3-digit county); metros use the separate CBSA code (see the analysis doc). Only the 2-digit state
code belongs in `state-metrics.json`.

- **What it is:** the stable identifier that never changes when a state is renamed, reordered, or
  displayed differently. Unlike the state *name* (`"Minnesota"` vs `"MN"` vs `"Minn."`), the FIPS
  code is unambiguous.
- **Format:** store it as a **string**, not an integer — the leading zero matters (`"06"`, not `6`).
  An integer `6` silently drops the zero and breaks the join for the low-numbered states. This is
  the single most common choropleth bug, and the reason Census/Mapbox tooling standardizes on string
  GEOIDs.
- **Where to source it:** the Census Bureau's
  [ANSI/FIPS state codes](https://www.census.gov/library/reference/code-lists/ansi.html), or read
  the `id` field of each state feature in
  [`topojson/us-atlas`](https://github.com/topojson/us-atlas) — the geometry the future map joins
  against. Its README documents that in `states-10m.json`, `us.objects.states`, each state's `id`
  **is** the two-digit FIPS code as a string (e.g. `"06"`) and `properties.name` is the state name.
  Sourcing from the same place the geometry uses guarantees the keys match.
- **When to add it:** to **every** state record in `state-metrics.json` — all 50 states, no
  exceptions. A record without a FIPS key cannot be joined to geometry.
- **How it is read:** it is the **join key** between the research data (this JSON) and the map
  geometry (TopoJSON), which live in separate repos and are joined at render time. The data domain
  produces FIPS-keyed JSON; the future viz domain consumes it. Keying on FIPS (never on names) is
  the one non-negotiable principle of the data architecture — see
  `relocation-map-viz/analysis/data-architecture.md`.

### Verdict Fields (derived, never hand-authored)

Four **verdict** fields materialize the pre-screen judgment onto each record so the map and rankings
can read a ready answer without re-deriving it:

| Field                | Values                               | Derived from (raw metric)                   |
| -------------------- | ------------------------------------ | ------------------------------------------- |
| `education_verdict`  | `strong` / `acceptable` / `weak`     | `naep_g4_reading` + `naep_g8_math` (+`_se`) |
| `climate_verdict`    | `pass` / `marginal` / `disqualified` | `climate_zone`                              |
| `healthcare_verdict` | `pass` / `marginal` / `disqualify`   | `aamc_dpc_per_100k`                         |
| `candidate_tier`     | `primary` / `secondary`              | combined screen (all three)                 |

The three per-dimension verdicts apply that dimension's `thresholds` block to the raw metric; the
combined `candidate_tier` is `primary` only when all three pass at the primary bar (`climate_zone` ≥
5 AND `aamc_dpc_per_100k` ≥ 220 AND education `strong`), otherwise `secondary`. Storing the tier is
more map-ready than deriving it at query time, and it is still recomputable from the three dimension
verdicts.

**The `education_verdict` = `strong` rule has two clauses — do not drop the second.** Strong means
significantly **above** national on **at least one** axis **AND not significantly below** on the
other. An implementation that checks only "above on ≥1 axis" will misclassify a state that is above
in math but significantly below in reading. `education-classification.md` is the authority for the
exact tier boundaries and the significance method; `thresholds.education` in the JSON mirrors it.
When regenerating, treat those two as the source of truth, not this table.

**The verdict value strings intentionally differ per dimension — do not "reconcile" them.**
`climate_verdict` uses `disqualified` while `healthcare_verdict` uses `disqualify`. This is not a
typo: each string mirrors the key used in that dimension's `thresholds` block, so the stored value
matches the block it is derived from. A naive equality check across dimensions will not catch a
`disqualify`/`disqualified` mix-up, so leave the strings as the thresholds block spells them — the
same class of intentional-spelling-difference trap the repo's `AGENTS.md` documents for the V2/V3
chmod deny rules.

**The stored verdict is derived, not authored — this is the core discipline.** Every verdict field
must be reproducible by applying the `thresholds` block to that record's raw metrics. It is stored
for convenience and stability (the map reads it directly; nobody reimplements the NAEP significance
test in the client), **not** because it is an independent fact. Two rules follow:

- **Never hand-edit a verdict field.** Change the raw metric or the threshold, then regenerate.
- **The stored verdict must always equal the regenerated verdict.** Any divergence between the two
  is a **bug**, not a judgment call — it means either the metric changed without a regenerate, or a
  verdict was hand-touched. Treat it as drift to fix, never as a signal to trust the stored value.

This preserves the raw-metric / query-time-verdict purity the data model was designed around (you
can always recompute from metrics) while giving the map and rankings a materialized value to read.

#### Recompute / Confirm / Validate Workflow

The verdict fields (and the `fips` key) are written by a committed regeneration script — the single
writer of those fields. It lives next to the data it operates on:

```text
_research_/states/regenerate-state-verdicts.py
```

It is Python (stdlib only, no dependencies) because the education verdict is a statistical
significance test and that math is clearest and most testable in Python, not a dense `jq`
expression. It reads the `thresholds` block, derives all four verdict fields plus `fips` for every
state, and writes them back **without reformatting the raw-metric fields**. Run it whenever verdicts
may have drifted — after editing any raw metric, after a threshold change, when
`metadata.last_verified` predates a NAEP (biennial) or AAMC (annual) release, or whenever you spot a
verdict that looks wrong:

1. **Recompute** — run the script from anywhere (it locates its sibling data file; no arguments):

   ```bash
   python3 _research_/states/regenerate-state-verdicts.py
   ```

   It rewrites `state-metrics.json` in place, deriving every verdict from the raw metrics and
   `thresholds`. Never hand-write a verdict — change the raw metric or the threshold and re-run.

1. **Confirm** — check the result against what was stored. The script's `--check` mode does this
   without writing (exit 0 = up to date, exit 1 = the file would change):

   ```bash
   python3 _research_/states/regenerate-state-verdicts.py --check
   ```

   Pair it with `git diff state-metrics.json` to see exactly which verdicts moved. Zero diff is the
   expected, healthy state.

1. **Validate** — if the diff is non-empty, understand *why* before trusting it: a raw metric was
   updated without regenerating (expected drift — the recomputed value is correct), a stored verdict
   had been hand-edited (a bug the regenerate corrects), or the `thresholds` themselves changed
   (confirm the change was intended). The recomputed value always wins — the end state is stored ==
   script output.

Because the stored value is derived, regeneration is idempotent: a second run on an already-correct
file produces a zero diff (and `--check` exits 0). That zero diff *is* the validation — it proves
the stored verdicts still follow from the raw metrics and thresholds. This is also the acceptance
test for this documentation: a fresh agent should be able to read this section, run the script, and
confirm a zero diff with no other guidance.

## The Sub-State Metric Records

Where `state-metrics.json` screens **must-haves** (education, climate, healthcare) at the state
grain, the researched sub-state units emit companion metric files capturing the **nice-to-haves**
that differentiate qualifying places. There are **two grains** (see
`relocation-map-viz/analysis/data-architecture.md` Decisions Recorded #4 for the full rationale):

- **Metro record** — `<metro>-metro-metrics.json`, one per **CBSA**, emitted by Phase 2. Metro-wide
  facts only; joins to metro geometry on the **CBSA code**.
- **Place record** — `<place>-place-metrics.json`, one per **evaluated city/suburb**, emitted by
  Phase 3. City-specific facts (this is where walkability lives); joins to Census Place geometry on
  the **7-digit Place GEOID**.

Each record is co-located with its prose profile (matching slug + `-metro` / `-place` suffix). The
viz build merges each grain into its own layer file (`all-metro-metrics.json`,
`all-place-metrics.json`) via `jq -s` — the grain infix in the filename lets it route by glob (that
merge belongs to the viz repo, not here).

The same discipline as the state record applies: **store raw metrics, derive verdicts
deterministically, never hand-author a verdict** — and only add a verdict where a *sourced* bright
line exists. Qualitative nice-to-haves (nature/trails) stay prose; no rubric is invented for them.

### Grain separation (the A1 rule)

A metric never lives at two grains. **A central city is a Place record, not a Metro record** —
Minneapolis is `minneapolis-place-metrics.json` (keyed by its Place GEOID); the CBSA it anchors is a
*separate* `twin-cities-metro-metrics.json` named for the metro, never the central city. This is why
there is no `minneapolis-metro` / `minneapolis-place` name collision. Consequently:

- **Walk / Bike / Transit scores live only on place records** — there is no single "Twin Cities Walk
  Score"; walkability varies by city (Edina 37 vs. St. Paul 80s). Their three verdicts are
  place-grain.
- **Airport access lives only on the metro record** — DFW/AUS direct flights are a metro-wide fact.
  Its verdict is metro-grain.

### Deferred (Level 3)

A composite `metro_tier` / place score (Phase 6's weighted ranking materialized) and a place
`adu_verdict` (its bands are not sourced yet — ADU inputs are stored raw meanwhile) are
**deferred**. The neighborhood grain below the place level (intra-central-city) is also deferred,
sourced to the EPA National Walkability Index — see the analysis doc.

### The metro record

```jsonc
{
  // ---- identity + join keys (required) ----
  "metro": "Minneapolis–St. Paul",
  "cbsa": "33460",              // CBSA code, STRING — the metro map join key
  "state": "Minnesota",
  "state_fips": "27",           // parent state (links to the state layer)
  "counties": ["27003", "27019", "27037", "27053", "27123"],  // 5-digit county FIPS; geometry dissolves from these

  // ---- raw metro-wide metrics (null when unresearched) ----
  "climate_zone": 6,            // metro county IECC zone (may differ from the state's predominant)
  "summer_design_temp_f": 91,
  "avg_july_high_f": 83,
  "days_ge_90f": 13,
  "direct_to_dfw": true,        // raw boolean (airport access is metro-wide)
  "direct_to_aus": false,

  // ---- derived verdict (regenerated, never hand-authored) ----
  "airport_access_verdict": "one"           // both | one | neither
}
```

### The place record

```jsonc
{
  // ---- identity + join keys (required) ----
  "place": "Edina",
  "place_geoid": "2718964",     // 7-digit Census Place GEOID, STRING — the place map join key
  "cbsa": "33460",              // back-reference to the parent metro record
  "state": "Minnesota",
  "state_fips": "27",

  // ---- raw place metrics (null when unresearched) ----
  "median_home_price": 545000,
  "walk_score": 37,             // raw 0–100, city-representative (see caveat)
  "bike_score": 52,
  "transit_score": 40,
  "adu_by_right": true,         // raw inputs for a FUTURE adu_verdict (deferred) — not derived now
  "adu_prevalence": "low",      // high | medium | low

  // ---- derived verdicts (regenerated, never hand-authored) ----
  "walkability_verdict": "car_dependent",   // from walk_score band
  "bikeability_verdict": "bikeable",        // from bike_score band
  "transit_verdict": "some_transit"         // from transit_score band
}
```

### Verdict fields and their bands

The verdicts derive from **standardized** bands that do not vary by place, so — unlike
`state-metrics.json`, which embeds its own `thresholds` block because it is one file — the bands
live in a **single shared** `_research_/states/metro-thresholds.json` rather than duplicated into
every file. The regeneration script and the future viz both read that one file. Verdict strings
mirror Walk Score's official band names (snake_cased) so each stored value traces to a cited source
(<https://www.walkscore.com/how-it-works/>).

| Verdict field            | Grain | Derived from                      | Band values (score floor)                                                                                   |
| ------------------------ | ----- | --------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `walkability_verdict`    | place | `walk_score`                      | `walker_paradise` 90 / `very_walkable` 70 / `somewhat_walkable` 50 / `car_dependent` 0                      |
| `bikeability_verdict`    | place | `bike_score`                      | `bikers_paradise` 90 / `very_bikeable` 70 / `bikeable` 50 / `somewhat_bikeable` 0                           |
| `transit_verdict`        | place | `transit_score`                   | `riders_paradise` 90 / `excellent_transit` 70 / `good_transit` 50 / `some_transit` 25 / `minimal_transit` 0 |
| `airport_access_verdict` | metro | `direct_to_dfw` + `direct_to_aus` | `both` / `one` / `neither` (a boolean pair, not a score band)                                               |

`metro-thresholds.json` is the authority for the exact floors — Walk Score and Transit Score have
five bands, Bike Score four (its lowest two collapse into `somewhat_bikeable`); that asymmetry is
the official band count, not an omission. A score at or above a floor and below the next-higher
floor gets that verdict.

Two caveats worth stating in the profile:

- **Store the city-representative Walk/Bike/Transit score** — the single citywide number from the
  place's own walkscore.com page (`walkscore.com/<state>/<city>`). Note notable intra-city
  neighborhood variation in the prose, not as extra JSON fields. If only neighborhood or partial
  scores are available and no city-level number, store `null` for that score (its verdict is simply
  skipped) — **never** synthesize a city number by averaging neighborhood or address scores.
  Per-neighborhood structured scores are a **deferred** tract/block-group layer (EPA index), not a
  place field.
- **Flight routes are volatile.** Store the two booleans as the raw fact; the file's `last_verified`
  date carries freshness. The verdict derives from the booleans.

#### Recompute / Confirm / Validate Workflow

Both grains' verdicts are written by `_research_/states/regenerate-place-verdicts.py` — the single
writer, sibling to `regenerate-state-verdicts.py`. It is Python (stdlib only), globs every
`_research_/states/*/*-metrics.json` (the `*/` path segment excludes the state-grain
`state-metrics.json`; the glob catches both `-metro-` and `-place-` files), reads
`metro-thresholds.json` for the bands, derives each verdict from the raw fields, and writes them
back **without reformatting the raw fields**. Skip-null routing makes grain automatic: a metro
record (flight booleans, no scores) gets only `airport_access_verdict`; a place record (scores, no
booleans) gets the three score verdicts. A verdict whose raw input is `null` or absent is skipped.

1. **Recompute** — run it from anywhere (no arguments; it locates its sibling files):

   ```bash
   python3 _research_/states/regenerate-place-verdicts.py
   ```

   Never hand-write a verdict — change the raw metric (or `metro-thresholds.json`) and re-run.

1. **Confirm** — `--check` reports without writing (exit 0 = all up to date, exit 1 = some file
   would change):

   ```bash
   python3 _research_/states/regenerate-place-verdicts.py --check
   ```

   Pair with `git diff` to see which verdicts moved. Zero diff is the healthy state.

1. **Validate** — a non-empty diff means a raw metric changed without a regenerate (expected drift —
   the recomputed value wins), a verdict was hand-edited (a bug the regenerate corrects), or the
   shared bands changed. The recomputed value always wins — stored == script output.

Because verdicts are derived, regeneration is idempotent: a second run on a correct file is a zero
diff. When no metro/place files exist yet, the script exits 0 with "nothing to regenerate."

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
(education, climate, healthcare access)? For **climate**, classify the state by its predominant IECC
zone: zone 5+ passes, zone 4 is marginal (a specific metro must reach zone 5+), zone 3 or warmer is
disqualified. For **education** (NAEP 2024), the state prior is three-tier against the national
public average (test each axis with `|state − national| > 1.96 × √(state_se² + national_se²)`):
strong = significantly above national on at least one axis and not below on the other; acceptable =
indistinguishable on both; weak = significantly below on both — penalize, do not disqualify, since a
strong district can redeem a state. Education uses the **strong** tier as the primary-candidate bar
because it is the leading move motivation; acceptable-education states are secondary. For
**healthcare** (AAMC direct-patient-care physicians per 100k), pass ≥ 220, 190–219 is marginal, and
< 190 is a **hard-floor disqualify** a metro cannot escape. If it fails a must-have, say so plainly
and note whether metro-level research is still warranted — e.g., a mostly-warm state with one
high-elevation metro in zone 5+ (the Colorado/Steamboat carve-out), or a weak-tier education state
where a specific district excels (no climate/healthcare exception rescues a healthcare-floor
failure, though). Flag thin-margin (borderline zone 4/5) climate qualifiers as a warming risk, and
flag declining NAEP or physician trends. See `_research_/states/education-classification.md` and
`_research_/states/healthcare-classification.md` for the education and healthcare rubrics
(`climate-classification.md` covers climate).

The must-haves interact — report the tensions honestly rather than glossing them. Worked example:
**Idaho** passes climate (cold) and has **strong** education (grade-8 math 278.1, significantly
above national) but **fails the healthcare hard floor** (188 direct-patient-care physicians per
100k, below 190). It clears two must-haves — including the priority education dimension at the
highest tier — yet the healthcare floor keeps it off the primary list. Because healthcare has no
metro exception, a qualifying-metro pursuit would require a metro with an unusually strong hospital
network, and even then the state-level scarcity remains a standing concern. This is the kind of
repeatable, defensible verdict the thresholds exist to produce — as opposed to a vibes-based "Idaho
seems nice."

**Subagent delegation:** Although this is a single file, it covers many independent research domains
that require heavy web fetching. Delegate to parallel subagents by topic area (e.g.,
geography/climate/nature, education/healthcare, tax/COL/housing, ADU-law/internet/airports). Each
subagent prompt must specify which template sections it owns, include the absolute path to the
`state-relocation-overview-template.md` template (see [Templates](#templates)), and instruct the
subagent to read it and use the exact `##` headings from the template. Subagents must write output
to a temp file — not return it as text. This keeps the orchestrator's context clean for assembly.

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

### Phase 2 — Metro Profiles (CBSA grain)

One file per metro (CBSA). The metro tier covers **metro-wide** facts and **recommends the
cities/suburbs** worth evaluating at Phase 3 — it does not carry per-city walkability (that is place
grain).

**Disqualification gate:** Before selecting metros, check Phase 1's disqualification verdict. If the
state failed a must-have with **no** qualifying-metro exception, stop — do not run Phase 2. If it
failed but Phase 1 named specific qualifying-exception metros, run Phase 2 only for those metros.
Only a passing state runs Phase 2 for its full recommended list.

**Metro selection:** Use the metros listed in the state overview's Recommendations section (3–6
metros). The orchestrator reads only that section (not the full file) to extract the metro list,
then delegates one subagent per metro (in tranches of ≤4; see Subagent batching). Recommendations is
always the last `##` section in the file — grep for `^## Recommendations` and read from that line to
EOF.

**Scope:** Metro-wide data only — climate (metro county IECC zone + heat metrics), airport access to
DFW/AUS, metro-level cost band, nature/trails at metro scale, and the state-level context pointer.
Do NOT collect per-city Walk/Bike/Transit scores or per-city school districts here — those belong to
the Place tier (Phase 3). Reference the state overview for state-level context (tax, state ADU law,
state parks system); do not repeat it.

**Subagent delegation:** Each metro is independent — delegate all metros to parallel subagents (in
tranches of ≤4). Each subagent prompt must include the absolute path to the
`metro-profile-template.md` template (see [Templates](#templates)) and instruct the subagent to read
it and follow its structure.

Each subagent produces **two files** (matching slug, `-metro` suffix) and returns only the two
filenames — not the content:

1. **`<metro>-metro.md`** — the prose profile (e.g. `twin-cities-metro.md`), named for the metro,
   never for a central city.
1. **`<metro>-metro-metrics.json`** — the companion **metro-grain** record: join keys (`metro`,
   `cbsa`, `state`, `state_fips`, `counties[]`) plus metro-wide raw facts (`climate_zone`,
   `summer_design_temp_f`, `avg_july_high_f`, `days_ge_90f`, `direct_to_dfw`, `direct_to_aus`).
   Write `null` for anything unresearched. **No walk/bike/transit** (place grain) and **no verdict
   fields** except that the regeneration script fills `airport_access_verdict`. See
   [The sub-state metric records](#the-sub-state-metric-records) for the schema.

**Sourcing the metro join keys (`cbsa` + `counties[]`):** unlike the raw metrics, these are not
prose research — they are **mechanical lookups** of stable Census identifiers. The **`cbsa`** is the
metro's 5-digit Census CBSA code (string, preserve any leading zero); **`counties[]`** is the list
of 5-digit county FIPS the CBSA is composed of (the map dissolves these into the metro shape via
`topomerge`). Source them in this order:

1. **Check `_research_/states/geo-crosswalk.json` first** — an append-only table of
   already-looked-up join keys. If the metro is present, read `cbsa` + `counties` from it (zero
   network):
   `jq '.[] | select(.grain=="metro" and .slug=="<slug>")' _research_/states/geo-crosswalk.json`.
1. **If absent, run the lookup tool** and append its output row to the crosswalk so the next lookup
   is free: `python3 _research_/states/census-geo-lookup.py metro <cbsa>`. It fetches only the
   matched rows from the Census delineation file — it does **not** dump the source into context.

**Never `web_fetch` Wikipedia or a rendered Census HTML page for these IDs** — that costs tens of
thousands of tokens for a handful of facts. The crosswalk + tool exist precisely to avoid it. Every
metro record needs `cbsa` + `counties[]` — a record without `cbsa` cannot join to geometry.

**Recommended cities (the seam into Phase 3):** the metro profile must end with a
`## Recommended Cities` section naming 3–5 incorporated cities/suburbs within the metro worth a
Place deep-dive, each with a one-line rationale (its key differentiators — strong transit, elite
school district, high ADU adoption). This mirrors the state→metro seam one grain down: Phase 3 reads
only this section to get its place list. You cannot profile all of a metro's suburbs — the metro
tier is where the knowledge of *which* cities matter lives.

**After all subagents complete**, derive the metro-grain verdict and confirm:

```bash
python3 _research_/states/regenerate-place-verdicts.py          # fills airport_access_verdict (metro) + score verdicts (place)
python3 _research_/states/regenerate-place-verdicts.py --check   # confirm zero diff (exit 0)
```

The script is the single verdict writer for both grains; on metro records it derives only
`airport_access_verdict` from the two flight booleans. A verdict whose raw input is `null` is
skipped.

### Phase 3 — Place Profiles (city/suburb grain)

One file per **evaluated city/suburb** — the grain at which the family actually chooses (you buy in
Edina, not "in the Twin Cities"). This is where per-city Walk/Bike/Transit scores, local prices,
school districts, and local ADU ordinances live. A central city (Minneapolis, St. Paul) is a
**place** record, keyed by its Place GEOID — never a metro record (see
[The sub-state metric records](#the-sub-state-metric-records)).

**Place selection:** Use the cities listed in each metro profile's `## Recommended Cities` section
(3–5 per metro). The orchestrator reads only that section from each `<metro>-metro.md`, then
delegates one subagent per place (in tranches of ≤4). Do not invent places not recommended by a
metro profile.

**Scope:** City-specific data only — Walk/Bike/Transit scores (free per-place walkscore.com), local
median home price, the local school district(s), the local ADU ordinance, and city-level livability.
Reference the metro profile for metro-wide context (climate, airport); do not repeat it.

**Subagent delegation:** Each place is independent — delegate all places to parallel subagents (in
tranches of ≤4). Each subagent prompt must include the absolute path to the
`place-profile-template.md` template (see [Templates](#templates)) and the one-line rationale from
the metro's Recommended Cities entry so it focuses on the right differentiators.

Each subagent produces **two files** (matching slug, `-place` suffix) and returns only the two
filenames:

1. **`<place>-place.md`** — the prose profile (e.g. `edina-place.md`).
1. **`<place>-place-metrics.json`** — the companion **place-grain** record: join keys (`place`,
   `place_geoid`, `cbsa` back-reference, `state`, `state_fips`) plus raw facts (`median_home_price`,
   `walk_score`, `bike_score`, `transit_score`, `adu_by_right`, `adu_prevalence`). Write `null` for
   anything unresearched. **Do not write the verdict fields** — the script derives
   `walkability_verdict`, `bikeability_verdict`, and `transit_verdict`.

**Sourcing the place join key (`place_geoid`):** the 7-digit Census **Place GEOID** (string;
preserve leading zeros) is a **mechanical lookup**, sourced in the same order as the metro keys:

1. **Check `_research_/states/geo-crosswalk.json` first** — if the place is present, read
   `place_geoid` from it:
   `jq '.[] | select(.grain=="place" and .slug=="<slug>")' _research_/states/geo-crosswalk.json`.
1. **If absent, run the lookup tool** and append its row to the crosswalk:
   `python3 _research_/states/census-geo-lookup.py place <state_fips> "<City Name>" --cbsa <cbsa>`
   (use the Census spelling — e.g. `"St. Paul"`, not `"Saint Paul"`; the tool warns on a miss). It
   fetches only the matched gazetteer rows, never dumping the file into context.

**Never `web_fetch` a rendered HTML page for the GEOID** — use the crosswalk/tool. `cbsa`
back-references the parent metro's record. A place record without a `place_geoid` cannot join to
geometry.

**After all subagents complete**, derive the place-grain verdicts and confirm:

```bash
python3 _research_/states/regenerate-place-verdicts.py          # fills walk/bike/transit verdicts
python3 _research_/states/regenerate-place-verdicts.py --check   # confirm zero diff (exit 0)
```

This fills `walkability_verdict`, `bikeability_verdict`, and `transit_verdict` from the raw scores
via the shared `metro-thresholds.json` bands (a verdict whose input is `null` is skipped). See the
record section's Recompute/Confirm/Validate workflow.

### Phase 4 — Education & Family

Read the state overview and all metro and place files first. Cross-cutting analysis of education
across all profiled places. Covers public school-district ratings (elementary/middle/high), magnet
and charter options, extracurriculars, pediatric healthcare access, and general kid-friendliness.
Ranks places for this family.

**Subagent delegation:** Single subagent. Prompt must include the absolute path to the
`education-and-family-template.md` template (see [Templates](#templates)). Subagent writes directly
to `education-and-family.md` and returns only the filename.

### Phase 5 — ADU & Investment

Read all prior files first. Cross-cutting analysis of Accessory Dwelling Unit adoption and property
investment across all profiled metros. Covers local ADU ordinances (are ADUs permitted by right?
size/permit constraints), ADU adoption rates and prevalence in the housing stock, purchase prices,
rental yields, and the multigenerational-use angle (future flexibility to host aging parents, adult
children, or guests — the profile defines no current extended-family member, so treat this as
optionality, not a fixed requirement). Also covers general buy-to-rent viability. Identifies best
places for a property with ADU potential.

**Subagent delegation:** Single subagent. Prompt must include the absolute path to the
`adu-and-investment-template.md` template (see [Templates](#templates)). Subagent writes directly to
`adu-and-investment.md` and returns only the filename.

### Phase 6 — Synthesis & Indexing

1. `recommendations.md` — Cross-cutting analysis ranking places for this family. Scoring weights:
   education (35%), climate fit (20%), healthcare access (15%), livability (15%: transit, bike,
   walk, nature/trails), ADU & investment (10%), cost of living (5%). Be direct and opinionated. Use
   inline citations referencing data from other files.
1. `README.md` — Topic index with summary table linking all files.
1. Update root `_research_/README.md` master index.

**Subagent delegation:** Delegate `recommendations.md` to a single subagent. The subagent reads all
prior phase files (state overview + metro profiles + place profiles + education & family + ADU &
investment), writes `recommendations.md`, and returns only the filename. The orchestrator then
writes `README.md` (topic index) and updates the root `_research_/README.md` master index — these
are small cross-cutting files the orchestrator can handle directly.

## Cross-State Rankings

`_research_/states/rankings.md` compares all researched states side-by-side. This is separate from
the per-state six-phase workflow — it runs on demand, not automatically after a state completes.

**Input:** The `recommendations.md` file from each state that has completed all 6 phases. The
subagent reads only these files — not the full research corpus for each state.

**Content:** Rank states using the same weighted criteria as per-state recommendations (see Phase 6
scoring weights). Include a summary table, per-dimension winners, key tradeoffs, and a direct
overall recommendation for this family. Use inline citations referencing each state's
recommendations file.

**Subagent delegation:** Single subagent. Prompt must include the absolute path to the
`cross-state-rankings-template.md` template (see [Templates](#templates)). The subagent reads all
`<state>/recommendations.md` files, writes `rankings.md`, and returns only the filename. The
orchestrator updates `states/README.md` to link to it. The subagent must **not** read any existing
`rankings.md` — always generate fresh to avoid anchoring to previous rankings.

**When to run:** Manually triggered when the user wants a comparison. Requires at least 2 states
with completed research.

## Citation and Verification Rules

Inherited from `create-research` skill — no additions needed. Use inline `[source-key]` citations,
YAML `sources` frontmatter, and `[UNVERIFIED]` markers.

## Prompt Shorthand

Once this skill and templates exist, prompts can be as short as:

```text
Pre-screen states for relocation — which states pass the must-haves?
```

```text
Research <state> for relocation — phase 1 (state overview).
```

```text
Continue <state> relocation — phase 2 (metro profiles).
```

```text
Continue <state> relocation — phase 3 (place/city profiles).
```

```text
Research <state> for relocation — all phases.
```

```text
Update state rankings.
```

The agent loads the `create-research` skill (for general conventions) and this skill (for domestic
relocation workflow), then uses the appropriate template.
