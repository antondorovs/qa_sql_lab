-- Reusable PostgreSQL views for QA SQL Lab

CREATE OR REPLACE VIEW active_user_order_summary AS
SELECT
    u.id AS user_id,
    u.email,
    u.country,
    COUNT(o.id) AS order_count,
    COALESCE(SUM(o.amount), 0.00) AS total_order_amount,
    MAX(o.created_at) AS latest_order_at
FROM users u
LEFT JOIN orders o
    ON u.id = o.user_id
WHERE u.status = 'ACTIVE'
  AND u.deleted_at IS NULL
GROUP BY u.id, u.email, u.country;

CREATE OR REPLACE VIEW order_payment_validation AS
SELECT
    COALESCE(o.id, p.order_id) AS order_id,
    o.order_number,
    o.user_id,
    u.email AS user_email,
    o.status AS order_status,
    o.amount AS order_amount,
    p.id AS payment_id,
    p.status AS payment_status,
    p.amount AS payment_amount,
    CASE
        WHEN o.id IS NULL THEN 'MISSING_ORDER'
        WHEN u.id IS NULL THEN 'MISSING_USER'
        WHEN p.id IS NULL THEN 'MISSING_PAYMENT'
        WHEN o.amount <> p.amount THEN 'AMOUNT_MISMATCH'
        WHEN o.status = 'PAID' AND p.status <> 'SUCCESS' THEN 'PAYMENT_NOT_SUCCESSFUL'
        WHEN o.status <> 'PAID' AND p.status = 'SUCCESS' THEN 'ORDER_NOT_MARKED_PAID'
        ELSE 'CONSISTENT'
    END AS qa_status
FROM orders o
LEFT JOIN users u
    ON o.user_id = u.id
FULL OUTER JOIN payments p
    ON o.id = p.order_id;

CREATE OR REPLACE VIEW data_quality_rule_report AS
WITH rule_results (
    rule_id,
    rule_description,
    severity,
    expected_issue_count,
    actual_issue_count
) AS (
    SELECT
        'duplicate_user_email',
        'User email addresses should be unique',
        'HIGH',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM (
                SELECT email
                FROM users
                GROUP BY email
                HAVING COUNT(*) > 1
            ) duplicate_emails
        )

    UNION ALL

    SELECT
        'orphan_address',
        'Addresses should reference existing users',
        'HIGH',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM addresses a
            LEFT JOIN users u
                ON a.user_id = u.id
            WHERE u.id IS NULL
        )

    UNION ALL

    SELECT
        'orphan_order',
        'Orders should reference existing users',
        'CRITICAL',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM orders o
            LEFT JOIN users u
                ON o.user_id = u.id
            WHERE u.id IS NULL
        )

    UNION ALL

    SELECT
        'orphan_payment',
        'Payments should reference existing orders',
        'CRITICAL',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM payments p
            LEFT JOIN orders o
                ON p.order_id = o.id
            WHERE o.id IS NULL
        )

    UNION ALL

    SELECT
        'non_positive_order_amount',
        'Order amounts should be greater than zero',
        'CRITICAL',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM orders
            WHERE amount <= 0
        )

    UNION ALL

    SELECT
        'missing_user_age',
        'User age should be available for validation',
        'LOW',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM users
            WHERE age IS NULL
        )

    UNION ALL

    SELECT
        'payment_amount_mismatch',
        'Successful payment amount should match order amount',
        'CRITICAL',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM orders o
            INNER JOIN payments p
                ON o.id = p.order_id
            WHERE p.status = 'SUCCESS'
              AND o.amount <> p.amount
        )

    UNION ALL

    SELECT
        'successful_payment_without_timestamp',
        'Successful payments should include a payment timestamp',
        'HIGH',
        0::BIGINT,
        (
            SELECT COUNT(*)
            FROM payments
            WHERE status = 'SUCCESS'
              AND paid_at IS NULL
        )

    UNION ALL

    SELECT
        'active_user_without_primary_address',
        'Active users should have a primary address',
        'MEDIUM',
        2::BIGINT,
        (
            SELECT COUNT(*)
            FROM users u
            LEFT JOIN addresses a
                ON u.id = a.user_id
               AND a.is_primary = TRUE
            WHERE u.status = 'ACTIVE'
              AND u.deleted_at IS NULL
              AND a.id IS NULL
        )

    UNION ALL

    SELECT
        'paid_order_without_successful_payment',
        'Paid orders should have a successful payment',
        'CRITICAL',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM orders o
            LEFT JOIN payments p
                ON o.id = p.order_id
               AND p.status = 'SUCCESS'
            WHERE o.status = 'PAID'
              AND p.id IS NULL
        )
)
SELECT
    rule_id,
    rule_description,
    severity,
    expected_issue_count,
    actual_issue_count,
    actual_issue_count - expected_issue_count AS issue_count_delta,
    CASE
        WHEN actual_issue_count = expected_issue_count THEN 'MATCH'
        WHEN actual_issue_count > expected_issue_count THEN 'REGRESSION'
        ELSE 'IMPROVEMENT'
    END AS baseline_status
FROM rule_results;
