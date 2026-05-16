# GA4 SQL Attribution Library

GA4's standard reports are sampled and built on last-click attribution.
This library queries raw GA4 BigQuery export tables — unsampled, partition-optimized,
and structured around real attribution business problems.

## Queries

| # | Business Question | Concepts | Key Finding |
|---|---|---|---|
| 01 | Which channels drove purchases? | GROUP BY · _TABLE_SUFFIX partition pruning | Baseline purchase volume by acquisition source |
| 02 | Which source + medium drove purchases? | Multi-column GROUP BY · partition pruning | Google organic (310) outperformed all paid channels in Jan 2021 |
| 03 | Classify purchases into Paid / Organic / Direct / Other buckets | CASE WHEN · conditional classification | 56% of purchases unclassified — attribution gap identified |

## Stack
BigQuery · GA4 Raw Export · Standard SQL

## Usage
All queries run against `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
Zero setup required beyond a Google account.
