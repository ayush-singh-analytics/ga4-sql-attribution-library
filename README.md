# GA4 SQL Attribution Library

GA4's standard reports are sampled and built on last-click attribution.
This library queries raw GA4 BigQuery export tables — unsampled, partition-optimized,
and structured around real attribution business problems.

## Queries

| # | Business Question | Concepts | Key Finding |
|---|---|---|---|
| 01 | Which channels drove purchases? | GROUP BY · _TABLE_SUFFIX partition pruning | Baseline purchase volume by acquisition source |
| 02 | Which source + medium drove purchases? | Multi-column GROUP BY · partition pruning | Google organic (310) outperformed all paid channels in Jan 2021 |
| 03 | Classify purchases into Paid / Organic / Direct / Other | CASE WHEN · conditional classification | 56% of purchases unclassified — attribution gap identified |
| 04 | Which channel converts sessions into purchases most efficiently? | CTEs · JOIN · conversion rate | Paid search converts at 0.73% — lowest of all channels despite direct cost |
| 05 | How are purchases trending week over week per channel? | Window functions · LAG() · PARTITION BY | Other channel grew +63 in week 4 before sharp end-of-month drop |
| 06 | Which channels are under-credited by GA4's last-click model? | FIRST_VALUE · LAST_VALUE · INNER JOIN · multi-CTE pipeline | Paid search started 23 user journeys that GA4 attributed entirely to other channels |

## Stack
BigQuery · GA4 Raw Export · Standard SQL

## Usage
All queries run against `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
Zero setup required beyond a Google account.
