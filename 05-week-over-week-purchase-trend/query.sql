-- Business Question:
-- How are purchases trending week over week per channel in January 2021?
-- Uses LAG() window function to compare each week against the previous week
-- without collapsing rows or requiring a self-join.

WITH weekly_purchases AS (
  SELECT
    CASE
      WHEN traffic_source.medium = 'cpc'      THEN 'Paid'
      WHEN traffic_source.medium = 'organic'  THEN 'Organic'
      WHEN traffic_source.source = '(direct)' THEN 'Direct'
      ELSE 'Other'
    END AS channel,
    EXTRACT(WEEK FROM PARSE_DATE('%Y%m%d', event_date)) AS week_number,
    COUNT(*) AS total_purchases
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20210131'
    AND event_name = 'purchase'
  GROUP BY channel, week_number
)

SELECT
  channel,
  week_number,
  total_purchases,
  LAG(total_purchases) OVER (PARTITION BY channel ORDER BY week_number) AS prev_week_purchases,
  total_purchases - LAG(total_purchases) OVER (PARTITION BY channel ORDER BY week_number) AS week_over_week_change
FROM weekly_purchases

ORDER BY channel, week_number
