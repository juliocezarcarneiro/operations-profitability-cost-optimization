# Operations Profitability & Cost Optimization

## Project Overview

This project analyzes restaurant operations data to identify profitability drivers, cost inefficiencies, and opportunities to improve margins.

The analysis focuses on validating the data first, then building a reliable foundation for SQL analysis, Python reporting, dashboarding, and business recommendations.

---

## Business Objective

The goal of this project is to answer:

**Where is profitability being lost, why is it happening, and what actions should the business prioritize?**

Key focus areas:

* Revenue and profitability trends
* Cost growth by month, product, and location
* Waste and operational inefficiencies
* Margin improvement opportunities
* Data quality and reconciliation issues

---

## Tools Used

* PostgreSQL
* pgAdmin
* SQL
* Python
* pandas
* Jupyter Notebook
* GitHub

---

## Project Structure

```
sql/
├── 01_create_tables.sql
├── 00_data_validation_checks.sql
├── 02_validation_outputs.sql
├── 02_monthly_profitability.sql
├── 03_location_performance.sql
└── 04_mom_cost_growth.sql

notebooks/
└── 01_data_validation.ipynb

data/
└── cleaned/
    └── validation_summary.csv

outputs/
└── validation_results_final.csv

images/
├── validation_failures.png
├── validation_summary.png
└── validation_top_issues.png
```

---

## Data Quality Validation Framework

A SQL validation framework was created before analysis to test data quality, structural integrity, and reconciliation logic.

Validation checks covered:

* Missing values
* Duplicate records
* Negative values
* Orphan keys
* Date and month consistency
* Sales-to-cost join coverage
* Category consistency
* Cost and percentage reconciliation checks

---

## Validation Findings

Core structural checks passed successfully, including missing values, duplicate records, negative records, orphan keys, date/month consistency, and sales-to-cost join coverage.

Two reconciliation checks failed and were flagged for review:

* `cost_components_not_equal_total_cost`: 553 rows, high severity
* `vendor_cost_change_pct_mismatch`: 139 rows, medium severity

These issues indicate calculation inconsistencies rather than structural data failures.

The dataset can move forward to profitability analysis, but the raw `total_cost` and `cost_change_pct` fields should be reviewed or replaced with cleaned calculated fields before final executive conclusions.

---

## Validation Outputs

Validation results generated in SQL were exported and processed in Python to create a clean summary dataset.

### Process

1. Created validation checks in SQL
2. Saved results into `validation_results`
3. Created final saved table: `validation_results_final`
4. Exported validation results from pgAdmin as CSV
5. Loaded results into pandas
6. Selected key fields:

   * test_name
   * table_name
   * issue_count
   * severity
   * status
   * action_taken
7. Sorted by severity and issue count
8. Exported clean summary file to:

data/cleaned/validation_summary.csv

---

## Key Validation Files

* SQL validation script: sql/00_data_validation_checks.sql
* Validation output script: sql/02_validation_outputs.sql
* Full validation export: outputs/validation_results_final.csv
* Clean validation summary: data/cleaned/validation_summary.csv
* Validation notebook: notebooks/01_data_validation.ipynb

---

## Validation Screenshots

### Validation Failures

![Validation Failures](images/validation_failures.png)

### Validation Summary

![Validation Summary](images/validation_summary.png)

---

## Data Quality Decision

The dataset is structurally reliable enough to continue into profitability analysis.

However, two reconciliation issues were documented and flagged:

* total_cost should be recalculated from its cost components
* cost_change_pct should be recalculated from actual and prior unit cost

For downstream analysis, cleaned calculated fields should be used:

total_cost_clean = cogs + labor_cost + packaging_cost + overhead_allocated
cost_change_pct_clean = (actual_unit_cost - prior_unit_cost) / prior_unit_cost

---

## Next Analysis Steps

The next phase of the project will focus on SQL-based profitability analysis.

Planned analysis files:

* 02_monthly_profitability.sql
* 03_location_performance.sql
* 04_mom_cost_growth.sql

These files will analyze:

* Monthly revenue and profitability
* Gross margin trends
* Location-level performance
* Month-over-month cost growth
* Operational cost drivers

---

## Senior-Level Project Goals

This project is designed to demonstrate:

* Data quality validation before analysis
* Reproducible SQL workflow
* Clean Python reporting layer
* Clear documentation of data issues
* Business-focused profitability analysis
* Actionable recommendations linked to measurable outcomes

---

## Current Status

* [x] Database schema created
* [x] SQL validation framework created
* [x] Validation results saved
* [x] Validation screenshots created
* [x] Validation summary exported with Python
* [x] Validation findings documented
* [ ] Monthly profitability analysis
* [ ] Location performance analysis
* [ ] Cost growth analysis
* [ ] Dashboard
* [ ] Final business recommendations
