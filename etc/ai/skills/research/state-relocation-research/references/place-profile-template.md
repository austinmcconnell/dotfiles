---
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
last_verified: YYYY-MM-DD
update_summary: Initial research — <Place> (city/suburb) as domestic relocation destination for US family of 5
sources:
  source-key:
    url: https://example.com
    verified: YYYY-MM-DD
---

# {Place} — Place Profile for US Family Relocation

City/suburb-specific data only — this is the grain at which the family actually chooses (you buy in
this city, not "in the metro"). For metro-wide context (climate, airport access, metro housing
market, nature/trails at metro scale), see this place's parent `<metro>-metro.md` profile and the
[state-overview.md](state-overview.md) for state-level context. Do not repeat either.

> **Companion data file:** alongside this prose profile, emit a structured
> `<place>-place-metrics.json` (same slug, `-place` suffix) capturing the machine-readable
> city-level values — the 7-digit Census **Place GEOID**, the `cbsa` back-reference to the parent
> metro, the local median home price, the Walk/Bike/Transit Scores, and the local ADU inputs. Its
> three **verdict** fields (`walkability_verdict`, `bikeability_verdict`, `transit_verdict`) are
> *derived* by `regenerate-place-verdicts.py`, never hand-authored — write the raw metrics and run
> the script. See the `## The Sub-State Metric Records` section of the `state-relocation-research`
> skill for the schema, bands, and workflow.
>
> **Sourcing the `place_geoid`:** the 7-digit Census Place GEOID (string; preserve leading zeros),
> from the Census Place code lists or the `id` of the place feature in the Census Place cartographic
> geometry. A place record without it cannot join to map geometry.

## Overview

Brief description of the city/suburb: character, vibe, position in the metro (central city,
first-ring suburb, exurb), and who it suits. One-sentence scope statement — this file covers the
city, not the metro.

## Cost of Living & Housing

City-specific prices — do not repeat metro or state averages.

| Category                                | Estimate  |
| --------------------------------------- | --------- |
| Median home price                       | $XXX,XXX  |
| 3-bed home price (family-friendly area) | $XXX,XXX  |
| 3-bed rent                              | $X,XXX/mo |
| Groceries, family of 5                  | ~$XXX/mo  |
| Utilities (incl. heating)               | $XXX/mo   |

Family-friendly areas within the city — name each with brief character notes and typical price band.
Note local housing-market conditions (tight, buyer-friendly, low inventory).

## School Districts

The domestic education axis at city grain — the district(s) serving this city.

| District   | Elementary | Middle | High  | Rating Source      | Notes                    |
| ---------- | ---------- | ------ | ----- | ------------------ | ------------------------ |
| District A | A/B/C      | A/B/C  | A/B/C | GreatSchools/state | Enrollment/boundary note |

For the top districts:

- Ratings by level (elementary, middle, high) with the source and year
- How to access them (attendance boundaries, home-price premium, open enrollment, magnet/charter
  admission)
- Standout programs (STEM, IB, gifted, arts)
- Class sizes and student-teacher ratios if available

## Walkability & Public Transit

The Walk/Bike/Transit scores here drive this place's three derived verdicts.

- **Walk Score / Bike Score / Transit Score** for the city (the city-representative walkscore.com
  score — walkscore.com/`<state>`/`<city>`). Note notable intra-city neighborhood variation in
  prose, but store one city-representative number per score in the JSON. If no city-level number is
  available (only neighborhood or partial scores), store `null` — never average neighborhood scores
  into a synthetic city number.
- Transit system access (mode — light rail/bus/commuter rail, coverage, reliability, monthly pass)
- Car-dependency assessment for a family
- Bike infrastructure — protected lanes, network connectivity

## ADU Landscape

Local ADU rules and prevalence (state law context is in the state overview; metro context in the
metro profile).

- Local ordinance: are ADUs permitted by right? Size, owner-occupancy, parking, permit constraints
- Adoption/prevalence — how common are ADUs in the existing housing stock?
- Typical ADU build cost and rental income potential locally
- Suitability for the multigenerational-use and rental-income goals

## Family Livability

Parks, playgrounds, libraries, kid-friendly activities, cultural offerings, youth sports/recreation.
City-specific safety (if data exists). General family-friendliness.

## Assessment

Honest pros/cons of this city for the target family (US family of 5, remote software developer,
three school-age children, relocating from Texas, cold-climate preference). Be direct about
dealbreakers, and about how it compares to the other recommended cities in the same metro.
