-- Window function examples for QA SQL Lab

-- Number orders per user by creation date
SELECT
    user_id,
    order_number,
    created_at,
    ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY created_at
    ) AS order_sequence
FROM orders
ORDER BY user_id, order_sequence;

-- Rank orders by amount within each status
SELECT
    status,
    order_number,
    amount,
    RANK() OVER (
        PARTITION BY status
        ORDER BY amount DESC
    ) AS amount_rank
FROM orders
ORDER BY status, amount_rank;

-- Compare each order amount with the user average
SELECT
    user_id,
    order_number,
    amount,
    AVG(amount) OVER (
        PARTITION BY user_id
    ) AS user_average_amount
FROM orders
ORDER BY user_id, order_number;

-- Running total of order amounts by date
SELECT
    order_number,
    created_at,
    amount,
    SUM(amount) OVER (
        ORDER BY created_at
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders
ORDER BY created_at;

-- Show the previous payment status for each order
SELECT
    order_id,
    id AS payment_id,
    status,
    paid_at,
    LAG(status) OVER (
        PARTITION BY order_id
        ORDER BY id
    ) AS previous_payment_status
FROM payments
ORDER BY order_id, payment_id;
