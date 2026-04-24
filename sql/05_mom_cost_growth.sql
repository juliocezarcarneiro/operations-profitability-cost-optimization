-- ============================================
-- File: 05_mom_cost_growth.sql
-- Purpose: Month-over-month clean cost growth analysis
-- Project: Operations Profitability & Cost Optimization
-- ============================================

WITH monthly_costs AS (
    SELECT
        TO_DATE(month, 'YYYY-MM') AS month,
        SUM(
            COALESCE(cogs, 0)
            + COALESCE(labor_cost, 0)
            + COALESCE(packaging_cost, 0)
            + COALESCE(overhead_allocated, 0)
        ) AS total_cost_clean
    FROM costs
    GROUP BY TO_DATE(month, 'YYYY-MM')
),

cost_growth AS (
    SELECT
        month,
        total_cost_clean,
        LAG(total_cost_clean) OVER (ORDER BY month) AS previous_month_cost
    FROM monthly_costs
)

SELECT
    month,
    ROUND(total_cost_clean, 2) AS total_cost_clean,
    ROUND(previous_month_cost, 2) AS previous_month_cost,
    ROUND(
        (total_cost_clean - previous_month_cost)
        / NULLIF(previous_month_cost, 0) * 100,
        2
    ) AS mom_cost_growth_pct,
    CASE
        WHEN previous_month_cost IS NULL THEN 'First Month'
        WHEN (total_cost_clean - previous_month_cost)
             / NULLIF(previous_month_cost, 0) * 100 >= 10
        THEN 'Cost Spike'
        WHEN (total_cost_clean - previous_month_cost)
             / NULLIF(previous_month_cost, 0) * 100 <= -10
        THEN 'Cost Reduction'
        ELSE 'Normal'
    END AS cost_growth_flag
FROM cost_growth
ORDER BY month;