# theLook eCommerce: Customer Insights & Cross-Sell Opportunity Modeling

## Project Overview

This project explores customer engagement and product performance using the [Looker E-Commerce Dataset (BigQuery Public Data)](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce). It simulates the kind of work an Analytics Engineer might do at a product-led company: building clean, modular data models that support customer segmentation, behavioral analytics, and revenue opportunity insights.

The project is structured in a dbt-style workflow, using BigQuery and modular SQL files grouped into staging, intermediate, and mart layers.

---

## Objective

**Goal**: Identify high-value customer segments based on behavioral engagement patterns and estimate potential revenue impact of targeted cross-sell strategies.

This includes:
- Building a reusable customer metrics mart
- Analyzing product-level views, purchases, and returns
- Flagging user-product pairs that represent missed revenue opportunities

---

## Project Structure

The project follows a layered modeling pattern:

<pre>
models/
├── staging/
│   ├── stg_users.sql
│   ├── stg_orders.sql
│   ├── stg_order_items.sql
│   ├── stg_products.sql
│   └── stg_events.sql
├── intermediate/
│   ├── user_orders.sql
│   ├── user_events.sql
│   ├── order_items_enriched.sql
│   └── event_product_views.sql
└── marts/
    ├── customer_metrics.sql
    ├── product_performance.sql
    └── cross_sell_candidates.sql
</pre>

---

## Final Models (Marts)

### `customer_metrics.sql`
One row per user with behavioral and transactional metrics including total events, sessions, orders, revenue, product diversity, and recency.

### `product_performance.sql`
One row per product with metrics for views, purchases, revenue, profit, conversion rate, and return rate.

### `cross_sell_candidates.sql`
One row per user-product pair where the user viewed a product but did not purchase it. Includes product metadata, view timestamps, and estimated lost revenue.

---

## Key Tools & Technologies
- **SQL** (modular, production-style)
- **BigQuery** (for execution and storage)
- **GitHub** (version control and repo structure)
- **dbt-style naming conventions and layering**, though no dbt was used directly

---

## Potential Next Steps
- Build a simple dashboard (Streamlit or Looker-style) to visualize results
- Add segmentation logic (RFM tiers, high/medium/low engagement)
- Migrate to **dbt Cloud** for documentation, lineage, and testing
- Add BigQuery ML to predict likelihood of purchase based on behavior

---

## About Me

I'm currently a Solutions Advisor and Data Scientist at SAS, working in the Risk, Fraud & Compliance division. While my day-to-day role focuses on analytics, performance testing, and translating technical findings for business users, I’m also expanding my skillset into the analytics engineering and data engineering space.

This personal project is part of that growth — designed to give me hands-on experience with modern data modeling workflows, dbt-style conventions, and behavioral event data at scale. My goal is to strengthen my ability to build scalable data pipelines and support product-led growth teams with high-quality, actionable insights.
