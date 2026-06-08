-- Dataset contract tests

DO $$
DECLARE
    actual_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO actual_count FROM users;
    IF actual_count <> 8 THEN
        RAISE EXCEPTION 'Expected 8 users, found %', actual_count;
    END IF;

    SELECT COUNT(*) INTO actual_count FROM addresses;
    IF actual_count <> 6 THEN
        RAISE EXCEPTION 'Expected 6 addresses, found %', actual_count;
    END IF;

    SELECT COUNT(*) INTO actual_count FROM orders;
    IF actual_count <> 8 THEN
        RAISE EXCEPTION 'Expected 8 orders, found %', actual_count;
    END IF;

    SELECT COUNT(*) INTO actual_count FROM payments;
    IF actual_count <> 8 THEN
        RAISE EXCEPTION 'Expected 8 payments, found %', actual_count;
    END IF;
END
$$;

DO $$
DECLARE
    actual_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM (
        SELECT email
        FROM users
        GROUP BY email
        HAVING COUNT(*) > 1
    ) duplicate_emails;

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'Expected 1 duplicate email group, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM orders o
    LEFT JOIN users u
        ON o.user_id = u.id
    WHERE u.id IS NULL;

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'Expected 1 orphan order, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM payments p
    LEFT JOIN orders o
        ON p.order_id = o.id
    WHERE o.id IS NULL;

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'Expected 1 orphan payment, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM addresses a
    LEFT JOIN users u
        ON a.user_id = u.id
    WHERE u.id IS NULL;

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'Expected 1 orphan address, found %', actual_count;
    END IF;

    SELECT COUNT(*) INTO actual_count
    FROM orders
    WHERE amount < 0;

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'Expected 1 negative order amount, found %', actual_count;
    END IF;

    SELECT COUNT(*) INTO actual_count
    FROM users
    WHERE age IS NULL;

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'Expected 1 user without age, found %', actual_count;
    END IF;
END
$$;
