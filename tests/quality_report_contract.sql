-- Data quality baseline contract tests

DO $$
DECLARE
    actual_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report;

    IF actual_count <> 10 THEN
        RAISE EXCEPTION 'Expected 10 data quality rules, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE baseline_status <> 'MATCH';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected every data quality rule to match its baseline, found % deviations',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE severity = 'CRITICAL';

    IF actual_count <> 5 THEN
        RAISE EXCEPTION 'Expected 5 critical data quality rules, found %', actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'successful_payment_without_timestamp';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no successful payments without timestamps, found %',
            actual_count;
    END IF;
END
$$;
