-- Staging Model: stg_users
-- Description: Renames and standardizes fields from the raw users table. Includes basic user attributes such as name, email, age, gender, and state.
-- Used by: customer_metrics, user_orders, user_events
-- Source table: thelook_local.users

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