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