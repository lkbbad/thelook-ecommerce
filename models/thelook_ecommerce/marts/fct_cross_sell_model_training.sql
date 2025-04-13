-- Mart: fct_cross_sell_model_training
-- Description: One row per user-product pair where the product was viewed, regardless of whether they purchased. Includes purchase label and product metadata.

WITH views_by_user_product AS (
  SELECT
    user_id
    , product_id
    , COUNT(event_id) AS total_product_views
    , MIN(event_created_at) AS first_viewed_at
    , MAX(event_created_at) AS last_viewed_at
  FROM
    {{ ref('int_events_product_views') }}
  WHERE
    user_id IS NOT NULL
  GROUP BY 
    user_id
    , product_id
),

actual_purchases AS (
  SELECT
    u.user_id
    , o.product_id
  FROM 
    {{ ref('int_user_orders') }} u
  LEFT JOIN {{ ref('int_order_items_enriched') }} o ON u.order_id = o.order_id
  WHERE o.item_status NOT IN ('Cancelled')
),

cross_sell_base AS (
  SELECT
    v.user_id
    , v.product_id
    , v.total_product_views
    , v.first_viewed_at
    , v.last_viewed_at
    , CASE
      WHEN p.user_id IS NOT NULL THEN 1 
      ELSE 0 
    END AS has_purchased
  FROM 
    views_by_user_product v
  LEFT JOIN actual_purchases p 
  ON v.user_id = p.user_id AND v.product_id = p.product_id
)

SELECT 
  c.user_id
  , c.product_id
  , p.product_name
  , p.product_brand
  , p.product_category
  , p.product_department
  , p.product_retail_price
  , p.product_cost
  , c.total_product_views
  , c.first_viewed_at
  , c.last_viewed_at
  , c.has_purchased
  , CASE 
      WHEN c.has_purchased = 0 
        THEN c.total_product_views * p.product_retail_price
      ELSE 0
    END AS estimated_lost_revenue
FROM
  cross_sell_base c
LEFT JOIN {{ ref('stg_products') }} p ON c.product_id = p.product_id