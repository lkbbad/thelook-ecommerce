-- Staging Model: stg_order_items
-- Description: Standardizes raw order_items data by renaming fields and clarifying column semantics.
-- Includes sale price and shipment lifecycle timestamps for each item purchased by a user.
-- Used by: order_items_enriched, product_performance, customer_metrics
-- Source table: thelook_local.order_items

set @@dataset_project_id = 'round-music-451401-a5';
set @@dataset_id = 'thelook_analytics';

CREATE OR REPLACE TABLE 
  `stg_order_items` AS
SELECT 
  id AS item_id
  , order_id
  , user_id
  , product_id
  , status AS item_status
  , created_at AS item_created_at
  , shipped_at AS item_shipped_at
  , delivered_at AS item_delivered_at
  , returned_at AS item_returned_at
  , sale_price AS item_sale_price
FROM 
  `thelook_local.order_items`;