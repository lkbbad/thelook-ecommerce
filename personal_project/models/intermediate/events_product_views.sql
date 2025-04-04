set @@dataset_project_id = 'round-music-451401-a5';
set @@dataset_id = 'thelook_analytics';

CREATE OR REPLACE TABLE
  `events_product_views` AS
SELECT
  user_id
  , event_id
  , session_id
  , product_id
  , event_type
  , event_sequence_num
  , event_created_at
FROM 
  `stg_events`
WHERE 
  event_type = 'product' AND product_id IS NOT NULL;