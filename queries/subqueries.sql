-- Subquery examples for QA SQL Lab

-- Users who have at least one order
SELECT id, email
FROM users
WHERE id IN (
    SELECT user_id
    FROM orders
    WHERE user_id IS NOT NULL
)
ORDER BY id;

-- Users without any orders
SELECT id, email
FROM users u
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.user_id = u.id
)
ORDER BY id;

-- Orders above the average order amount
SELECT id, order_number, amount
FROM orders
WHERE amount > (
    SELECT AVG(amount)
    FROM orders
)
ORDER BY amount DESC;

-- Users whose total order amount is greater than 100
SELECT id, email
FROM users u
WHERE 100 < (
    SELECT COALESCE(SUM(o.amount), 0)
    FROM orders o
    WHERE o.user_id = u.id
)
ORDER BY id;

-- Orders where payment amount does not match order amount
SELECT id, order_number, amount
FROM orders o
WHERE EXISTS (
    SELECT 1
    FROM payments p
    WHERE p.order_id = o.id
      AND p.amount <> o.amount
)
ORDER BY id;

-- Countries with more users than the average users per country
SELECT country, COUNT(*) AS user_count
FROM users
GROUP BY country
HAVING COUNT(*) > (
    SELECT AVG(country_user_count)
    FROM (
        SELECT COUNT(*) AS country_user_count
        FROM users
        GROUP BY country
    ) country_counts
)
ORDER BY user_count DESC;
