# Timeouts and Connection Budgeting Standards for Reliable Services

## Executive Summary

Modern web services must be both fast and reliable. Two of the most overlooked but
most powerful tools for achieving this are **timeout ladders** and **connection budgets**.

Timeout ladders ensure that work fails quickly and predictably, with each tier in the
stack respecting the limits of the tier beneath it. Connection budgets ensure that no
combination of web pods, workers, and background jobs can exhaust the database’s
hard connection cap.

When designed together, they prevent cascading failures: timeouts fail requests early
instead of allowing them to pile up, and budgets cap concurrency so hot spots or lock
storms don’t drown the database.

This white paper introduces the principles, trade-offs, and best practices for timeouts
and connection budgets. It then provides concrete configuration examples across
Flask/FastAPI/Django (Gunicorn/UVicorn), Kubernetes (Ingress/Service/Deployments),
AWS ALB/NGINX Ingress, and PostgreSQL-class databases (PostgreSQL, Aurora PostgreSQL).

---

## Background

### Why timeouts matter

Distributed systems fail in strange ways. A slow database query can silently consume
all web worker threads, which in turn keep ALB connections open until the edge starts
retrying. Timeouts protect each tier by drawing hard boundaries: work must fail *closer
to the resource* that is slow or broken, not later in the stack.

### Why connection budgets matter

PostgreSQL enforces a hard `max_connections`. If your worst-case number of web pods,
workers, and threads overshoot this cap, the DB will stall or refuse connections,
causing cascading failures. Connection budgets calculate the safe ceiling for each
application tier, leaving headroom for maintenance and admin tasks.

### Together

Timeout ladders and connection budgets complement each other. Without timeouts,
requests linger and fill pools. Without budgets, retries swamp the database even if
timeouts are perfect. Together they form a shield against overload.

---

## Part I — Timeout Ladders

A "ladder" means **shortest → longest**, left to right. Each rung must be **≤** the next.
If an earlier rung is longer than a later one, the later tier will kill work before the
earlier one can clean up, causing retries and connection explosions.

### Rung A — Database (shortest)

- **`lock_timeout`** — maximum wait to acquire a lock (e.g., `ACCESS EXCLUSIVE` during DDL).
  Use tiny values (1–5s).
- **`statement_timeout`** — maximum run time of a statement. Use small values (10–20s)
  for web/worker sessions; raise case-by-case for long jobs.
- **`idle_in_transaction_session_timeout`** — kills sessions stuck in transactions (e.g.,
  client forgot to commit).

**Rule:** `lock_timeout` < `statement_timeout`.

### Rung B — Driver / ORM Pool

- **`pool_timeout`** — how long a thread/goroutine waits to get a DB connection.
- **Pool caps** — `pool_size` + `max_overflow` = hard ceiling of open connections per
  process.

**Rule:** `statement_timeout` ≤ `pool_timeout` < web worker timeout.

### Rung C — Web Worker

- **Request timeout** (Gunicorn `--timeout`) — upper bound for a single HTTP request.
- **Graceful timeout** (Gunicorn `--graceful-timeout`) — drain period after SIGTERM during
  deploy/scale-down.

**Rule:** Web timeouts must exceed DB/pool rungs, but remain less than Kubernetes grace
window.

### Rung D — Kubernetes Draining

- **`preStop` hook** — mark pod NotReady (e.g., touch `/tmp/terminating`) and sleep 10–20s
so Endpoints/Ingress/LB stop routing new traffic.
- **`terminationGracePeriodSeconds`** — max time kubelet waits after SIGTERM before SIGKILL.

**Rule:** `terminationGracePeriodSeconds` ≥ graceful timeout + preStop sleep.

### Rung E — Edge / Load Balancer

- **ALB/Ingress timeouts** — idle/request timeouts at the edge. If shorter than web timeouts,
the edge will sever connections first, causing retries.

**Rule:** Edge timeouts ≥ web request timeout.

---

### Anti-Patterns for Timeouts

1. **Edge timeout < web timeout** — causes premature retries at the edge.
2. **Pool timeout > web timeout** — web request dies while pool is still waiting.
3. **Infinite statement_timeout** — queries hang forever, workers pile up.
4. **Long graceful timeouts without matching kube grace** — pods killed before draining.

---

## Part II — Connection Budgets

The database has a hard cap (`max_connections`). Your apps must cap their worst-case
usage well below it.

### Step A — Compute a safe application budget

1. Determine `max_connections`. For Aurora:
   `LEAST(DBInstanceClassMemory/9531392,5000)`
2. Reserve 30–40% for autovacuum, admin, migrations, maintenance.
3. The remainder is your application budget (~60–70%).

### Step B — Calculate worst-case per tier

Let:

- `P_web` = max web pods (HPA ceiling)
- `W` = workers per pod
- `T` = threads per worker
- `S` = pool size per worker
- `O` = overflow per worker

**Per-worker cap** = `S + O`
**Per-pod cap** = `W × (S + O)`
**Web max** = `P_web × W × (S + O)`

Add background jobs (Celery/RQ: 1 connection per worker), schedulers (1), migrations
(1, or use `NullPool`).

**Constraint:** `Total app max` ≤ application budget.

### Step C — Adjust to fit

- Reduce `S` and/or `O`.
- Reduce HPA max (last resort).
- Use PgBouncer (transaction pooling) to collapse many client connections onto fewer
server connections.

---

### Anti-Patterns for Connection Budgets

1. **Ignoring HPA ceiling** — scaling can silently push apps over DB cap.
2. **Large per-worker pools** — multiplied by pods and workers, they blow past budget.
3. **Mixing pooling modes** — using PgBouncer transaction pooling for migrations (breaks
long-lived transactions).
4. **No headroom** — using 100% of DB max, leaving nothing for autovacuum or admin.

---

## Observability and Verification

- **Timeout drills:** Hold a DB lock in staging; verify requests fail at `statement_timeout`,
not at the web/edge.
- **Connection dashboards:** Chart server connections by `application_name` to confirm
real-world counts respect caps.
- **Alerts:** Warn at ≥70% of `max_connections`, or if retry rates spike.
- **K8s rollout test:** Restart pods; confirm readiness flips, preStop runs, graceful
drain completes before SIGKILL.

---

## Implementation Guidance

### Gunicorn example

```bash
gunicorn app:app   --worker-class gthread   --workers 3   --threads 4   --timeout 60   --graceful-timeout 60   --keep-alive 5
```

### SQLAlchemy (web)

```python
from sqlalchemy.pool import QueuePool
SQLALCHEMY_ENGINE_OPTIONS = {
    "poolclass": QueuePool,
    "pool_size": 5,
    "max_overflow": 2,
    "pool_timeout": 12,
    "pool_recycle": 1800,
    "pool_pre_ping": True,
}
```

### SQLAlchemy (worker/scheduler)

```python
SQLALCHEMY_ENGINE_OPTIONS = {
    "poolclass": QueuePool,
    "pool_size": 1,
    "max_overflow": 0,
    "pool_timeout": 12,
    "pool_recycle": 1800,
    "pool_pre_ping": True,
}
```

### Kubernetes lifecycle

```yaml
lifecycle:
  preStop:
    exec:
      command: ["/bin/sh","-c","touch /tmp/terminating; sleep 15"]
terminationGracePeriodSeconds: 90
```

### Health check

```python
@app.get("/health")
def health():
    terminating = os.path.exists("/tmp/terminating")
    return ("terminating" if terminating else "ok"), 503 if terminating else 200
```

---

## Recommendations

- Order all timeouts DB < pool < web < Kubernetes < edge.
- Cap worst-case app connections at 60–70% of DB max.
- Fail fast on DDL and lock waits.
- Verify periodically with drills and dashboards.
- Use PgBouncer or RDS Proxy where appropriate.
- Treat timeouts and budgets as **first-class SLOs**, not “tuning knobs.”

---

## Conclusion

Timeout ladders and connection budgets are two sides of the same coin. One prevents
work from piling up; the other ensures concurrency never exceeds safe limits.

Together, they protect databases and services from the cascading failures that sink
cloud-native systems.

Design with failure in mind, instrument thoroughly, and these controls become not
just safeguards but enablers of resilient, scalable architectures.
