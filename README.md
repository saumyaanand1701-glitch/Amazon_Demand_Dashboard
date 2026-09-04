# Amazon Product Demand Analysis

SQL and Power BI analysis of 24,000+ real Amazon product listings — identifying what actually drives purchase demand: price, sponsorship, ratings, or coupons.

## Business Question
Across thousands of Amazon product listings, what correlates most strongly with purchase demand — price, paid sponsorship, coupons, or customer ratings? Is sponsored/discounted placement genuinely associated with more sales, or is organic reputation (rating, reviews) doing the real work?

## Data
Source: Amazon product listing data (Kaggle, "Amazon Sales Data — Uncleaned"), originally 42,675 scraped product listings across electronics and accessories categories.

## 1. Data Cleaning
The raw file stored every field as unstructured text. Key fixes, done in Power Query and Excel:

| Column | Issue | Fix |
|---|---|---|
| `Rating` | Text like `"4.6 out of 5 stars"` | Split and extracted the numeric rating |
| `Number_of_reviews` | Comma-formatted strings | Cleaned and converted to numeric |
| `bought_in_last_month` | Text like `"6K+ bought in past month"` | Custom column parsing "K" notation into a numeric demand estimate (e.g. "6K+" → 6,000) |
| `Current/discounted_price`, `Listed_price` | Mixed `$` signs, and `"No Discount"` used as a text placeholder | Cleaned to numeric; invalid text converted to null |
| `is_best_seller` | One column mixing badge type, discount %, and countdown timers | Isolated a clean best-seller flag |
| `is_couponed` | Mixed coupon amounts and "No Coupon" text | Converted to a binary coupon flag |
| `sustainability_badges`, `image_url`, `product_url` | Largely unusable / not relevant to analysis | Removed |
| Duplicate rows | 962 exact duplicates | Removed |
| Rows with no price or demand figure | ~17,000 rows | Removed — can't analyse demand without both |

**Final clean dataset: 24,436 products.**

## 2. SQL Analysis
Full query set in [`analysis_queries.sql`](./analysis_queries.sql), including:
- Sponsored vs. organic listing comparison
- Demand by price band, using a window function (`RANK() OVER`) to rank bands by average demand
- Demand by rating band
- Coupon impact on demand and price
- Best-seller badge impact

## 3. Power BI Dashboard
Built in Power BI Desktop using Power Query for cleaning and DAX for calculated columns (price bands, rating bands). See [`Amazon_product_demand_ananysis.pbix`](./Amazon_product_demand_ananysis.pbix) for the interactive file, or the screenshot below:

![Dashboard](./Amazon_product_demand_analysis_dashboard%20.png)

## 4. Key Findings
- **Sponsored listings averaged ~5,436 monthly units bought vs. ~487 for organic listings — an 11x difference.** A very strong association with demand, though this data can't confirm causation on its own.
- **The $15–30 price band significantly outperforms every other band**, averaging ~3,024 monthly units vs. under 600 for anything priced above $30.
- **Counter-intuitively, coupon-flagged products had *lower* average demand than non-couponed products** — but they also carried a much higher average price, suggesting coupons are concentrated on already-expensive, lower-velocity items rather than driving volume.
- **Rating matters a lot at the top end**: products rated 4.5+ averaged over 3x the demand of products rated 4.0–4.49.
- **Best-seller badge products saw dramatically higher demand and review counts** — though this is likely partly circular, since the badge itself is awarded based on high sales.

## 5. Recommendation
The $15–30 price band and sponsored placement show the strongest association with demand, and look like more reliable levers than couponing, which appears concentrated on underperforming higher-price items rather than genuinely driving volume. Maintaining a rating above 4.5 is also clearly worth protecting, given the steep drop-off below that threshold. Any pricing or promotion strategy should ideally be tested with controlled, before/after data rather than cross-sectional averages alone, but this analysis provides a strong, evidence-based starting hypothesis.

## Tools Used
Excel & Power Query (data cleaning), SQL (analysis), Power BI (dashboard and visualisation).

## Files in this Repository
- `analysis_queries.sql` — full SQL query set
- `amazon_clean.csv` — final cleaned dataset
- `Amazon_product_demand_ananysis.pbix` — Power BI dashboard file
- `Amazon_product_demand_analysis_dashboard .png` — dashboard screenshot

