## First-Touch vs Last-Touch Attribution — GA4 BigQuery

### Business Problem
GA4 uses last-click attribution by default. The final channel
a user touched before purchasing gets 100% of the credit.
Every channel before that gets zero.

This query compares first-touch and last-touch channel for every
converting user — exposing which channels start journeys but
receive no credit in standard GA4 reporting.

### Key Finding (January 2021, GA4 Sample Dataset)
| First Touch | Last Touch | Users |
|---|---|---|
| Other | Other | 543 |
| Organic | Organic | 185 |
| Organic | Other | 175 |
| Other | Organic | 97 |
| Paid | Other | 23 |
| Paid | Paid | 17 |

175 users started their journey via Organic but were credited
to Other by GA4's last-click model. Organic is under-credited
by at least 175 converting users.

23 users were acquired via Paid search — the only channel with
direct cost — but GA4 assigned zero credit to Paid for their
conversion. Budget decisions made on last-click data would
undervalue every paid campaign that starts a journey.

### How This Query Works
- CTE 1 (purchases): finds all users who converted — the universe
  of users we care about
- CTE 2 (user_attribution): pulls every session for those users
  joined back to the events table
- CTE 3 (sessions): applies FIRST_VALUE and LAST_VALUE window
  functions to identify journey start and end channel per user
- Final SELECT: counts users per first-touch + last-touch combination

### Technical Notes
- INNER JOIN limits sessions to converting users only —
  non-purchasers excluded from attribution analysis
- FIRST_VALUE needs only ORDER BY — returns first row naturally
- LAST_VALUE needs ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED
  FOLLOWING — without this clause BigQuery defaults to current row
  only, returning identical values to FIRST_VALUE
- DISTINCT in sessions CTE collapses window function output to
  one row per user
- COUNT(DISTINCT user_pseudo_id) prevents double-counting users
  who appear in multiple session rows

### Concepts Demonstrated
FIRST_VALUE · LAST_VALUE · ROWS BETWEEN · INNER JOIN ·
multi-CTE pipeline · user-level attribution · DISTINCT
