# Follow Up Prompt

Extend your design to support reservations for physical books.

New requirements:
  • If all copies of an ISBN are checked out, users may place a reservation on that ISBN.
  • Reservations form a First In First Out (FIFO) queue.
  • When any copy of that ISBN is returned, it should be automatically assigned to the next user in the queue.

Your task:

  1. Update your data structures to support reservations (e.g., queues per ISBN).
  2. Add the API methods needed to:
       - Place a reservation
       - View a user’s reservations
       - Handle the “copy returned → reservation fulfillment” flow

## Expectations

For a strong answer to this follow-up, the candidate should:

1. **Extend the data model cleanly**
    - Introduce a reasonable way to store reservations, typically:
        - A **queue per ISBN** (e.g., reservations_by_isbn[isbn] = queue/list of user_ids), or equivalent.
    - Keep the existing book/copy model intact rather than hacking reservations into random fields.

2. **Add clear API methods**
    At minimum, something like:
    - reserve(isbn, user_id) or similar to place a reservation.
    - get_user_reservations(user_id) to view a user’s reservations.
    - A clear place where the “copy returned → next user in queue gets it” logic happens
        (usually inside checkin or a dedicated helper used by it).

3. **Respect core reservation invariants**
    - Reservations are **FIFO** (first come, first served).
    - A user cannot reserve the **same ISBN multiple times**.
    - Returned copies go to the **queue first**, not to general availability.

4. **Explain the flow**
    - Can verbally walk through:
        - “All copies are checked out → user reserves → another user returns a copy → reservation is fulfilled and state updates.”

## Scoring Scale

### **5 — Excellent**

Reservations are modeled cleanly (e.g., per-ISBN queues), API methods are clear and minimal, FIFO behavior is enforced, duplicate reservations are prevented, and the return → fulfillment flow is well thought out. Candidate can explain the flow and mention potential race conditions or edge cases.

### **4 — Good**

Design supports reservations in a mostly correct way. Per-ISBN queues and new methods are present. FIFO is intended and mostly clear; return logic hooks into the queue. Some minor gaps (e.g., not fully handling duplicates or edge cases) but overall sound.

### **3 — Adequate**

Reservations exist but are somewhat ad hoc. Maybe uses lists without clearly enforcing FIFO, or the return → fulfillment flow is hand-wavy. The idea is there, but important details are missing or fuzzy.

### **2 — Weak**

Partial or broken solution. Reservations are stored in a way that doesn’t cleanly map to ISBNs or FIFO, or they don’t integrate with the checkout/return flow in a meaningful way. Easy to violate fairness or leave copies idle while reservations exist.

### **1 — Insufficient**

Doesn’t really solve the reservation requirement. No clear data structure for reservations, no coherent queue behavior, or no integration with return/checkin at all. The system cannot reliably ensure that reserved users get copies in order.
