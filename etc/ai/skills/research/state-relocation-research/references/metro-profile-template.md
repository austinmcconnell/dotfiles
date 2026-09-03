---
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
last_verified: YYYY-MM-DD
update_summary: Initial research — <Metro> metro (CBSA) as domestic relocation destination for US family of 5
sources:
  source-key:
    url: https://example.com
    verified: YYYY-MM-DD
---

# {Metro} — Metro Profile for US Family Relocation

Metro-wide (CBSA-grain) data only. Per-city detail (school districts, walkability, local prices,
local ADU rules) lives in the **place** profiles this metro recommends (Phase 3) — do not collect it
here. For state-level context (tax, state education landscape, state ADU law, state parks system),
see [state-overview.md](state-overview.md).

> **Companion data file:** alongside this prose profile, emit a structured
> `<metro>-metro-metrics.json` (same slug, `-metro` suffix) capturing the machine-readable
> metro-wide values — the CBSA code and composing county FIPS, the climate numbers, and the
> direct-flight booleans. Its one metro-grain **verdict** field (`airport_access_verdict`) is
> *derived* by `regenerate-place-verdicts.py`, never hand-authored — write the raw metrics and run
> the script. **No walk/bike/transit** here (that is place grain). See the
> `## The Sub-State Metric Records` section of the `state-relocation-research` skill for the schema,
> bands, and workflow.

## Overview

Brief metro description: character, vibe, role in the state (capital, largest metro, college town,
etc.). One-sentence scope statement — this file covers the metro (CBSA), not the state and not any
single city within it.

## Population & Demographics

Metro (CBSA) population (with census year). Growth trend (in-migration or out-migration).
Demographic character relevant to a relocating family.

## Climate

Confirm the metro's climate fit against the must-have. Because IECC zones are county-resolved, the
metro has its own zone — state it explicitly (this is what qualifies a marginal or carve-out metro).

Report these heat metrics (descriptive, not a second filter — the IECC zone is the filter):

| Metric                   | Value     | Notes                                            |
| ------------------------ | --------- | ------------------------------------------------ |
| IECC zone (metro county) | 5A/6A/... | Must be 5+ to qualify a marginal/carve-out metro |
| 1% summer design temp    | XX °F     | ~p99 daily high — the "hot end"                  |
| Average July high        | XX °F     | Typical summer afternoon                         |
| Days/year ≥ 90 °F        | XX        | The heat-frequency metric the family cares about |
| Days/year ≥ 100 °F       | XX        | Include where non-trivial                        |

Then cover seasonal ranges, precipitation, snowfall, and heating/cooling needs. A monthly table is
ideal if data is available. Note any warming trend for the metro's county.

## Housing Market (metro overview)

Metro-wide housing conditions only — the market climate, not per-city prices (those go in each place
profile). Note whether the metro is tight/buyer-friendly/low-inventory and the broad price range
across the metro. Name the cities/suburbs where a relocating family typically looks (this previews
the Recommended Cities section below).

## Nature & Trail Access

A high-value nice-to-have, at metro scale. Be specific:

- Proximity of the metro's populated areas to parks, lakes, wilderness
- **Trail networks:** the extent and connectivity of the metro's trail and rail-trail systems, and
  how well parks connect
- Outdoor-recreation options year-round (accounting for winter)

## Healthcare Access

Metro-level care: major hospital systems, academic medical centers, physician availability,
specialist access, pediatric care. Reference the state overview for state-wide physician-supply
trends — add metro-specific detail.

## Internet Infrastructure

Metro fiber availability, typical speeds by provider, reliability. Reference the state overview for
state stats — add only what's different locally. Assessment for remote software development.

## Airport & Travel

Nearest airport (code, distance from metro). Direct routes to DFW and AUS specifically (frequency,
carriers) — these two booleans drive `airport_access_verdict`. Other useful direct routes.
Alternative airports if the primary is limited.

## Assessment

Honest metro-level pros/cons for the target family (US family of 5, remote software developer, three
school-age children, relocating from Texas, cold-climate preference). Be direct about dealbreakers.

## Recommended Cities

The seam into Phase 3. Name **3–5 incorporated cities/suburbs within this metro** worth a Place
deep-dive, each with a one-line rationale identifying its key differentiators (strong transit, elite
school district, high ADU adoption, price band, character). Phase 3 reads *only* this section to get
its place list, so make each entry a clear, self-contained pick.

- **{City A}** — one-line rationale (e.g. most walkable; strong transit; downtown lifestyle).
- **{City B}** — one-line rationale (e.g. elite schools; low-density affluent suburb).
- **{City C}** — one-line rationale.
