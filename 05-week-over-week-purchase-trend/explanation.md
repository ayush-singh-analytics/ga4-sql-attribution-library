## Week-over-Week Purchase Trend — GA4 BigQuery

### Business Problem
Raw purchase counts per week show volume but not momentum.
A channel with 180 purchases is strong — but if it had 178 last week,
growth is flat. If it had 560, it collapsed.

Week-over-week change reveals trend. This query surfaces it
automatically for every channel without manual subtraction.

### Key Finding (January 2021, GA4 Sample Dataset)
- Other channel grew consistently weeks 1-4: +58, +46, +63, +2
- Week 5 (partial week) shows -173 drop — expected end-of-month
  truncation, not a real decline
- NULL on week 0 is correct — no previous week exists to compare

### How LAG() Works Here
LAG() looks at the previous row within each channel's group
and pulls its total_purchases value into the current row.
PARTITION BY channel ensures each channel resets independently —
week 1 Paid does not look back at week 5 Organic.

### Technical Notes
- PARTITION BY channel — resets LAG() window per channel
- ORDER BY week_number — defines what "previous" means
- PARSE_DATE('%Y%m%d', event_date) converts '20210115' to a real date
- EXTRACT(WEEK FROM ...) pulls the week number from that date
- NULL on first row per partition is correct behaviour, not an error
- No GROUP BY in final SELECT — weekly_purchases CTE already aggregated

### Concepts Demonstrated
Window functions · LAG() · PARTITION BY · OVER() ·
EXTRACT · PARSE_DATE · CTE + window function combination
