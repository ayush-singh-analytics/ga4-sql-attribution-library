-- Business Question:
-- Which source + medium combinations drove the most purchases in January 2021?
-- Separates blended channel data that GA4 UI reports as a single source row.

SELECT
  traffic_source.source   AS source,
  traffic_source.medium   AS medium,
  COUNT(*)                AS total_purchases

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20210131'
  AND event_name = 'purchase'

GROUP BY traffic_source.source, traffic_source.medium

ORDER BY total_purchases DESC
