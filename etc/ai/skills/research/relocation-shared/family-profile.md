# Relocation Family Profile

Shared target profile for all relocation research — both country-level
(`country-relocation-research`) and US-state-level (`state-relocation-research`). All relocation
research targets this family unless the user specifies otherwise.

This file is the single source of truth for the family's fixed characteristics. Keep it here rather
than duplicating it in each skill — the two skills share the same family, and drift between copies
(e.g., a child's age updated in one skill but not the other) would be a correctness bug.

## Household

- US family of 5: two adults, three children (oldest age 9)
- Primary earner works remotely as a software developer, on US business hours
- All English-speaking; no second-language proficiency assumed
- Currently based in Texas (relevant for domestic climate/tax comparisons and flight routes)

## Constant Priorities

These priorities hold regardless of destination:

- Quality education for three school-age children
- Reliable, fast internet for remote software work
- Family safety
- Walkable and transit-friendly environment
- Reasonable cost of living
- Interest in property investment as a secondary goal (rental income, multigenerational use)

## Destination-Specific Priorities

Priorities that shift by relocation type are defined in each skill, not here:

- **International moves** — see the Priorities section of `country-relocation-research` (visa
  pathway, language integration for non-native speakers, EU-citizenship contingencies, US tax
  abroad).
- **Domestic moves** — see the Priorities section of `state-relocation-research` (cold-climate bias,
  state tax stack, physician availability, ADU adoption, proximity to nature and trail networks,
  direct flights to DFW/AUS).

When a skill's Priorities section conflicts with the constant priorities above, the skill governs
for that relocation type — the constants describe what never changes, the skill describes how the
family weighs a specific kind of move.
