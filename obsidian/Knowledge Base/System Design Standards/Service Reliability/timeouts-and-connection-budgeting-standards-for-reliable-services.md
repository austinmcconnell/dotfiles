# Timeout & Connection Budgeting Standards for Reliable Services

## Overview

A generic white paper for production systems behind Ingress/ALB and PostgreSQL‑class databases

**Purpose.** Provide a repeatable method to (1) order timeouts so work fails *closer to the
resource* and (2) cap connections so a single hot table or DB stall does not cascade into
outages.

**Scope.** Web services (e.g., Flask/FastAPI/Django behind Gunicorn/UVicorn), Kubernetes
(Ingress/Service/Deployments), AWS ALB/NGINX Ingress, and PostgreSQL‑class databases
(PostgreSQL, Aurora PostgreSQL).

---

## 1) The Timeout Ladder

A "ladder" means **shortest → longest**, left‑to‑right. Each rung must be **≤** the next. If any
earlier rung is longer than a later one, the later component will kill/stack work before the
earlier one can clean up, causing retries and connection explosions.

### Rung A — Database (shortest)

- **`lock_timeout`** — max wait to *acquire* a lock (e.g., `ACCESS EXCLUSIVE` during DDL).
  Use tiny values (1–5s).
- **`statement_timeout`** — max *run time* of a statement. Use small values (10–20s) for
  web/worker sessions; raise case‑by‑case for known long jobs.
- **`idle_in_transaction_session_timeout`** — kills sessions stuck in a transaction (e.g.,
  client forgot to commit).

**Rule:** `lock_timeout` < `statement_timeout`.

### Rung B — Driver / ORM Pool

- **`pool_timeout`** — how long a thread/goroutine waits to *get* a DB connection from the pool.
- **Pool caps** — `pool_size` + `max_overflow` define the **hard ceiling** of open DB
  connections per process.

**Rule:** `statement_timeout` ≤ `pool_timeout` < web worker timeout.

### Rung C — Web Worker

- **Request timeout** (e.g., Gunicorn `--timeout`) — upper bound for handling a single HTTP
  request.
- **Graceful timeout** (e.g., Gunicorn `--graceful-timeout`) — drain period after SIGTERM
  during deploy/scale‑down.

**Rule:** web request/graceful timeouts must exceed DB/pool rungs, but remain **less** than
the Kubernetes grace window.

### Rung D — Kubernetes Draining

- **`preStop` hook** — mark pod NotReady (e.g., create `/tmp/terminating` read by `/health`)
  and **sleep ~10–20s** so Endpoints/Ingress/LB stop routing *new* traffic.
- **`terminationGracePeriodSeconds`** — max time kubelet waits after SIGTERM before SIGKILL.

**Rule:** `terminationGracePeriodSeconds` ≥ graceful timeout + preStop sleep.

### Rung E — Edge / Load Balancer

- **ALB/Ingress timeouts** — idle/request timeouts at the edge. If these are **shorter**
  than the web timeout, the edge will sever connections first, causing retries.

**Rule:** Edge timeouts ≥ web request timeout (or reduce the web timeout to be ≤ edge).

---

## 2) The Connection Budget

Your DB enforces a *hard* limit (`max_connections`). Your apps must **cap** the
*worst‑case* number of client connections (across all pods/processes) well below that limit.

### Step A — Compute a safe application budget

1. Determine `max_connections` (e.g., Aurora:
   `LEAST(DBInstanceClassMemory/9531392,5000)`).
2. Reserve **30–40%** headroom for autovacuum, admin, migrations, maintenance.
3. The remainder is your **application budget** (e.g., ~65% of the hard cap).

### Step B — Calculate worst‑case for each tier

Let:

- `P_web` = max web pods (HPA ceiling)
- `W` = workers per pod
- `T` = threads per worker (for `gthread`/threaded classes; for `sync`, threads are
  ignored)
- `S` = pool size per worker
- `O` = overflow per worker

**Per‑worker server connection cap** = `S + O`
**Per‑pod cap** = `W × (S + O)`
**Web max** = `P_web × W × (S + O)`

Add background systems:

- RQ/Sidekiq/Celery: typically **1** DB connection per worker if you configure
  `pool_size=1, max_overflow=0`.
- Schedulers: **1**.
- Migrations: **NullPool** or 1.

**Total app max** = Web max + background max + scheduler + admin reserve.

**Constraint:** `Total app max` ≤ `Application budget`.

### Step C — Adjust to fit

- Reduce `S` and/or `O` for web pods.
- Reduce HPA max (last resort).
- Or introduce **PgBouncer (transaction pooling)** to collapse many client connections onto
  a smaller server‑connection pool (note: keep migrations out of transaction pooling, or use
  *session* pooling for them).

---

## 3) Migration Safety (DDL)

- Run DDL in **autocommit** mode to minimize lock windows.
- Set **`lock_timeout` small (1–5s)** and **`statement_timeout` bounded (30–60s)** for DDL
  sessions.
- Prefer metadata‑only changes and split backfills into chunks.
- Use **`CHECK ... NOT VALID` + `VALIDATE CONSTRAINT`** for phased enforcement.

**Alembic pattern**:

```python
with engine.connect() as conn:
    conn = conn.execution_options(isolation_level="AUTOCOMMIT")
    conn.exec_driver_sql("SET application_name='alembic-migration'")
    conn.exec_driver_sql("SET lock_timeout='2s'")
    conn.exec_driver_sql("SET statement_timeout='60s'")
    conn.exec_driver_sql("SET idle_in_transaction_session_timeout='60s'")
    # run migrations...
```

---

## 4) Discovering & Setting Edge Timeouts

### AWS ALB

- **Console:** EC2 → Load Balancers → Attributes → *Idle timeout*.
- **CLI:**

```bash
aws elbv2 describe-load-balancer-attributes \
  --load-balancer-arn <ALB_ARN> \
  --query "Attributes[?Key=='idle_timeout.timeout_seconds'].Value" \
  --output text
```

### NGINX Ingress

- **Global (controller ConfigMap):**

```bash
kubectl -n ingress-nginx get configmap
kubectl -n ingress-nginx get configmap <controller-cm> -o yaml | \
  grep -E "proxy-read-timeout|proxy-send-timeout|keep-alive-timeout"
```

- **Per Ingress (annotations):**

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/proxy-read-timeout: "75"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "75"
```

---

## 5) Verification Plan (generic)

1. **Timeout ladder drill:** hold a lock in staging; verify web requests fail at
   `statement_timeout`, not at web/edge.
2. **Migration fail‑fast:** run a DDL needing `ACCESS EXCLUSIVE`; confirm it aborts in ~2s
   when busy and succeeds during lull.
3. **Pod termination drill:** rollout restart; watch readiness flip → preStop sleep →
   SIGTERM → graceful drain within grace window.
4. **Connection budget dashboard:** chart server connections by `application_name` to ensure
   real‑world counts respect caps.
5. **Alerts:** warn at ≥70% of `max_connections`, on high `DBLoadNonCPU` with near‑zero IOPS
   (lock storm), and on p95 latency.

---

## 6) Reference Config Snippets

### Web (Gunicorn example)

```bash
gunicorn app:app \
  --worker-class gthread \
  --workers 3 \
  --threads 4 \
  --timeout 60 \
  --graceful-timeout 60 \
  --keep-alive 5
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

### SQLAlchemy (RQ worker/scheduler)

```python
from sqlalchemy.pool import QueuePool
SQLALCHEMY_ENGINE_OPTIONS = {
    "poolclass": QueuePool,
    "pool_size": 1,
    "max_overflow": 0,
    "pool_timeout": 12,
    "pool_recycle": 1800,
    "pool_pre_ping": True,
}
```

### Health check pattern (preStop flag)

```python
@app.get("/health")
def health():
    return ("terminating" if os.path.exists("/tmp/terminating") else "ok"), 503 if os.path.exists("/tmp/terminating") else 200
```

### Kubernetes (web)

```yaml
lifecycle:
  preStop:
    exec:
      command: ["/bin/sh","-c","touch /tmp/terminating; sleep 15"]
terminationGracePeriodSeconds: 90
```

---

## 7) Key Takeaways

- **Order**: DB < pool < web < K8s < edge.
- **Cap**: keep worst‑case connections well under the DB’s hard cap.
- **Fail fast** on DDL and lock waits.
- **Verify** periodically with drills and dashboards.
