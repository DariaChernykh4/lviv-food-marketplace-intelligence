# Lviv Food Marketplace Intelligence

## Market Positioning of a Delivery Restaurant in the Lviv Food Marketplace

A five-layer market intelligence project that moves from a full restaurant market, to its delivery marketplace, to a single independent restaurant, to a data-driven competitive benchmark - and finally to a strategic positioning thesis.
> **The market → The marketplace → Our restaurant → Competitive benchmark → Strategic recommendations**

---

## Project Narrative

The main business question: **how would a specific, real restaurant's operational data compare if it entered the Lviv food delivery market?**

The project is built in five layers:

| Layer | Question | Data |
|---|---|---|
| **1. [Lviv Food Market](notebooks/02_market_analysis/01_lviv_restaurant_market_intelligence.ipynb)** | How is the restaurant market structured across the city? | 934 restaurants, Google Maps + Glovo availability |
| **2. [Glovo Marketplace](notebooks/02_market_analysis/02_glovo_marketplace_intelligence.ipynb)** | How are restaurants positioned *within* the delivery platform? | 234 restaurants, 15,898 menu items |
| **3. [Our Restaurant](notebooks/02_market_analysis/03_restaurant_performance_analysis.ipynb)** | What does a real independent restaurant's operational data look like? | 4,385 transactions, 2023–2025 (Kaggle) |
| **4. [Competitive Benchmark](sql)** | How does that restaurant compare to the market, item by item? | SQL (BigQuery) joining Layers 1–3 |
| **5. [Strategic Positioning](docs/benchmark_summary.md)** | What should this restaurant actually do with that information? | Synthesis, not raw data |

---

## Key Findings

| Metric | Our Restaurant | Lviv Market / Glovo | Signal |
|---|---|---|---|
| Menu size | 62 items / 8 categories | 60 items / 7 categories (median) | In line with market norms |
| Catalog price | 491 UAH | 215 UAH (median) | **+128.5%** - Premium price segment |
| Operating window (recorded) | 5h/day, closed Sunday | 12h/day median, 92% open Sunday | **42%** of market availability |
| Cuisine competitors | 0 (West African / Nigerian) | 0 in both Lviv (934) and Glovo (234) datasets | **Blue-ocean** cuisine |
| Revenue concentration | 45% (single flagship dish) | 3.4% (avg. Glovo bestseller share) | **13.2x** more concentrated |

Full narrative write-up: [`docs/benchmark_summary.md`](docs/benchmark_summary.md)

---

## Live Dashboards

Four interconnected Tableau dashboards, one per layer of analysis:

1. **Lviv Restaurant Market Intelligence** - districts, cuisines, business models, delivery coverage
2. **Glovo Marketplace Intelligence** - menu categories, pricing, bestsellers, discounts
3. **Our Restaurant - Performance & Operations** - sales trends, menu performance, channel mix, profitability
4. **Competitive Benchmark & Strategic Positioning** - our restaurant vs. market, side by side

*(Tableau Public links: see [`dashboards/tableau_public_links.md`](dashboards/tableau_public_links.md))*

---

## Repository Structure

```
notebooks/
├── 01_data_cleaning/        # Raw Google Maps + Glovo data = analysis-ready
├── 02_market_analysis/      # Lviv market EDA + Glovo marketplace EDA
└── 03_benchmark/            # Restaurant Performance Analysis (Kaggle dataset)

sql/
├── benchmark_queries.sql    # BigQuery views: Layer 4 metrics
└── diagnostics/             # Data-quality checks run during development

dashboards/
├── screenshots/             # Static previews of all 4 dashboard pages
└── tableau_public_links.md

docs/
└── layer4_5_summary.md      # Written findings for Layers 4–5
```

---

## Tech Stack

- **Python** - pandas, numpy, matplotlib, seaborn, geopandas, osmnx (spatial filtering of Lviv districts)
- **SQL** - Google BigQuery (benchmark layer: CTEs, window functions, cross-dataset joins)
- **Tableau** - 4-page interactive dashboard suite

---
 
## Methodology & Data Sources
 
- **Lviv restaurant market**: Google Maps data, enriched with Glovo availability, cleaned and feature-engineered (district assignment via spatial join against OpenStreetMap boundaries, Bayesian Rating, cuisine/business-model classification).
- **Glovo marketplace**: Parsed Glovo menu pages, cleaned and standardized (rating parsing, 750 raw menu categories consolidated into 37 analytical groups, cuisine translation).
- **Our restaurant**: [Kaggle - Small Restaurant Multi-Channel Data(2023-2025)](https://www.kaggle.com/datasets/omotayokupx/uk-small-restaurant-multi-channel-data), an independent West African / Nigerian restaurant operating in the UK, 2023–2025. Currency converted from GBP to UAH at a fixed rate (59.6544) for comparability.

## ! Important Note !
 
**The benchmark in Layer 4–5 is a hypothetical market-entry exercise, not an analysis of an actual Lviv restaurant.** The restaurant used for comparison operates in a different country, on different delivery platforms (JustEat, Deliveroo - not Glovo), in a cuisine absent from both Lviv datasets. The project applies real market-positioning methodology to real operational data to ask *"how would this restaurant compare if it entered this market?"* - metrics without a genuine market equivalent (ratings, discounts, channel mix, profit margin) were deliberately excluded rather than forced into a misleading comparison.

---

## Data Availability
 
Raw and cleaned datasets are **not redistributed in this repository**, as the underlying data was collected via web scraping of Google Maps and Glovo and is subject to those platforms' Terms of Service. The full data-cleaning and analysis pipeline is available in `notebooks/` for methodological review and reproducibility with your own data access. The Kaggle dataset used in Layer 3 is publicly available at its original source (linked above).
 
---
 
## Author
 
Built by Daria Chernykh as an end-to-end portfolio project spanning data cleaning, exploratory analysis, SQL, and dashboard design.
