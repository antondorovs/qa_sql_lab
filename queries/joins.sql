-- JOIN examples for QA SQL Lab

-- Users with their orders
SELECT
    u.id AS user_id,
    u.email,
    o.order_number,
    o.status AS order_status,
    o.amount
FROM users u
INNER JOIN orders o
    ON u.id = o.user_id
ORDER BY u.id, o.id;

-- All users, including users without orders
SELECT
    u.id AS user_id,
    u.email,
    o.order_number
FROM users u
LEFT JOIN orders o
    ON u.id = o.user_id
ORDER BY u.id;

-- Orders with payment details
SELECT
    o.id AS order_id,
    o.order_number,
    o.amount AS order_amount,
    p.status AS payment_status,
    p.amount AS payment_amount
FROM orders o
LEFT JOIN payments p
    ON o.id = p.order_id
ORDER BY o.id;

-- Users with primary addresses
SELECT
    u.id AS user_id,
    u.email,
    a.city,
    a.country
FROM users u
INNER JOIN addresses a
    ON u.id = a.user_id
WHERE a.is_primary = TRUE
ORDER BY u.id;
