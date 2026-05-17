WITH sessions AS(
  SELECT 
    CASE
    WHEN traffic_source.medium = 'cpc'      THEN 'Paid'
    WHEN traffic_source.medium = 'organic'  THEN 'Organic'
    WHEN traffic_source.source = '(direct)' THEN 'Direct'
    ELSE 'Other'
  END AS channel,
  COUNT(*) AS total_sessions
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20210131'
  AND event_name = 'session_start'
  GROUP BY channel
),
 purchases AS (
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
)

SELECT
  sessions.channel,
  sessions.total_sessions,
  purchases.total_purchases,
  ROUND(purchases.total_purchases / sessions.total_sessions * 100.0, 2) AS conversion_rate
FROM sessions
JOIN purchases ON sessions.channel = purchases.channel


ORDER BY conversion_rate DESC
