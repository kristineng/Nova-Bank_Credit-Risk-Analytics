```sql
-- ============================================================
-- Purpose: validation: row count, unique client IDs, default distribution, missing values, invalid values and LTI/DTI consistency
-- ============================================================
  
-- 1. Total number of records
SELECT
    COUNT(*) AS total_rows
FROM loan_applications;

-- 2. Number of unique clients
SELECT
    COUNT(DISTINCT client_ID) AS unique_clients
FROM loan_applications;

-- 3. Check for duplicate client IDs
SELECT
    COUNT(*) - COUNT(DISTINCT client_ID) AS duplicate_ids
FROM loan_applications;

-- 4. Distribution of the target variable
-- loan_status = 0: non-default
-- loan_status = 1: default
SELECT
    loan_status,
    COUNT(*) AS borrowers,
    ROUND(
        (100.0 * COUNT(*) / SUM(COUNT(*)) OVER ())::numeric,
        2
    ) AS percentage
FROM loan_applications
GROUP BY loan_status
ORDER BY loan_status;

-- 5. Missing interest rates
SELECT
    COUNT(*) AS missing_interest_rate
FROM loan_applications
WHERE loan_int_rate IS NULL;

-- 6. Missing employment lengths
SELECT
    COUNT(*) AS missing_employment_length
FROM loan_applications
WHERE person_emp_length IS NULL;

-- 7. Check for invalid ages
SELECT
    COUNT(*) AS invalid_age
FROM loan_applications
WHERE person_age < 18
   OR person_age > 100;

-- 8. Check for non-positive income
SELECT
    COUNT(*) AS invalid_income
FROM loan_applications
WHERE person_income <= 0;

-- 9. Check for non-positive loan amounts
SELECT
    COUNT(*) AS invalid_loan_amount
FROM loan_applications
WHERE loan_amnt <= 0;

-- 10. Check credit utilization ratio bounds
SELECT
    COUNT(*) AS invalid_credit_utilization
FROM loan_applications
WHERE credit_utilization_ratio < 0
   OR credit_utilization_ratio > 1;

-- 11. Validate loan-to-income ratio
SELECT
    COUNT(*) AS lti_mismatches
FROM loan_applications
WHERE loan_to_income_ratio IS NULL
   OR ABS(
        loan_to_income_ratio
        - (loan_amnt / NULLIF(person_income, 0))
   ) > 0.0000001;

-- 12. Validate debt-to-income ratio
SELECT
    COUNT(*) AS dti_mismatches
FROM loan_applications
WHERE debt_to_income_ratio IS NULL
   OR ABS(
        debt_to_income_ratio
        - ((loan_amnt + other_debt) / NULLIF(person_income, 0))
   ) > 0.0000001;
```
