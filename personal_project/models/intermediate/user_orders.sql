set @@dataset_project_id = 'round-music-451401-a5';
set @@dataset_id = 'thelook_analytics';

CREATE OR REPLACE TABLE 
  `user_orders` AS
SELECT 
  u.user_id
  , o.order_id
  , o.order_status
  , o.order_created_at
  , o.order_returned_at
  , o.order_item_count
FROM  
  `stg_users` u
LEFT JOIN
  `stg_orders` o 
ON
  u.user_id = o.user_id;