-- Business Question:
-- Which channels are under-credited by GA4's last-click attribution model?
-- Compares first-touch channel (where the journey started) vs last-touch
-- channel (what GA4 credits) for every user who purchased in January 2021.

WITH purchases AS (
  -- Step 1: Identify users who converted
  SELECT DISTINCT user_pseudo_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20210131'
    AND event_name = 'purchase'
),

user_attribution AS (
  -- Step 2: Get full session journey for converting users only
  SELECT
    e.user_pseudo_id,
    CASE
      WHEN e.traffic_source.medium = 'cpc'      THEN 'Paid'
      WHEN e.traffic_source.medium = 'organic'  THEN 'Organic'
      WHEN e.traffic_source.source = '(direct)' THEN 'Direct'
      ELSE 'Other'
    END AS channel,
    e.event_timestamp
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` e
  INNER JOIN purchases p ON p.user_pseudo_id = e.user_pseudo_id
  WHERE e._TABLE_SUFFIX BETWEEN '20210101' AND '20210131'
    AND e.event_name = 'session_start'
),

sessions AS (
  -- Step 3: Assign first-touch and last-touch channel per user
  SELECT DISTINCT
    user_pseudo_id,
    FIRST_VALUE(channel) OVER (
      PARTITION BY user_pseudo_id
      ORDER BY event_timestamp
    ) AS first_touch_channel,
    LAST_VALUE(channel) OVER (
      PARTITION BY user_pseudo_id
      ORDER BY event_timestamp
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_touch_channel
  FROM user_attribution
)

-- Step 4: Count users per attribution path
SELECT
  first_touch_channel,
  last_touch_channel,
  COUNT(DISTINCT user_pseudo_id) AS total_users
FROM sessions
GROUP BY first_touch_channel, last_touch_channel
ORDER BY total_users DESC
