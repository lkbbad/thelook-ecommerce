-- Staging Model: stg_events
-- Description: Cleans and standardizes raw events data. Renames fields, casts timestamps and parses product_id from URI for use in product-level engagement analysis.
-- Used by: user_events, event_product_views, customer_metrics, product_performance
-- Source table: thelook_local.events

SELECT
  id AS event_id
  , user_id
  , session_id 
  -- Extract product ID from URI like '/product/7479'
  , SAFE_CAST(REGEXP_EXTRACT(uri, r'/product/(\d+)') AS INT64) AS product_id
  , event_type
  , sequence_number AS event_sequence_num
  , created_at AS event_created_at
  , browser
  , traffic_source
  , user_id IS NULL AS no_user_id
FROM 
    `round-music-451401-a5.thelook_local.events`