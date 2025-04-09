-- Staging Model: stg_users
-- Description: Renames and standardizes fields from the raw users table. Includes
-- basic user attributes such as name, email, age, gender, and state.
-- Used by: customer_metrics, user_orders, user_events
-- Source table: thelook_local.users

SELECT 
  id AS user_id
  , first_name
  , last_name
  , email
  , age
  , gender
  , state
FROM 
  {{ source('thelook_ecommerce', 'users') }}
