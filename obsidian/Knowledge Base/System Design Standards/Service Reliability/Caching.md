# Caching & State Management in Cloud-Native Web Services

## Executive Summary

Caching is one of the strongest levers for performance, reliability, and cost efficiency. It reduces
latency, absorbs traffic spikes, and shields databases from overload.

In modern services on Kubernetes with PostgreSQL-class databases, caching acts both as a shield and
a scalpel. It protects backends from bursts and lets you carve down the hot path to sub-millisecond
reads where appropriate.

Poorly designed caching can cause correctness issues, inconsistency, and cascading failures. This
paper explains fundamentals, architectural trade-offs, and best practices. It then offers concrete
implementation guidance for Flask/FastAPI/Django behind Gunicorn/UVicorn, Kubernetes
Ingress/Service/Deployments, AWS ALB or NGINX Ingress, and PostgreSQL or Aurora PostgreSQL.

---

## Background

Cloud-native systems face high concurrency and variable traffic. They must deliver low latency under
changing load.

PostgreSQL provides strong guarantees, but it is bound by I/O and concurrency limits. Caching
addresses this by absorbing read-heavy work, smoothing spikes, and isolating backends from
unpredictable client behavior.

Relevant cache types in this ecosystem include:

- **In-memory caches (per pod):** Fast, localized, and ephemeral. Good for very hot data. Not shared
  across replicas.
- **Distributed caches (Redis, Memcached):** Shared across pods, resilient to restarts, with
  eviction policies and rich data structures.
- **CDN/Edge caches (CloudFront, Fastly):** Cache static assets and cacheable API responses close to
  clients to reduce latency and egress.

---

## Architectural Principles and Trade-offs

### Principle 1: Cache Where It Counts

- **Client-side caches** reduce network hops but can increase staleness risk.
- **Pod-local caches** (for example, `functools.lru_cache` or `aiocache`) provide microsecond reads.
  Horizontal scaling weakens their consistency.
- **Distributed caches** (for example, Redis on ElastiCache) trade a small amount of latency for
  shared correctness across pods.

### Principle 2: Embrace Cache Invalidation

- **Write-through:** Update cache and database synchronously. Lower staleness. Higher latency.
- **Write-behind:** Write cache, then the database asynchronously. Faster. Risk of data loss.
- **Cache-aside:** Load into cache on miss. Simple and common for web services.

### Principle 3: Protect the Backend

- Use TTLs to bound staleness.
- Apply request coalescing so many concurrent misses collapse into one backend fetch.
- Use circuit breakers to shed load when cache or datastore health degrades.

### Principle 4: Manage Eviction and Capacity

- Choose Redis eviction policies to match workload (LRU, LFU, or TTL-first).
- Track hit ratio, eviction rate, latency, and memory fragmentation to guide tuning.

### Trade-offs

- **Consistency vs. Performance:** Freshness needs frequent invalidation. Performance prefers longer
  TTLs.
- **Local vs. Distributed:** Local caches are faster. Distributed caches offer cross-pod
  correctness.
- **Cost vs. Reliability:** Larger caches cut DB load. They also add infra cost and complexity.

---

## Design Patterns

### Pattern 1: Multi-layer Caching

- **Edge (CDN or ALB or NGINX):** Cache GET responses driven by `Cache-Control`.
- **Service layer (Redis):** Cache query results, serialized JSON, or lightweight DTOs.
- **Pod-local:** Memoize expensive calls, such as small lookup tables and compiled regexes.

Conceptual diagram:

```text
Client → ALB/NGINX (edge cache) → Service (local LRU cache + Redis) → PostgreSQL
```

### Pattern 2: Request Coalescing

Prevent stampedes on cache miss by synchronizing concurrent requests.

```python
import asyncio

locks = {}

async def get_or_set(key, fetch_func, ttl=60):
    if key not in locks:
        locks[key] = asyncio.Lock()
    async with locks[key]:
        val = await redis.get(key)
        if val is not None:
            return val
        val = await fetch_func()
        await redis.set(key, val, ex=ttl)
        return val
```

### Pattern 3: Hot Key Mitigation

- Shard or randomize key space: `user:123:profile:v1:<rand-suffix>`.
- Use ingress or ALB rate limits to smooth spikes on the same key.

### Pattern 4: TTL Tiering

- Assign TTLs by data class. Examples:
  - Config data: hours.
  - User profiles: minutes.
  - Ephemeral counters: seconds.

---

## Anti-Patterns

1. **Cache stampede:** Many clients hammer the DB after TTL expiry. Mitigate with coalescing and
   jittered TTLs.
2. **Unbounded local caches:** Per-pod dicts without eviction cause memory bloat and OOM kills.
3. **Blind writes:** Overwriting cache without a clear invalidation plan leads to stale data.
4. **Over-caching:** Caching every query without studying hit ratios wastes memory and time.
5. **Ignoring observability:** Lack of hit/miss, latency, and eviction metrics hides problems.

---

## Implementation Guidance

### Gunicorn and UVicorn

- Prefer async frameworks (FastAPI, async Django) with an async Redis client.
- Avoid oversubscribing Redis or DB connections through aggressive worker counts.

**Gunicorn config example:**

```bash
gunicorn app:app   --worker-class uvicorn.workers.UvicornWorker   --workers 4   --timeout 60   --keep-alive 5
```

### Kubernetes (Ingress, Service, Deployments)

- Enable basic response caching at the ingress if appropriate.

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_cache my_cache;
      proxy_cache_valid 200 302 60s;
      proxy_cache_valid 404 1s;
```

- Consider a sidecar cache such as Varnish or `proxy_cache` for the hottest paths.
- Ensure readiness and liveness probes fail fast if cache dependencies are unhealthy.

### AWS ALB and NGINX

- ALBs do not cache dynamic content. Use CloudFront for edge caching.
- Recommended header for cache control:

```http
Cache-Control: public, max-age=60, stale-while-revalidate=30
```

### Redis (Distributed Cache)

- **Async client with pool sizing:**

```python
import aioredis

redis = await aioredis.from_url(
    "redis://redis:6379",
    max_connections=100,
    decode_responses=True
)
```

- **Eviction policy:**

```bash
maxmemory 2gb
maxmemory-policy allkeys-lru
```

- **Monitoring:** Track `evicted_keys`, `keyspace_hits`, `keyspace_misses`, and latency percentiles.
- **Topology:** Use Redis Cluster or ElastiCache for sharding and failover.

### PostgreSQL and Aurora

- Do not cache highly volatile queries or tiny result sets.
- Use PgBouncer or RDS Proxy with Redis to reduce repetitive queries and smooth traffic.
- Combine materialized views with cache where appropriate.

```sql
CREATE MATERIALIZED VIEW recent_orders AS
SELECT *
FROM orders
WHERE created_at > now() - interval '7 days';

REFRESH MATERIALIZED VIEW recent_orders;
```

---

## Recommendations

- Start simple: cache-aside with Redis and TTL based invalidation.
- Layer caches: edge, distributed, and pod-local.
- Implement request coalescing to avoid DB overload on misses.
- Monitor hit ratio, latency, eviction rates, and errors as first-class metrics.
- Test failure modes: Redis down, cold cache, or DB under load.
- Tune TTLs and eviction policies by data volatility and access frequency.
- Use chaos and replay tests to validate correctness under failure.

---

## Conclusion

Caching balances performance, consistency, and reliability. With PostgreSQL as the source of truth
and Kubernetes or AWS as the substrate, caches form a critical protective layer.

By layering caches, coalescing requests, and instrumenting aggressively, teams can deliver fast and
resilient systems. The most dangerous cache is the one you cannot see. Make instrumentation and
failure testing as important as code and configuration.
