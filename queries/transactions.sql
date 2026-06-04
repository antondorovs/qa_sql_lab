-- Transaction examples for QA SQL Lab
-- Run these examples manually in a PostgreSQL client.

-- Example 1: inspect a test change and roll it back
BEGIN;

UPDATE orders
SET status = 'PAID'
WHERE id = 5;

SELECT id, order_number, status
FROM orders
WHERE id = 5;

ROLLBACK;

-- Example 2: create temporary QA setup data and roll it back
BEGIN;

INSERT INTO users (
    id,
    first_name,
    last_name,
    email,
    status,
    country,
    age,
    created_at,
    deleted_at
) VALUES (
    100,
    'Test',
    'User',
    'test.user@example.com',
    'ACTIVE',
    'USA',
    30,
    CURRENT_TIMESTAMP,
    NULL
);

SELECT id, email
FROM users
WHERE id = 100;

ROLLBACK;

-- Example 3: use SAVEPOINT while investigating multi-step data setup
BEGIN;

UPDATE payments
SET status = 'SUCCESS',
    paid_at = CURRENT_TIMESTAMP
WHERE id = 8;

SAVEPOINT payment_fixed;

UPDATE orders
SET status = 'PAID'
WHERE id = 8;

SELECT
    o.id,
    o.status AS order_status,
    p.status AS payment_status
FROM orders o
INNER JOIN payments p
    ON o.id = p.order_id
WHERE o.id = 8;

ROLLBACK TO SAVEPOINT payment_fixed;
ROLLBACK;
