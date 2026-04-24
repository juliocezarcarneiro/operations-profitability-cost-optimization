-- ============================================
-- File: 04_location_performance.sql
-- Purpose: Location-level revenue, cost, profit, and margin analysis
-- Project: Operations Profitability & Cost Optimization
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
),

location_performance AS (
    SELECT
        l.location_id,
        l.location_name,
        l.city,
        l.region,
        l.store_format,
        SUM(s.total_revenue) AS total_revenue,
        SUM(c.total_cost_clean) AS total_cost_clean,
        SUM(s.total_revenue) - SUM(c.total_cost_clean) AS gross_profit,
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
    JOIN locations l
        ON s.location_id = l.location_id
    GROUP BY
        l.location_id,
        l.location_name,
        l.city,
        l.region,
        l.store_format
)

SELECT
    *,
    RANK() OVER (ORDER BY gross_profit DESC) AS profit_rank,
    CASE
        WHEN gross_margin_pct < (
            SELECT AVG(gross_margin_pct)
            FROM location_performance
        )
        THEN 'Underperforming'
        ELSE 'Performing'
    END AS performance_flag
FROM location_performance
ORDER BY gross_profit DESC;