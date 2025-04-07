-- Mart: product_performance
-- Description: One row per product including metrics for views, purchases, revenue, cost, profit, conversion rate, and return rate.
-- Used for: Analyzing product-level performance, identifying top sellers, low converters, and high return items.
-- Source tables: stg_products, event_product_views, order_items_enriched

set @@dataset_project_id = 'round-music-451401-a5';
set @@dataset_id = 'thelook_analytics';

CREATE OR REPLACE TABLE 
  product_performance AS
WITH product_views AS (
  SELECT 
    product_id
    , COALESCE(COUNT(DISTINCT event_id), 0) AS total_product_views
    , COALESCE(COUNT(DISTINCT session_id), 0) AS unique_product_views
  FROM
    events_product_views
  GROUP BY 
    product_id
),
product_sales_metrics AS (
  SELECT 
    product_id
  , ANY_VALUE(product_sale_price) AS product_sale_price
  , COALESCE(COUNT(DISTINCT item_id), 0) AS total_product_purchases
  , COALESCE(SUM(product_sale_price), 0) AS total_product_revenue
  , COALESCE(SUM(product_retail_price), 0) AS total_product_potential_revenue
  , COALESCE(SUM(product_cost), 0) AS total_product_cost
  , COALESCE(COUNTIF(item_status = 'Returned'), 0) AS total_product_returns
  , SAFE_DIVIDE(SUM(product_sale_price), COUNT(DISTINCT item_id)) AS avg_sale_price
  FROM
    order_items_enriched
  GROUP BY 
    product_id
)
SELECT 
  p.product_id
  , ANY_VALUE(p.product_brand) AS product_brand
  , ANY_VALUE(p.product_category) AS product_category
  , ANY_VALUE(p.product_department) AS product_department
  , ANY_VALUE(p.product_retail_price) AS product_retail_price
  , ANY_VALUE(p.product_cost) AS product_cost
  , COALESCE(MAX(v.total_product_views), 0) AS total_product_views
  , COALESCE(MAX(v.unique_product_views), 0) AS unique_product_views
  , COALESCE(MAX(s.total_product_purchases), 0) AS total_product_purchases
  , COALESCE(MAX(s.total_product_revenue), 0) AS total_product_revenue
  , COALESCE(MAX(s.total_product_cost), 0) AS total_product_cost
  , COALESCE(MAX(s.total_product_revenue) - MAX(s.total_product_cost), 0) AS total_product_profit
  , COALESCE(SAFE_DIVIDE(MAX(s.total_product_purchases), MAX(v.unique_product_views)), 0) AS product_conversion_rate
  , COALESCE(MAX(s.total_product_returns), 0) AS total_product_returns
  , COALESCE(SAFE_DIVIDE(MAX(s.total_product_returns), MAX(s.total_product_purchases)), 0) AS product_return_rate
FROM
  stg_products p
LEFT JOIN product_views v ON p.product_id = v.product_id
LEFT JOIN product_sales_metrics s ON p.product_id = s.product_id
GROUP BY 
  p.product_id;