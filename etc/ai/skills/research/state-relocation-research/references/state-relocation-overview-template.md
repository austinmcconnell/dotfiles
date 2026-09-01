---
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
last_verified: YYYY-MM-DD
update_summary: Initial research — <State> as domestic relocation destination for US family of 5
sources:
  source-key:
    url: https://example.com
    verified: YYYY-MM-DD
---

# {State} — State Overview for US Family Relocation

## Overview

One paragraph: what is this state, why consider it for a domestic move, and what makes it relevant
for a US family with a remote software developer relocating from Texas.

## Disqualification Check

State the verdict up front against the three must-haves. This determines whether metro-level
research is warranted.

| Must-Have         | Pass/Fail          | Notes                                                                                |
| ----------------- | ------------------ | ------------------------------------------------------------------------------------ |
| Education (NAEP)  | Weak/Acceptable    | Weak only if sig. below national on both (g8m ≤269 AND g4r ≤211); penalize, not fail |
| Climate (IECC)    | Pass/Marginal/Fail | Predominant IECC zone: 5+ passes, 4 marginal, 3- disqualifies                        |
| Healthcare (AAMC) | Pass/Marginal/Fail | Direct-patient-care MDs per 100k: ≥220 pass, 190–219 marg, \<190 fail                |

For the climate row, state the state's predominant IECC/ASHRAE 169 zone and the verdict:

- **Zone 5, 6, or 7** (Cool / Cold / Very Cold) → Pass
- **Zone 4** (Mixed) → Marginal — a specific metro must independently reach zone 5+ (elevation or
  latitude); marine 4C is marginal-favorable
- **Zone 3 or warmer** (Warm / Hot / Very Hot) → Fail, unless a high-elevation metro reaches zone 5+
  (Colorado/Steamboat carve-out)

For the education row, state the state's 2024 NAEP grade-4 reading and grade-8 math averages and the
verdict:

- **Grade-8 math ≤ 269 AND grade-4 reading ≤ 211** (statistically significantly below the national
  public average on both axes, past the ~2.7–2.8-point p\<.05 critical difference) → Weak —
  penalize, pursue only if a specific district bucks the trend.
- **Otherwise** → Acceptable — at, above, or statistically indistinguishable from national on at
  least one axis; no state-level education penalty. A state well above national on both is a
  positive signal worth noting. Education never hard-disqualifies (district variance).

For the healthcare row, state the state's AAMC direct-patient-care physicians per 100k and the
verdict:

- **≥ 220** → Pass (national average 255)
- **190–219** → Marginal — the chosen metro must have a real hospital network / academic medical
  center
- **< 190** → Fail (hard floor) — statewide scarcity a metro cannot escape; no metro exception

If the state fails or is marginal on a must-have, say so plainly. Note any exception — a single
high-elevation or northern metro in zone 5+ that qualifies despite a state-wide climate fail, or a
standout district in a below-pass education state. A healthcare-floor failure (< 190) has **no**
metro exception. Flag thin-margin climate qualifiers (borderline zone 4/5) as a warming risk — the
2021 IECC remap shifted ~10% of counties to warmer zones — and flag declining NAEP or
physician-supply trends even where the level still passes.

## Geography and Climate

Physical geography, regions, elevation. Classify climate by IECC/ASHRAE 169 zone (county-resolved),
which is the filter for the climate must-have. Note within-state zone variation — elevation and
latitude can span two or more zones (Colorado runs 4B to 7). Flag regions that run too warm and any
warming trend.

| Region   | IECC Zone | Climate Type | Avg July High | Winter Lows | Climate Fit              | Notes      |
| -------- | --------- | ------------ | ------------- | ----------- | ------------------------ | ---------- |
| Region A | 5A/6A/... | Type         | XX °F         | XX °F       | Pass/Marginal/Disqualify | Trend note |
| Region B | 4A/...    | Type         | XX °F         | XX °F       | Pass/Marginal/Disqualify | Trend note |

State the predominant zone for the whole state and where the population concentrates. See
`_research_/states/climate-classification.md` for the zone rubric, HDD/CDD thresholds, and the
warming trend. Cite the IECC/ASHRAE 169 zone map and NOAA state temperature data as the standard
sources.

## Population

- Population (with year) and growth trend (in-migration or out-migration)
- Urban/rural split
- Major metros with populations

## Education System

State-level education landscape only — metro files cover local district quality.

- State ranking(s) for K-12 (cite the ranking source and year)
- Per-pupil funding and how it compares nationally
- School-district structure — how districts are organized, how quality varies within the state
- **NAEP performance (the education screen):** state 2024 grade-4 reading and grade-8 math scale
  scores, with the two-tier verdict against the national public average (~214 reading / ~272 math):
  weak if significantly below national on both axes (g8 math ≤ 269 AND g4 reading ≤ 211), otherwise
  acceptable. See `_research_/states/education-classification.md` for the significance method and
  standard errors. Note the year-over-year trend.
- School-choice landscape: charter/magnet availability, open enrollment rules
- **Homeschooling and online school law:** Is homeschooling legal and how is it regulated
  (notice/registration, testing or portfolio review, curriculum requirements)? Availability of
  accredited online/virtual public schools. This is the Phase 3 fallback if district quality is
  uneven — the education-and-family analysis references this section.
- Notable strong districts at a high level (detail goes in metro files)

## Healthcare Ecosystem

This is a must-have — be specific.

- **AAMC direct-patient-care physicians per 100k (the healthcare screen):** state figure vs the 220
  pass line, 190 hard floor, and national average of 255 (cite year). Use direct-patient-care, not
  "active." See `_research_/states/healthcare-classification.md` for the rubric.
- **Physician migration trend:** Are doctors moving into or out of this state? Cite recent data on
  physician supply direction — a declining ratio is a flag even above the floor
- Major hospital systems and academic medical centers
- Rural vs urban access gaps
- Any policy factors affecting physician retention (licensing, malpractice climate, reimbursement)

## Cost of Living and Housing

State averages. Metro files cover local prices.

| Category                          | Estimate  |
| --------------------------------- | --------- |
| Cost-of-living index (US avg=100) | XXX       |
| Median home price (state)         | $XXX,XXX  |
| Median 3-bed rent                 | $X,XXX/mo |
| Groceries (family of 5)           | ~$XXX/mo  |
| Utilities (incl. heating)         | $XXX/mo   |
| Home internet (100–500 Mbps)      | $XX–XX/mo |

Note heating cost implications given the cold-climate preference.

## State Tax Stack

The domestic tax picture is about state and local taxes — there is no visa or foreign-tax angle.

| Tax           | Rate / Structure                          |
| ------------- | ----------------------------------------- |
| State income  | Flat X% / progressive X–X% / none         |
| Property tax  | Effective X.XX% of home value (state avg) |
| Sales tax     | State X% + avg local X% = X% combined     |
| Other notable | Vehicle, estate, capital gains treatment  |

Add a paragraph on the total tax burden for a remote worker earning a software-developer salary,
compared to Texas (no state income tax, higher property tax) as the family's baseline.

## Safety

State-level crime data (violent and property, cite source and year). General safety assessment for
families. Metro-specific detail goes in metro files.

## Nature and Public Land

A nice-to-have the family weights highly. State-level inventory:

- National parks, national forests, state parks, wilderness areas
- Lakes, rivers, coastline
- Notable long-distance trail systems and rail-trails
- General outdoor-recreation reputation and access

Metro files cover local trail networks and park proximity — this section is the state-wide picture.

## ADU Legislation

Does state law permit or encourage Accessory Dwelling Units?

- Statewide ADU law (if any) — does it preempt local bans, mandate by-right approval, cap fees?
- Recent legislative changes or pending bills
- How much is left to local ordinance (metro files cover local rules)

This sets up the phase-4 ADU analysis. If the state has no enabling law and leaves everything to
localities, note that metros will vary widely.

## Internet Infrastructure

State-level data. Table format:

| Metric                    | Value     |
| ------------------------- | --------- |
| Avg fixed download speed  | XXX Mbps  |
| Fiber (FTTH) availability | XX%       |
| Broadband coverage        | XX%       |
| Home internet cost        | $XX–XX/mo |

Key providers, rural vs urban gaps, Starlink relevance for rural/nature-adjacent areas. Assessment
for remote software development.

## Airport Access

The family relocates from Texas and will travel back to DFW and AUS.

| Metro Airport | Code | Direct to DFW | Direct to AUS | Notes              |
| ------------- | ---- | ------------- | ------------- | ------------------ |
| Airport A     | XXX  | Yes/No        | Yes/No        | Frequency, carrier |

Note which metros have direct service to the family's Texas home airports — a nice-to-have that
shapes metro ranking.

## Recommendations

Brief assessment: is this state worth proceeding to metro-level research? Restate the
disqualification verdict, then give the top 2–3 strengths and top 2–3 concerns for this family.

**Phase 2 metros:** List 3–6 metros for metro-level research. Selection criteria: population and
amenities, school-district quality, transit and bike/walk infrastructure, proximity to nature and
trail networks, ADU adoption, direct flights to DFW/AUS, and climate fit within the state. Drop
metros that fail the climate filter or lack the family's core priorities. Include at least one
smaller or unconventional pick if it has a compelling differentiator (e.g., exceptional trail
access, unusually high ADU adoption). Present as a bullet list with a one-line rationale per metro.
