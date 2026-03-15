# Interview Questions With Green-Flag / Red-Flag Guidance

## Python / Code Quality

### 1. Code Structure

**Question:** How do you structure Python code in larger systems to keep it maintainable? What
patterns or practices do you rely on?

**Green flags:**

- Mentions modularization, packages, clear boundaries.
- Talks about dependency injection, separation of concerns, or layering.
- References linting, type checking, testing, or consistent style.

**Red flags:**

- "I just put functions in a file."
- No concept of architecture or scaling codebases.

### 2. Mutability Pitfalls

**Question:** What are some pitfalls around mutability in Python, and how do you avoid them?

**Green flags:**

- Understands list/dict as mutable defaults issue.
- Talks about side effects, copying, defensive cloning.

**Red flags:**

- Doesn't know the mutable default argument bug.
- Confuses immutability with pass-by-value.

### 3. Monkey Patching

**Question:** When is monkey patching appropriate, and when is it dangerous?

**Green flags:**

- Only for tests, mocks, or temporary patches.
- Calls out readability/maintainability risks.

**Red flags:**

- Suggests using it in production logic.
- No awareness of risk or debugging difficulty.

## Architecture / Design

### 4. Race Conditions

**Question:** In the checkout/reservation system you just designed, where can race conditions occur,
and how would you prevent them?

**Green flags:**

- Mentions concurrent checkout, reservation fulfillment.
- Proposes locks, transactions, optimistic/pessimistic concurrency.

**Red flags:**

- "Race conditions aren't an issue in Python."
- Ignores multi-instance or DB-level concurrency.

### 5. External API Integration

**Question:** When integrating with external APIs, how do you design for latency, rate limits, and
partial failures? Can you give a specific example from your experience?

**Green flags:**

- Talks about retries, timeouts, idempotency, circuit breakers.
- Mentions handling rate limits and backoff.

**Red flags:**

- "Just call the API and hope it works."
- No mention of error handling or resiliency.

### 6. Scaling

**Question:** What does scaling actually mean to you? Give an example of how you've scaled a real
system.

**Green flags:**

- Differentiates vertical vs horizontal scaling.
- Talks about metrics, bottlenecks, caching, partitioning.

**Red flags:**

- "Just add more servers."
- No discussion of bottlenecks or data consistency.

## Distributed Systems

### 7. Testing Distributed Systems

**Question:** How do you test a distributed system—beyond unit tests?

**Green flags:**

- Mentions chaos testing, integration tests, failure injection.
- Talks about observability and traceability.

**Red flags:**

- "Unit tests are enough."
- Doesn't recognize nondeterminism issues.

### 8. Partial Failure Recovery

**Question:** Walk me through how you detect and recover from partial failures (e.g., one component
slow or unhealthy).

**Green flags:**

- Timeouts, retries, bulkheads, circuit breakers.
- Differentiates slow vs failed components.

**Red flags:**

- Treats partial failures as binary.
- No idea how to isolate faults.

## Software Architecture

### 9. Microservices vs Monolith

**Question:** What are the real tradeoffs between microservices and a monolith? When would you
choose one over the other?

**Green flags:**

- Understands operational overhead, ownership, scaling characteristics.
- Explains when monoliths are superior.

**Red flags:**

- "Microservices are always better."
- No understanding of boundaries or cost.

### 10. Over-Decomposition

**Question:** When is a microservice "too micro"? What does it look like in practice?

**Green flags:**

- When changes require coordination across many services.
- When service boundaries don't match domain boundaries.

**Red flags:**

- Doesn't understand domain modeling.
- Suggests splitting for its own sake.

## Judgment / Engineering Philosophy

### 11. Build vs Buy

**Question:** When does reinventing the wheel make sense? When is it a trap?

**Green flags:**

- Rebuild when libraries don't meet constraints, security concerns, or performance requirements.
- Avoid reinvention when stable, well-tested solutions already exist.

**Red flags:**

- "Always build it yourself."
- "Always use libraries." (no nuance)
