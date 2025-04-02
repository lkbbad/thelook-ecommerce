set @@dataset_project_id = 'round-music-451401-a5';
set @@dataset_id = 'thelook_analytics';

CREATE OR REPLACE TABLE
  `stg_users` AS
SELECT 
  id AS user_id
  , first_name
  , last_name
  , email
  , age
  , gender
  , state
FROM 
  `thelook_local.users`;