-- Intermediate Model: events_product_views
-- Description: Filters the cleaned events data to include only product page views with a valid product_id.
-- Extracts relevant user and session-level context for downstream product engagement and conversion analysis.
-- Used by: product_performance, cross_sell_candidates
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
WHERE 
  event_type = 'product' AND product_id IS NOT NULL