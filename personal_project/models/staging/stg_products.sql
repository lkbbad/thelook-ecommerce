set @@dataset_project_id = 'round-music-451401-a5';
set @@dataset_id = 'thelook_analytics';

CREATE OR REPLACE TABLE 
  `stg_products` AS
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
  `thelook_local.products`;