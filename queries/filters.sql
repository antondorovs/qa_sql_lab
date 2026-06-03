-- Filtering and sorting examples for QA SQL Lab

-- All users
SELECT *
FROM users;

-- Active users
SELECT id, first_name, last_name, email, status
FROM users
WHERE status = 'ACTIVE';

-- Users created in 2026
SELECT id, email, created_at
FROM users
WHERE created_at >= '2026-01-01'
  AND created_at < '2027-01-01';

-- Users from selected countries
SELECT id, email, country
FROM users
WHERE country IN ('USA', 'Canada', 'Germany');

-- Adult users only
SELECT id, email, age
FROM users
WHERE age BETWEEN 18 AND 60;

-- Example email pattern search
SELECT id, email
FROM users
WHERE email LIKE '%@example.com';

-- Users that are not soft deleted
SELECT id, email, deleted_at
FROM users
WHERE deleted_at IS NULL;

-- Latest orders first
SELECT id, order_number, status, amount, created_at
FROM orders
ORDER BY created_at DESC;

-- Payments that still need investigation
SELECT id, order_id, status, amount, paid_at
FROM payments
WHERE status IN ('PENDING', 'FAILED')
ORDER BY id;
