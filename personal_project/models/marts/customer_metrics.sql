-- Mart: customer_metrics
-- Description: One row per user summarizing behavioral and transactional metrics for customer profiling.
-- Includes event counts, session counts, product views, order volume, revenue, profit, and product diversity.
-- Used for: Customer segmentation, LTV estimation, and identifying candidates for cross-sell or retention campaigns.
-- Source tables: stg_users, user_orders, user_events, events_product_views, order_items_enriched

set @@dataset_project_id = 'round-music-451401-a5';
set @@dataset_id = 'thelook_analytics';

CREATE OR REPLACE TABLE 
  `customer_metrics` AS
WITH user_orders_agg AS (
  SELECT
    o.user_id
    , SUM(i.product_retail_price) AS total_order_potential_revenue
    , SUM(i.product_sale_price) AS total_order_revenue
    , SUM(i.product_cost) AS total_order_cost
    , AVG(i.product_sale_price) AS avg_order_revenue
    , AVG(i.product_cost) AS avg_order_cost
    , COUNT(DISTINCT i.product_id) AS total_products_purchased
  FROM user_orders o
  LEFT JOIN order_items_enriched i ON o.order_id = i.order_id 
  GROUP BY 
    o.user_id
  )
SELECT
  u.user_id
  , COALESCE(COUNT(DISTINCT e.event_id), 0) AS total_events
  , COALESCE(COUNT(DISTINCT e.session_id), 0) AS total_sessions
  , MAX(e.event_created_at) AS last_event_dttm
  , COALESCE(COUNT(DISTINCT v.product_id), 0) AS total_products_viewed
  , MAX(o.order_created_at) AS last_order_dttm
  , COALESCE(COUNT(DISTINCT o.order_id), 0) AS total_orders
  , COALESCE(MAX(r.total_order_revenue), 0) AS total_order_revenue
  , COALESCE(MAX(r.total_order_cost), 0) AS total_order_cost
  , COALESCE(MAX(r.total_order_revenue - r.total_order_cost), 0) AS total_order_profit
  , COALESCE(MAX(r.avg_order_revenue), 0) AS avg_order_revenue
  , COALESCE(MAX(r.avg_order_cost), 0) AS avg_order_cost
  , COALESCE(MAX(r.avg_order_revenue), 0) - MAX(r.avg_order_cost) AS avg_order_profit
  , COALESCE(MAX(r.total_products_purchased), 0) AS total_products_purchased
FROM 
  stg_users u
LEFT JOIN user_events e ON u.user_id = e.user_id
LEFT JOIN events_product_views v ON u.user_id = v.user_id
LEFT JOIN user_orders o ON u.user_id = o.user_id
LEFT JOIN user_orders_agg r ON u.user_id = r.user_id
GROUP BY 
  u.user_id;