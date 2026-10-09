# Nova Bank Credit Risk Analytics 

**Tools:** PostgreSQL · Python · pandas · scikit-learn · Power BI

## 1. Project Overview

Nova Bank is a fictional financial institution offering consumer loans for medical expenses, education, debt consolidation, home improvement, personal needs and other purposes. The bank aims to manage credit risk while maintaining responsible access to credit.

This project analyses **32,581 loan records** to examine portfolio performance, identify borrower segments associated with higher default rates, investigate affordability-related risk patterns and evaluate logistic regression models for default prediction.

Using PostgreSQL, Python and Power BI, the project transforms raw lending data into portfolio insights, risk segments, predictive model comparisons and recommendations for further credit risk assessment.

**Objective:** Support more informed, consistent and responsible lending decisions through data-driven risk analysis.

## 2. Business Questions

- Which borrower segments have higher or lower observed default rates?
- How do default rates vary by loan grade, loan purpose, homeownership and previous default history?
- How are loan-to-income (LTI) and debt-to-income (DTI) ratios associated with default?
- Can multiple affordability indicators help distinguish different risk segments?
- How well can logistic regression predict default and how does performance change when loan grade and interest rate are included?
- How can portfolio analysis and predictive modelling inform responsible lending and risk-monitoring strategies?

## 3. Tools & Technologies

| Tool | Application |
|---|---|
| PostgreSQL | Data validation, portfolio analysis, risk segmentation and analytical views |
|  | Aggregations, CTEs, window functions, percentile calculations and conditional segmentation |
| Python | Data preprocessing, feature engineering, logistic regression and model evaluation |
| pandas | Data manipulation and preparation |
| scikit-learn | Preprocessing pipelines, logistic regression and model evaluation |
| Power BI | Interactive dashboards, portfolio KPIs, risk segmentation and risk-driver analysis |

## 4. Dataset Overview

The dataset contains borrower characteristics, loan attributes, credit history, affordability indicators, geographic information and loan default outcomes.

| Category | Example Variables |
|---|---|
| Borrower profile | Age, income, employment length, education, marital status |
| Loan characteristics | Loan amount, loan purpose, loan grade, interest rate, loan term |
| Credit history | Previous default indicator, credit history length, open accounts, past delinquencies |
| Affordability | Loan-to-income ratio, debt-to-income ratio, other debt |
| Additional information | Employment type, homeownership, country, state, city |
| Target variable | `loan_status` |

**Target definition:**

- `loan_status = 1`: Default
- `loan_status = 0`: Non-default

### Initial Portfolio Profile

| Metric | Result |
|---|---:|
| Total loan records | 32,581 |
| Non-default records | 25,473 |
| Default records | 7,108 |
| Overall default rate | 21.82% |
| Average loan amount | 9,589.37 |
| Average borrower income | 66,074.85 |

The overall default rate provides a baseline against which differences between borrower segments can be assessed.

*Note: The raw dataset is not included in this repository. Add the original dataset source and applicable licence or attribution if known and permitted.*

## 5. Methodology

### 5.1 SQL Data Validation

PostgreSQL was used to assess data quality before conducting portfolio analysis.

Key tasks included:

- Verifying record counts and unique client IDs.
- Checking for duplicate client IDs.
- Examining missing values in interest rates and employment length.
- Validating age, income, loan amount and credit utilisation values.
- Checking the consistency of LTI and DTI ratios against their underlying calculations.
- Reviewing the distribution of default and non-default observations.

**Key SQL techniques:** `GROUP BY`, aggregate functions, `CASE WHEN`, CTEs, window functions, `PERCENTILE_CONT` and `NTILE`.

### 5.2 Portfolio Analysis

Default rates and loan characteristics were compared across:

- Loan grades A–G.
- Loan purposes.
- Homeownership categories.
- Previous default history.
- LTI and DTI affordability indicators.

Segment-level default rates were used to identify concentrations of observed risk that would not be apparent from the portfolio-wide average alone.

### 5.3 Risk Segmentation

Two complementary segmentation approaches were developed.

**Loan-grade risk segments**

| Segment | Grades |
|---|---|
| Lower Risk | A/B |
| Moderate Risk | C |
| High Risk | D/E |
| Very High Risk | F/G |

These labels are analytical groupings for this project, not official regulatory classifications.

**Affordability segments**

Borrowers were classified according to whether their LTI and DTI ratios exceeded the respective portfolio 80th-percentile thresholds.

| Indicator | 80th-Percentile Threshold |
|---|---:|
| LTI | 0.2500 |
| DTI | 0.4475 |

The thresholds are portfolio-specific and should not be interpreted as universal credit policy limits.

The final SQL view calculates these thresholds dynamically using `PERCENTILE_CONT`.

### 5.4 Python Credit Risk Modelling

Two logistic regression models were developed to compare default prediction performance using different feature sets.

| Model | Feature Approach |
|---|---|
| Model A | Excludes loan grade and interest rate |
| Model B | Includes loan grade and interest rate |

**Modelling workflow:**

1. Split the dataset into 80% training and 20% testing sets using stratified sampling and `random_state=42`.
2. Impute missing numerical values using the median and include missingness indicators.
3. Standardise numerical features.
4. Impute missing categorical values using the most frequent category and apply one-hot encoding.
5. Fit L2-regularised logistic regression models.
6. Evaluate performance using ROC-AUC, PR-AUC, accuracy, precision, recall and F1-score.

The test set contains 6,517 observations, including 1,422 defaults.

Model A provides a benchmark that excludes loan grade and interest rate. Model B evaluates the predictive value of including these variables, which may encode information from earlier underwriting decisions.

### 5.5 Power BI Dashboard

The Power BI report contains three analytical pages:

- **Portfolio Overview:** Portfolio KPIs and default distribution.
- **Risk Segmentation:** Default-rate comparisons across loan grades, loan purposes, homeownership categories and affordability segments.
- **Risk Drivers:** Default patterns across LTI and DTI quintiles and other risk indicators.

The dashboards allow users to explore portfolio risk patterns and compare observed outcomes across borrower segments.

## 6. Key Findings

### 6.1 Default Rates Increase Substantially Across Weaker Loan Grades

| Loan Grade | Borrowers | Default Rate |
|---|---:|---:|
| A | 10,777 | 9.96% |
| B | 10,451 | 16.28% |
| C | 6,458 | 20.73% |
| D | 3,626 | 59.05% |
| E | 964 | 64.42% |
| F | 241 | 70.54% |
| G | 64 | 98.44% |

The observed default rate rises sharply from grade A to grade G, indicating a strong association between loan grade and default outcomes in this dataset.

Grade G contains only 64 borrowers, so its 98.44% default rate should be interpreted cautiously because of the small sample size.

### 6.2 Borrowers with Both High LTI and High DTI Have a Substantially Higher Default Rate

| Affordability Segment | Borrowers | Defaults | Default Rate |
|---|---:|---:|---:|
| High LTI + High DTI | 4,686 | 2,692 | 57.45% |
| High LTI Only | 1,831 | 715 | 39.05% |
| High DTI Only | 1,831 | 318 | 17.37% |
| Neither High | 24,233 | 3,383 | 13.96% |

Borrowers with both ratios above their respective 80th-percentile thresholds had a 57.45% default rate, compared with 13.96% for borrowers below both thresholds.

This suggests that considering multiple affordability indicators together can provide a more informative view of portfolio risk than considering either ratio in isolation.

### 6.3 Default Rates Increase Across LTI and DTI Quintiles

| Quintile | LTI Default Rate | DTI Default Rate |
|---|---:|---:|
| Q1 | 10.60% | 11.46% |
| Q2 | 12.60% | 13.34% |
| Q3 | 14.67% | 15.78% |
| Q4 | 18.92% | 22.33% |
| Q5 | 52.29% | 46.18% |

Both indicators exhibit a pronounced increase in observed default rates in their highest quintiles. The pattern supports further investigation of affordability measures as part of credit risk assessment.

These are observed associations and do not establish that high LTI or DTI alone causes default.

### 6.4 Previous Default History Is Associated with Higher Observed Risk

| Previous Default on File | Borrowers | Defaults | Default Rate |
|---|---:|---:|---:|
| Yes | 5,745 | 2,172 | 37.81% |
| No | 26,836 | 4,936 | 18.39% |

Borrowers with a previous default indicator had approximately twice the observed default rate of those without one.

Previous credit difficulties may therefore provide useful information for further risk assessment, although historical difficulties should not be treated as the sole determinant of future creditworthiness.

### 6.5 Default Rates Differ Across Loan Purposes

| Loan Purpose | Borrowers | Default Rate |
|---|---:|---:|
| Debt Consolidation | 5,212 | 28.59% |
| Medical | 6,071 | 26.70% |
| Home Improvement | 3,605 | 26.10% |
| Personal | 5,521 | 19.89% |
| Education | 6,453 | 17.22% |
| Venture | 5,719 | 14.81% |

Debt consolidation, medical and home improvement loans had higher observed default rates than education and venture loans in this dataset.

These differences may justify further analysis of borrower circumstances, loan terms and affordability. They do not establish that a particular loan purpose inherently makes a borrower riskier.

### 6.6 Homeownership Categories Show Different Risk Profiles

| Homeownership | Borrowers | Default Rate |
|---|---:|---:|
| Rent | 16,446 | 31.57% |
| Other | 107 | 30.84% |
| Mortgage | 13,444 | 12.57% |
| Own | 2,584 | 7.47% |

Renters had a higher observed default rate than borrowers in the mortgage and own categories.

Homeownership should not be used as a standalone basis for lending decisions. The relationship may reflect differences in income, affordability, employment or other borrower characteristics.

### 6.7 The Extended Logistic Regression Model Improves Predictive Discrimination

| Metric | Model A | Model B |
|---|---:|---:|
| ROC-AUC | 0.8221 | 0.8771 |
| PR-AUC | 0.6601 | 0.7469 |
| Accuracy | Not reported here | 87.02% |
| Precision | Not reported here | 77.53% |
| Recall | Not reported here | 57.03% |
| F1-score | Not reported here | 0.6572 |

Model B achieved higher ROC-AUC and PR-AUC than Model A, indicating improved discrimination between default and non-default observations in the test set.

At a 0.50 classification threshold, Model B identified 811 of 1,422 test-set defaults, achieving 57.03% recall. It missed the remaining 42.97%.

This highlights the importance of assessing recall and precision alongside accuracy when evaluating a credit risk model.

The improvement does not establish that Model B is suitable for every lending scenario. Loan grade and interest rate may reflect earlier underwriting decisions, and further validation is needed before operational use.

## 7. Business Recommendations

The following recommendations are proposed based on the observed results. They require further validation before being adopted as lending policy.

### 7.1 Strengthen Affordability Assessment Using Multiple Indicators

The 57.45% default rate among borrowers with both high LTI and high DTI indicates that the combination of these measures may help identify applications warranting closer assessment.

**Proposed actions:**

- Evaluate LTI and DTI jointly during affordability assessment.
- Investigate whether combining affordability indicators improves risk identification beyond either ratio alone.
- Review repayment capacity, existing debt obligations, income stability and proposed loan terms before making a decision.
- Test alternative thresholds using out-of-sample performance and business costs instead of adopting the 80th-percentile cut-offs as fixed policy limits.

**Expected benefit:** More informative affordability assessment and earlier identification of potentially vulnerable applications without relying on a single financial ratio.

### 7.2 Use Risk Segments to Prioritise Review, Not Automatically Reject Borrowers

The substantial differences in default rates across loan grades and affordability segments suggest that risk-based review could help allocate assessment resources.

**Proposed actions:**

- Prioritise further review of applications exhibiting multiple high-risk indicators.
- Investigate whether additional verification, affordability checks or tailored loan terms could address specific risks.
- Monitor outcomes across risk segments to assess whether the review process improves portfolio performance.
- Avoid automatic rejection based solely on a segment label, particularly where sample sizes are small or evidence is limited.

**Expected benefit:** A more structured risk assessment process that considers credit risk alongside opportunities to serve eligible borrowers responsibly.

### 7.3 Incorporate Previous Credit Difficulties into a Broader Assessment

Borrowers with a previous default indicator had a 37.81% default rate, compared with 18.39% among borrowers without that indicator.

**Proposed actions:**

- Assess previous default history alongside current affordability and other relevant credit information.
- Investigate whether the recency and severity of past difficulties add predictive value, if those data become available.
- Explore whether borrowers who demonstrate improved financial circumstances can be assessed more accurately using updated information.

**Expected benefit:** Better-informed credit assessment that recognises past risk signals without treating historical difficulties as the only determinant of future creditworthiness.

### 7.4 Evaluate Loan Pricing and Terms Using Additional Evidence

Default rates and average interest rates differ across loan grades. However, the current analysis does not establish the optimal interest rate, prove that higher rates cause defaults or measure risk-adjusted profitability.

**Proposed actions:**

- Analyse default outcomes across interest-rate bands, loan amounts and loan terms while controlling for other relevant borrower characteristics.
- Assess whether loan pricing adequately reflects expected credit losses, funding costs and operating costs.
- Compare alternative loan-term scenarios using appropriate risk and affordability measures.
- Evaluate risk-adjusted returns before proposing pricing or term adjustments.

**Expected benefit:** A stronger evidence base for assessing the balance between lending risk, borrower affordability, and sustainable returns.

### 7.5 Monitor Fairness and Access to Credit

Nova Bank's objective is to reduce unnecessary credit risk while maintaining fair and accessible lending. Risk differences across borrower groups should therefore be evaluated carefully.

**Proposed actions:**

- Assess model performance and approval outcomes across relevant demographic and geographic groups where legally and ethically appropriate.
- Investigate whether apparent risk differences persist after accounting for relevant financial and credit characteristics.
- Review potential sources of bias, including historical underwriting decisions reflected in loan grade and interest rate.
- Establish transparent review procedures and ongoing monitoring before using model outputs in real credit decisions.

**Expected benefit:** More responsible risk assessment, with explicit attention to both portfolio outcomes and equitable access to lending.

## 8. Limitations & Further Work

This project provides an exploratory portfolio analysis and predictive modelling benchmark. Several limitations should be addressed before the findings are used operationally.

- **Association versus causation:** The observed relationships do not establish why a borrower defaults or whether changing one variable would change the outcome.
- **Model features:** Loan grade and interest rate may encode earlier underwriting decisions. Model B is an extended benchmark, not a suitable pre-underwriting model.
- **Classification threshold:** A threshold of 0.50 is a baseline and has not been optimised against the bank's business costs.
- **Model validation:** Further work is needed on calibration, out-of-time validation, stability and fairness.
- **Segment sizes:** Some categories, particularly loan grade G and homeownership category Other, contain relatively few borrowers.
- **Geographic analysis:** Although country and location fields are available, comparative default analysis across the United States, United Kingdom and Canada is not included in the reported findings.
- **Loan terms and employment:** The reported findings do not establish the independent effects of loan term, employment type or interest rate after controlling for other variables.
- **Feature interpretation:** A systematic feature-importance or coefficient interpretation analysis is not reported here.
- **Profitability and policy impact:** The analysis does not estimate expected loss, risk-adjusted profitability or the causal effect of proposed lending policy changes.

Potential extensions include geographic risk analysis, model interpretability, threshold optimisation, probability calibration, fairness testing, and expected-loss analysis.

## 9. Power BI Dashboard

### Portfolio Overview

![image alt](https://github.com/kristineng/Nova-Bank_Credit-Risk-Analytics/blob/8c32ea40b7095c72da10573e0353d85a5d460c94/images/Screenshot%202026-10-09%20180715.png)

### Risk Segmentation

![image alt](https://github.com/kristineng/Nova-Bank_Credit-Risk-Analytics/blob/4f6109e6e1d5996c8772cc8049625277bcdece30/images/Screenshot%202026-10-09%20180737.png)

### Risk Drivers

![image alt](https://github.com/kristineng/Nova-Bank_Credit-Risk-Analytics/blob/4f6109e6e1d5996c8772cc8049625277bcdece30/images/Screenshot%202026-10-09%20180754.png)


## 12. Skills Demonstrated

- SQL data validation and analytical querying
- PostgreSQL views, CTEs, window functions and segmentation
- Portfolio analysis and credit risk segmentation
- Python data preprocessing and feature engineering
- Logistic regression and binary classification evaluation
- Model comparison using ROC-AUC, PR-AUC, precision, recall and F1-score
- Power BI dashboard development and KPI reporting
- Translating quantitative findings into practical business recommendations

## 13. Data Source
https://www.facebook.com/groups/xomdata/?__cft__[0]=AZgBColPoGwxaZ25pf29dUX04r1AT0JTGPU5a31JdtqdAT_9ui01fzvTrQuqHRHLq-XWWbxY86VZkZNh9BVaKiT7SDUuTP0E0ARcsMaGI7_YOCtHT4j9eZinsTDu46JdBxeH1qih50syF6nKNzlf&__tn__=R]-R
