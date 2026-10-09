```sql
-- ============================================================
-- Purpose: Analyse portfolio performance and observed risk:
-- how many borrowers defaulted
-- which loan grades have higher default rates
-- which loan purposes carry more risk
-- how risk differs by home ownership and prior default history
-- ============================================================


-- 1. Overall portfolio summary
SELECT
    COUNT(*) AS total_borrowers,
    SUM(loan_status) AS total_defaults,
    COUNT(*) - SUM(loan_status) AS total_non_defaults,
    ROUND(
        (100.0 * SUM(loan_status) / COUNT(*))::numeric,
        2
    ) AS default_rate_pct,
    ROUND(AVG(loan_amnt)::numeric, 2) AS avg_loan_amount,
    ROUND(AVG(person_income)::numeric, 2) AS avg_income,
    ROUND(AVG(loan_to_income_ratio)::numeric, 4) AS avg_lti,
    ROUND(AVG(debt_to_income_ratio)::numeric, 4) AS avg_dti
FROM loan_applications;

-- 2. Default rate, loan amount and interest rate by loan grade
SELECT
    loan_grade,
    COUNT(*) AS borrowers,
    SUM(loan_status) AS defaults,
    ROUND(
        (100.0 * SUM(loan_status) / COUNT(*))::numeric,
        2
    ) AS default_rate_pct,
    ROUND(AVG(loan_amnt)::numeric, 2) AS avg_loan_amount,
    ROUND(AVG(loan_int_rate)::numeric, 2) AS avg_interest_rate
FROM loan_applications
GROUP BY loan_grade
ORDER BY loan_grade;

-- 3. Risk by loan purpose
SELECT
    loan_intent,
    COUNT(*) AS borrowers,
    SUM(loan_status) AS defaults,
    ROUND(
        (100.0 * SUM(loan_status) / COUNT(*))::numeric,
        2
    ) AS default_rate_pct,
    ROUND(AVG(loan_amnt)::numeric, 2) AS avg_loan_amount,
    ROUND(AVG(loan_to_income_ratio)::numeric, 4) AS avg_lti
FROM loan_applications
GROUP BY loan_intent
ORDER BY default_rate_pct DESC;

-- 4. Risk by home ownership
SELECT
    person_home_ownership,
    COUNT(*) AS borrowers,
    SUM(loan_status) AS defaults,
    ROUND(
        (100.0 * SUM(loan_status) / COUNT(*))::numeric,
        2
    ) AS default_rate_pct,
    ROUND(AVG(loan_to_income_ratio)::numeric, 4) AS avg_lti,
    ROUND(AVG(debt_to_income_ratio)::numeric, 4) AS avg_dti
FROM loan_applications
GROUP BY person_home_ownership
ORDER BY default_rate_pct DESC;

-- 5. Risk by previous default history
-- Y = previous default on file
-- N = no previous default on file
SELECT
    cb_person_default_on_file,
    COUNT(*) AS borrowers,
    SUM(loan_status) AS defaults,
    ROUND(
        (100.0 * SUM(loan_status) / COUNT(*))::numeric,
        2
    ) AS default_rate_pct
FROM loan_applications
GROUP BY cb_person_default_on_file
ORDER BY default_rate_pct DESC;
```
