```sql
-- ============================================================
-- Purpose: analyze affordability segments and risk drivers
-- ============================================================

-- 1. Affordability segment performance
SELECT
    affordability_segment,
    COUNT(*) AS borrowers,
    SUM(loan_status) AS defaults,
    ROUND(
        (100.0 * SUM(loan_status) / COUNT(*))::numeric,
        2
    ) AS default_rate_pct
FROM vw_lending_risk_segments
GROUP BY affordability_segment
ORDER BY default_rate_pct DESC;

-- 2. Performance by loan-grade risk segment
SELECT
    grade_risk_segment,
    COUNT(*) AS borrowers,
    SUM(loan_status) AS defaults,
    ROUND(
        (100.0 * SUM(loan_status) / COUNT(*))::numeric,
        2
    ) AS default_rate_pct
FROM vw_lending_risk_segments
GROUP BY grade_risk_segment
ORDER BY default_rate_pct DESC;

-- 3. Default rate by LTI quintile
SELECT
    lti_quintile,
    COUNT(*) AS borrowers,
    SUM(loan_status) AS defaults,
    ROUND(
        (100.0 * SUM(loan_status) / COUNT(*))::numeric,
        2
    ) AS default_rate_pct
FROM vw_risk_driver_analysis
GROUP BY lti_quintile
ORDER BY lti_quintile;

-- 4. Default rate by DTI quintile
SELECT
    dti_quintile,
    COUNT(*) AS borrowers,
    SUM(loan_status) AS defaults,
    ROUND(
        (100.0 * SUM(loan_status) / COUNT(*))::numeric,
        2
    ) AS default_rate_pct
FROM vw_risk_driver_analysis
GROUP BY dti_quintile
ORDER BY dti_quintile;

-- 5. Show the calculated 80th-percentile thresholds
SELECT
    ROUND(
        percentile_cont(0.80)
            WITHIN GROUP (ORDER BY loan_to_income_ratio)::numeric,
        6
    ) AS lti_80th_percentile,
    ROUND(
        percentile_cont(0.80)
            WITHIN GROUP (ORDER BY debt_to_income_ratio)::numeric,
        6
    ) AS dti_80th_percentile
FROM loan_applications;
```
