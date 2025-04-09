-- Staging Model: stg_orders
-- Description: Cleans and renames raw orders data. Standardizes column names for order status, timestamps, and item count for each user’s order.
-- Includes key lifecycle timestamps (created, shipped, delivered, returned) and total item count.
-- Used by: user_orders, customer_metrics
-- Source table: thelook_local.orders

SELECT 
  order_id
  , user_id
  , status AS order_status
  , created_at AS order_created_at
  , returned_at AS order_returned_at
  , shipped_at AS order_shipped_at
  , delivered_at AS order_delivered_at
  , num_of_item AS order_item_count
FROM
  {{ source('round-music-451401-a5', 'orders') }}