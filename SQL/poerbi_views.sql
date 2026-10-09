```sql
-- ============================================================
-- Purpose: create someanalytical views for Power BI
-- ============================================================

-- 1. Borrower-level risk analysis view
CREATE OR REPLACE VIEW vw_borrower_risk_base AS
SELECT
    client_ID,
    person_age,
    person_income,
    person_home_ownership,
    person_emp_length,
    employment_type,
    gender,
    marital_status,
    education_level,
    cb_person_cred_hist_length,
    cb_person_default_on_file,
    credit_utilization_ratio,
    past_delinquencies,
    open_accounts,
    loan_intent,
    loan_grade,
    loan_amnt,
    loan_int_rate,
    loan_percent_income,
    loan_to_income_ratio,
    other_debt,
    debt_to_income_ratio,
    loan_term_months,
    country,
    state,
    city,
    loan_status
FROM loan_applications;

-- 2. Portfolio-level summary view
CREATE OR REPLACE VIEW vw_portfolio_summary AS
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

-- 3. Lending risk segments view
-- 80th percentiles
CREATE OR REPLACE VIEW vw_lending_risk_segments AS
WITH thresholds AS (
    SELECT
        percentile_cont(0.80)
            WITHIN GROUP (ORDER BY loan_to_income_ratio) AS lti_80,
        percentile_cont(0.80)
            WITHIN GROUP (ORDER BY debt_to_income_ratio) AS dti_80
    FROM loan_applications
)
SELECT
    l.client_ID,
    l.loan_status,
    l.loan_grade,
    l.loan_intent,
    l.person_home_ownership,
    l.employment_type,
    l.cb_person_default_on_file,
    l.country,
    l.state,
    l.city,
    l.loan_amnt,
    l.person_income,
    l.loan_to_income_ratio,
    l.debt_to_income_ratio,
    l.loan_percent_income,

    CASE
        WHEN l.loan_to_income_ratio >= t.lti_80
         AND l.debt_to_income_ratio >= t.dti_80
            THEN 'High LTI + High DTI'
        WHEN l.loan_to_income_ratio >= t.lti_80
            THEN 'High LTI Only'
        WHEN l.debt_to_income_ratio >= t.dti_80
            THEN 'High DTI Only'
        ELSE 'Neither High'
    END AS affordability_segment,

    CASE
        WHEN l.loan_grade IN ('F', 'G')
            THEN 'Very High Risk'
        WHEN l.loan_grade IN ('D', 'E')
            THEN 'High Risk'
        WHEN l.loan_grade = 'C'
            THEN 'Moderate Risk'
        ELSE 'Lower Risk'
    END AS grade_risk_segment

FROM loan_applications AS l
CROSS JOIN thresholds AS t;

-- 4. Risk-driver analysis view
-- 5 ranked groups
CREATE OR REPLACE VIEW vw_risk_driver_analysis AS
WITH ranked AS (
    SELECT
        l.*,
        NTILE(5) OVER (
            ORDER BY loan_to_income_ratio
        ) AS lti_quintile,
        NTILE(5) OVER (
            ORDER BY debt_to_income_ratio
        ) AS dti_quintile
    FROM loan_applications AS l
)
SELECT *
FROM ranked;

-- 5. Verify the views were created and return expected row counts
SELECT COUNT(*) AS borrower_base_rows
FROM vw_borrower_risk_base;

SELECT *
FROM vw_portfolio_summary;

SELECT COUNT(*) AS lending_risk_segment_rows
FROM vw_lending_risk_segments;

SELECT COUNT(*) AS risk_driver_rows
FROM vw_risk_driver_analysis;
```
