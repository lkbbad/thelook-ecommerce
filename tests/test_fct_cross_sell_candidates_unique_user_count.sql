-- Test uniqueness of user_id and product_id combination in fct_cross_sell_candidates mart model.

SELECT
  user_id,
  product_id,
  COUNT(*) AS record_count
FROM {{ ref('fct_cross_sell_candidates') }}
GROUP BY user_id, product_id
HAVING COUNT(*) > 1