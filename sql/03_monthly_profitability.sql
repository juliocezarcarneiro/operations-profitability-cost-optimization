-- ============================================
-- File: 03_monthly_profitability.sql
-- Purpose: Monthly profitability analysis
-- ============================================

WITH sales_agg AS (
    SELECT
        month,
        location_id,
        product_id,
        SUM(revenue) AS total_revenue,
        SUM(units_sold) AS total_units_sold
    FROM sales
    GROUP BY
        month,
        location_id,
        product_id
),

costs_clean AS (
    SELECT
        month,
        location_id,
        product_id,
        COALESCE(cogs, 0)
        + COALESCE(labor_cost, 0)
        + COALESCE(packaging_cost, 0)
        + COALESCE(overhead_allocated, 0) AS total_cost_clean
    FROM costs
)

SELECT
    TO_DATE(s.month, 'YYYY-MM') AS month,
    ROUND(SUM(s.total_revenue), 2) AS total_revenue,
    ROUND(SUM(c.total_cost_clean), 2) AS total_cost_clean,
    ROUND(SUM(s.total_revenue) - SUM(c.total_cost_clean), 2) AS gross_profit,
    ROUND(
        (SUM(s.total_revenue) - SUM(c.total_cost_clean))
        / NULLIF(SUM(s.total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM sales_agg s
JOIN costs_clean c
    ON s.month = c.month
   AND s.location_id = c.location_id
   AND s.product_id = c.product_id
GROUP BY TO_DATE(s.month, 'YYYY-MM')
ORDER BY month;