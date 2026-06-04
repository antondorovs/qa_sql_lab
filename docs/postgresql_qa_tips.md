# PostgreSQL Tips for QA Engineers

PostgreSQL has practical features that make database validation easier during QA work.

## Useful operators and functions

- `::date` converts a timestamp to a date for day-level checks.
- `COALESCE(value, fallback)` replaces `NULL` with a fallback value.
- `CURRENT_DATE` and `CURRENT_TIMESTAMP` help validate records created during a test run.
- `ILIKE` performs case-insensitive pattern matching.
- `COUNT(*) FILTER (WHERE condition)` counts only rows that match a condition.

## Transaction safety

Use transactions when testing data changes manually:

```sql
BEGIN;
UPDATE orders SET status = 'PAID' WHERE id = 5;
SELECT * FROM orders WHERE id = 5;
ROLLBACK;
```

This lets you inspect the result without permanently changing shared test data.

## Assertion-style validation

A useful QA query often returns only failed rows. If the result is empty, the check passes.

Example:

```sql
SELECT id, order_number, amount
FROM orders
WHERE amount <= 0;
```
