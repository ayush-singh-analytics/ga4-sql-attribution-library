SELECT
  traffic_source.source AS traffic_source,
  COUNT(*) AS total_purchases

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20210131'
  AND event_name = 'purchase'

GROUP BY traffic_source.source

ORDER BY total_purchases DESC
