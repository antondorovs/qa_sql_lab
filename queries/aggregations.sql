-- Aggregation examples for QA SQL Lab

-- Total users
SELECT COUNT(*) AS user_count
FROM users;

-- Users by status
SELECT status, COUNT(*) AS user_count
FROM users
GROUP BY status
ORDER BY user_count DESC;

-- Users by country
SELECT country, COUNT(*) AS user_count
FROM users
GROUP BY country
ORDER BY country;

-- Order totals by status
SELECT status, COUNT(*) AS order_count, SUM(amount) AS total_amount
FROM orders
GROUP BY status
ORDER BY status;

-- Average paid order amount
SELECT AVG(amount) AS average_paid_order_amount
FROM orders
WHERE status = 'PAID';

-- Latest order date
SELECT MAX(created_at) AS latest_order_created_at
FROM orders;

-- Users with more than one order
SELECT user_id, COUNT(*) AS order_count
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1;
