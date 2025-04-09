-- Staging Model: stg_products
-- Description: Standardizes raw product data by renaming fields and clarifying column names.
-- Includes brand, category, department, pricing (retail and cost), and distribution center reference.
-- Used by: order_items_enriched, product_performance, customer_metrics
-- Source table: thelook_local.products

SELECT 
  id AS product_id
  , name AS product_name
  , brand AS product_brand
  , category AS product_category
  , retail_price AS product_retail_price
  , cost AS product_cost
  , department AS product_department
  , distribution_center_id AS product_distribution_center_id  
FROM
  {{ source('thelook_ecommerce', 'products') }}