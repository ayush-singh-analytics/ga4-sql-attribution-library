# GA4 SQL Attribution Library

GA4's standard reports are sampled and built on last-click attribution.

This library queries raw GA4 BigQuery export tables — unsampled, partition-optimized,

and structured around real attribution business problems.

## Queries

| # | Business Question | Concepts |

|---|---|---|

| 01 | Which channels drove purchases? | GROUP BY, _TABLE_SUFFIX partition pruning |

| 02 | Which source + medium combinations drove purchases? | GROUP BY multi-column · partition pruning |

## Stack

BigQuery · GA4 Raw Export · Standard SQL

## Usage

All queries run against `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

Zero setup required beyond a Google account.
