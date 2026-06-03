-- QA SQL Lab practice solutions

-- 1. Show all active users.
SELECT id, first_name, last_name, email
FROM users
WHERE status = 'ACTIVE';

-- 2. Show users from USA or Canada.
SELECT id, email, country
FROM users
WHERE country IN ('USA', 'Canada');

-- 3. Show orders created after 2026-03-01.
SELECT id, order_number, amount, created_at
FROM orders
WHERE created_at > '2026-03-01'
ORDER BY created_at;

-- 4. Count users by status.
SELECT status, COUNT(*) AS user_count
FROM users
GROUP BY status
ORDER BY status;

-- 5. Calculate total order amount by order status.
SELECT status, SUM(amount) AS total_amount
FROM orders
GROUP BY status
ORDER BY status;

-- 6. Show users with their primary address.
SELECT
    u.id,
    u.email,
    a.city,
    a.country
FROM users u
INNER JOIN addresses a
    ON u.id = a.user_id
WHERE a.is_primary = TRUE
ORDER BY u.id;

-- 7. Show orders with user email and payment status.
SELECT
    o.id AS order_id,
    o.order_number,
    u.email,
    p.status AS payment_status
FROM orders o
LEFT JOIN users u
    ON o.user_id = u.id
LEFT JOIN payments p
    ON o.id = p.order_id
ORDER BY o.id;

-- 8. Find duplicate user emails.
SELECT email, COUNT(*) AS duplicate_count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- 9. Find orders that reference a missing user.
SELECT o.*
FROM orders o
LEFT JOIN users u
    ON o.user_id = u.id
WHERE u.id IS NULL;

-- 10. Find payments that reference a missing order.
SELECT p.*
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.id
WHERE o.id IS NULL;

-- 11. Find orders with negative amount.
SELECT id, order_number, amount
FROM orders
WHERE amount < 0;

-- 12. Find paid orders that do not have a successful payment.
SELECT
    o.id,
    o.order_number,
    o.status AS order_status,
    p.status AS payment_status
FROM orders o
LEFT JOIN payments p
    ON o.id = p.order_id
   AND p.status = 'SUCCESS'
WHERE o.status = 'PAID'
  AND p.id IS NULL;
