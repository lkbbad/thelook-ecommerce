-- Intermediate Model: order_items_enriched
-- Description: Joins cleaned order item data with product metadata to create a product-aware item-level dataset.
-- Includes product name, brand, category, pricing, and distribution attributes alongside order item details.
-- Used by: product_performance, customer_metrics
-- Source tables: stg_order_items, stg_products

SELECT
  i.item_id
  , i.order_id
  , i.product_id
  , p.product_name
  , p.product_brand
  , p.product_category
  , p.product_retail_price
  , i.item_sale_price AS product_sale_price
  , p.product_cost
  , p.product_department
  , p.product_distribution_center_id
  , i.item_status
FROM
  {{ ref('stg_order_items') }} i
LEFT JOIN
  {{ ref('stg_products') }} p
ON
  i.product_id = p.product_id