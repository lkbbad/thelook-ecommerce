set @@dataset_project_id = 'round-music-451401-a5';
set @@dataset_id = 'thelook_analytics';

CREATE OR REPLACE TABLE
  `stg_events` AS
SELECT
  id AS event_id
  , user_id
  , session_id 
  , event_type
  , sequence_number AS event_sequence_num
  , created_at AS event_created_at
  , browser
  , traffic_source
  , uri
  , user_id IS NULL AS no_user_id
FROM `thelook_local.events`;