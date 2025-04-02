set @@dataset_project_id = 'round-music-451401-a5';
set @@dataset_id = 'thelook_analytics';

CREATE OR REPLACE TABLE 
  `stg_orders` AS
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
  `thelook_local.orders`;