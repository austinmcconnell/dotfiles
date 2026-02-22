<!--
Usage Instructions:
Please generate a white paper about <TOPIC>.

Use this file as a flexible skeleton. Omit or adapt sections if they don’t fit the topic,
but keep the overall structure consistent with other System Design Standards white papers.

Scope: Web services (Flask/FastAPI/Django behind Gunicorn/UVicorn), Kubernetes
(Ingress/Service/Deployments), AWS ALB/NGINX Ingress, PostgreSQL-class databases
(PostgreSQL, Aurora PostgreSQL).

Audience and depth: Target a senior software engineer who has broad experience but
no prior depth in this domain. Start from fundamentals and build up.

Emphasis: Include both architectural guidance and implementation guidance. In the first
part, establish architectural guidelines, principles, trade-offs, diagrams, and conceptual
models. In the second part, provide implementation guidance with concrete config, code
snippets, best-practice knobs, and operational practices.

Observability: Always include metrics, dashboards, alerts, and drills to verify correctness
and reliability, unless truly irrelevant.

Length and formality: Aim for 1,000–2,000 words. Use the section structure in this template as
the default, but adapt or omit sections if they don’t fit the topic.

Output format: Markdown file that can be clicked and downloaded.

If you have any clarifying questions, ask before generating the white paper.
-->

# [Title of Standard / Topic]

## Executive Summary

Summarize the problem this white paper addresses, why it matters, and the benefits of solving it.
Target: senior engineers who are experienced but new to this domain.

---

## Background

Explain the ecosystem, typical stack components, and constraints (e.g., frameworks, infra,
databases). Introduce key vocabulary and frame the high-level trade-offs.

---

## Principles / Architectural Guidelines

- **Principle 1 — [Name]:** Short explanation of the rule or guideline.
- **Principle 2 — [Name]:** Another guiding principle.
- **Trade-offs:** Explicitly state where principles may conflict (e.g., performance vs.
  consistency).

---

## Design Patterns

### Pattern A — [Name]

- Explanation of the pattern and when to use it.
- Diagram or conceptual illustration (if useful).
- Example code/config snippet.

### Pattern B — [Name]

- Explanation, trade-offs, snippet.

---

## Anti-Patterns

1. **Anti-pattern 1 — [Name]:** Description of the common mistake and its failure mode.
2. **Anti-pattern 2 — [Name]:** Same format.

---

## Implementation Guidance

Concrete platform/framework-specific details. Group by stack components. Examples:

### Web Worker (Gunicorn/UVicorn)

- Config knobs, timeout settings, tuning tips.

### Kubernetes (Ingress/Service/Deployments)

- Annotations, lifecycle hooks, readiness/liveness probes.

### AWS ALB / NGINX Ingress

- Key timeouts, headers, caching/connection settings.

### PostgreSQL-Class Databases

- Connection pool settings, query timeouts, caching strategies.

---

## Observability & Verification

- Metrics and dashboards to monitor.
- Drills/tests to run in staging.
- Alerts for early warning of misconfiguration or overload.

---

## Recommendations

A bulleted punch list of actionable best practices. E.g.:

- Always configure timeouts ladder-style (shortest → longest).
- Reserve 30–40% of DB connections for admin/maintenance.
- Monitor cache hit ratios as a first-class SLO.

---

## Conclusion

Tie the loop: how this topic fits into the broader System Design Standards. Reiterate key benefits
(reliability, performance, scalability). End with a principle like: _“Design with failure in mind,
and this practice becomes not a crutch but a foundation.”_
