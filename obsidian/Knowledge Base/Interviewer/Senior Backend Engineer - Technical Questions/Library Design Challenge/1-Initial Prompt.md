# Initial Prompt

You’re designing a simple in-memory API for a library system.

The library needs to: • Store books • Let users borrow and return books • Track which user currently
has which book

Each book has: id, title, author, isbn Assume the library can has multiple physical copies the same
ISBN

Focus on clean data structures and function signatures, not implementation details..

## Expectations

For a strong answer, the candidate should:

1. **Model the domain sensibly**

   - Represent a book title with id/title/author/isbn.
   - Acknowledge or model **multiple copies per ISBN** (e.g., a separate Copy/BookCopy with its own
     ID/barcode).

2. **Choose reasonable data structures**

   - Use maps/dicts for fast lookup:
     - e.g. by ISBN (for titles / groups of copies)
     - and/or by copy ID (for a specific physical book)
   - Avoid “everything in a list and just loop it” unless justified.

3. **Design a minimal, coherent API**

   - Function signatures for at least:
     - adding a book / copy
     - borrowing/checking out
     - returning/checking in
     - getting a book/copy’s status
     - listing books/copies a user has
   - Clear parameter choices (e.g. use IDs, not raw objects, for operations).

4. **Respect basic invariants**

   - A given **copy** can be checked out to **at most one user at a time**.
   - Returning a book updates state consistently (no ghost loans).

5. **Explain their thinking briefly**
   - Can articulate _why_ they chose their data structures and how the flow “add → borrow → return →
     query status” works end-to-end.

## Scoring Scale

### **5 — Excellent**

Clean, well-structured design.

Models titles vs copies clearly, uses appropriate data structures (maps/dicts), provides sensible
API signatures, and maintains correct borrowing invariants. Reasoning is clear and adaptable.

### **4 — Good**

Solid design with minor gaps.

Handles multiple copies correctly and provides a usable API. A few rough edges or small mistakes,
but overall coherent and correct.

### **3 — Adequate**

Meets the minimum requirements.

Basic API and data structures work, but modeling is shallow or slightly inconsistent. Some
invariants may be missing or weak. Reasoning is understandable but not sharp.

### **2 — Weak**

Partially solves the problem but with significant issues.

Data model is muddled (e.g., unclear handling of multiple copies), poor structure choices, or broken
checkout/return logic. Reasoning is incomplete.

### **1 — Insufficient**

Does not meet the fundamental requirements.

No meaningful handling of multiple copies, unclear or nonfunctional API, or incorrect tracking of
users and loans. Reasoning is confused or absent.
