-- Business Question:
-- How many purchases came from Paid, Organic, Direct, and Other channels in January 2021?
-- Collapses raw source/medium combinations into four business-meaningful buckets.

SELECT
  CASE
    WHEN traffic_source.medium = 'cpc'      THEN 'Paid'
    WHEN traffic_source.medium = 'organic'  THEN 'Organic'
    WHEN traffic_source.source = '(direct)' THEN 'Direct'
    ELSE 'Other'
  END AS channel,
  COUNT(*) AS total_purchases

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20210131'
  AND event_name = 'purchase'

GROUP BY channel

ORDER BY total_purchases DESC
