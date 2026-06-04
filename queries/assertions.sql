-- QA assertion-style queries
-- Each query should return zero rows when the data passes the check.

-- Assertion: user emails should be unique
SELECT email, COUNT(*) AS duplicate_count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Assertion: active users should not be soft deleted
SELECT id, email, status, deleted_at
FROM users
WHERE status = 'ACTIVE'
  AND deleted_at IS NOT NULL;

-- Assertion: orders should reference existing users
SELECT o.id, o.order_number, o.user_id
FROM orders o
LEFT JOIN users u
    ON o.user_id = u.id
WHERE u.id IS NULL;

-- Assertion: payments should reference existing orders
SELECT p.id, p.order_id
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.id
WHERE o.id IS NULL;

-- Assertion: order amounts should be positive
SELECT id, order_number, amount
FROM orders
WHERE amount <= 0;

-- Assertion: successful payments should have paid_at
SELECT id, order_id, status, paid_at
FROM payments
WHERE status = 'SUCCESS'
  AND paid_at IS NULL;

-- Assertion: failed payments should not have paid_at
SELECT id, order_id, status, paid_at
FROM payments
WHERE status = 'FAILED'
  AND paid_at IS NOT NULL;

-- Assertion: successful payment amount should match order amount
SELECT
    o.id AS order_id,
    o.order_number,
    o.amount AS order_amount,
    p.amount AS payment_amount
FROM orders o
INNER JOIN payments p
    ON o.id = p.order_id
WHERE p.status = 'SUCCESS'
  AND o.amount <> p.amount;

-- Assertion: every active user should have a primary address
SELECT u.id, u.email
FROM users u
LEFT JOIN addresses a
    ON u.id = a.user_id
   AND a.is_primary = TRUE
WHERE u.status = 'ACTIVE'
  AND a.id IS NULL;
