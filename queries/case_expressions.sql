-- CASE expression examples for QA SQL Lab

-- Classify users by age group
SELECT
    id,
    email,
    age,
    CASE
        WHEN age IS NULL THEN 'UNKNOWN'
        WHEN age < 18 THEN 'UNDER_18'
        WHEN age BETWEEN 18 AND 64 THEN 'ADULT'
        ELSE 'SENIOR'
    END AS age_group
FROM users
ORDER BY id;

-- Classify orders by risk level
SELECT
    id,
    order_number,
    status,
    amount,
    CASE
        WHEN amount < 0 THEN 'INVALID_AMOUNT'
        WHEN status = 'PAID' AND amount >= 200 THEN 'HIGH_VALUE_PAID'
        WHEN status = 'NEW' THEN 'AWAITING_PROCESSING'
        WHEN status = 'CANCELLED' THEN 'CANCELLED_ORDER'
        ELSE 'STANDARD'
    END AS qa_risk_level
FROM orders
ORDER BY id;

-- Normalize payment status into QA buckets
SELECT
    id,
    order_id,
    status,
    CASE status
        WHEN 'SUCCESS' THEN 'COMPLETED'
        WHEN 'REFUNDED' THEN 'COMPLETED'
        WHEN 'PENDING' THEN 'IN_PROGRESS'
        WHEN 'FAILED' THEN 'FAILED'
        ELSE 'UNKNOWN'
    END AS qa_status_bucket
FROM payments
ORDER BY id;

-- Count orders by QA risk level
SELECT
    CASE
        WHEN amount < 0 THEN 'INVALID_AMOUNT'
        WHEN status = 'PAID' AND amount >= 200 THEN 'HIGH_VALUE_PAID'
        WHEN status = 'NEW' THEN 'AWAITING_PROCESSING'
        WHEN status = 'CANCELLED' THEN 'CANCELLED_ORDER'
        ELSE 'STANDARD'
    END AS qa_risk_level,
    COUNT(*) AS order_count
FROM orders
GROUP BY qa_risk_level
ORDER BY qa_risk_level;
