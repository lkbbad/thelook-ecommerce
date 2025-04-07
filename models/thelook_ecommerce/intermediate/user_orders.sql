-- Intermediate Model: user_orders
-- Description: Joins cleaned user and order data to create a user-level order history. 
-- Includes order status, timestamps, and item count for each order placed by a user.
-- Used by: customer_metrics, cross_sell_candidates
-- Source tables: stg_users, stg_orders

SELECT 
  u.user_id
  , o.order_id
  , o.order_status
  , o.order_created_at
  , o.order_returned_at
  , o.order_item_count
FROM  
  {{ ref('stg_users') }} u
LEFT JOIN
  {{ ref('stg_orders') }} o 
ON
  u.user_id = o.user_id