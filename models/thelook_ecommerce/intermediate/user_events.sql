-- Intermediate Model: user_events
-- Description: Selects event-level behavior data for users. Filters and standardizes relevant fields including product views, sessions, and timestamps.
-- Used by: customer_metrics, event_product_views, cross_sell_candidates
-- Source table: stg_events

SELECT
  user_id
  , event_id
  , session_id
  , product_id
  , event_type
  , event_sequence_num
  , event_created_at
FROM
  {{ ref('stg_events') }}