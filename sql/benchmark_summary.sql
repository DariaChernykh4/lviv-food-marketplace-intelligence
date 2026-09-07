# Competitive Benchmark Summary
# Compares Our Restaurant with the Lviv food market and Glovo marketplace.

# Calculate revenue concentration by dish
WITH
  revenue_dish AS (
    SELECT
      category,
      line_item_name,
      SUM(gross_sales_uah) AS dish_revenue
    FROM `lviv-food-marketplace.lviv_food.restaurant_sales`
    GROUP BY category, line_item_name
  ),
  
# Calculate category totals and product counts
  revenue_category AS (
    SELECT
      category,
      SUM(dish_revenue) AS category_total,
      COUNT(DISTINCT line_item_name) AS products_count
    FROM revenue_dish
    GROUP BY category
  ),
  
# Identify the most concentrated flagship dish
  flagship AS (
    SELECT
      line_item_name AS best_dish,
      ROUND(d.dish_revenue / c.category_total * 100, 1) AS share_pct
    FROM revenue_dish d
    JOIN revenue_category c
      USING (category)
    WHERE c.products_count >= 5
    ORDER BY share_pct DESC
    LIMIT 1
  ),
  
# Calculate Our Restaurant menu, pricing and operating window
  our_rest AS (
    SELECT
      COUNT(DISTINCT line_item_name) AS menu_items,
      COUNT(DISTINCT category) AS menu_categories,
      ROUND(SUM(gross_sales_uah) / SUM(quantity), 2) AS avg_selling_price,
      MAX(hour) - MIN(hour) + 1 AS window_hours,
      MAX(IF(day_of_week = "Sunday", 1, 0)) AS sunday_open
    FROM `lviv-food-marketplace.lviv_food.restaurant_sales`
  ),
  
# Calculate average catalog price in UAH
  our_catalog AS (
    SELECT
      AVG(price_per_item * 59.6544) AS avg_catalog_price
    FROM
      (
        SELECT DISTINCT
          line_item_name,
          price_per_item
        FROM `lviv-food-marketplace.lviv_food.restaurant_sales`
      )
  ),
  
# Aggregate Glovo metrics at restaurant level
  glovo_rest_level AS (
    SELECT
      restaurant_key,
      ANY_VALUE(menu_size) AS menu_size,
      ANY_VALUE(median_price) AS median_price,
      COUNT(DISTINCT menu_category_group) AS menu_categories
    FROM `lviv-food-marketplace.lviv_food.glovo_marketplace`
    GROUP BY restaurant_key
  ),
  
# Calculate market-level median benchmarks and price segment boundaries
  market AS (
    SELECT
      APPROX_QUANTILES(menu_size, 2)[OFFSET(1)] AS median_menu_size,
      APPROX_QUANTILES(menu_categories, 2)[OFFSET(1)] AS median_menu_categories,
      APPROX_QUANTILES(median_price, 2)[OFFSET(1)] AS median_price,
      APPROX_QUANTILES(median_price, 3)[OFFSET(1)] AS budget_upper,
      APPROX_QUANTILES(median_price, 3)[OFFSET(2)] AS midrange_upper
    FROM glovo_rest_level
  ),
  
# Calculate Glovo bestseller share
  market_bestseller AS (
    SELECT
      ROUND(AVG(CAST(is_bestseller AS INT64)) * 100, 1)
        AS bestseller_share_pct
    FROM `lviv-food-marketplace.lviv_food.glovo_marketplace`
  ),

# Calculate median operating hours in the Lviv market
  market_hours AS (
    SELECT
      APPROX_QUANTILES(opening_duration_hours, 2)[OFFSET(1)] AS median_hours,
      ROUND(AVG(closed_on_sunday_int) * 100, 1) AS pct_closed_sunday
    FROM
      (
        SELECT DISTINCT
          place_id,
          opening_duration_hours,
          closed_on_sunday_int
        FROM `lviv-food-marketplace.lviv_food.lviv_restaurant_market`
      )
  ),

# Check cuisine competitors in Lviv and Glovo
  cuisine_check AS (
    SELECT
      (
        SELECT COUNT(DISTINCT place_id)
        FROM `lviv-food-marketplace.lviv_food.lviv_restaurant_market`
        WHERE
          LOWER(cuisine_tag)
          IN ("west african", "nigerian", "african")
      ) AS lviv_competitors,
      (
        SELECT COUNT(DISTINCT restaurant_key)
        FROM `lviv-food-marketplace.lviv_food.glovo_cuisine`
        WHERE
          LOWER(cuisine_tag)
          IN ("west african", "nigerian", "african")
      ) AS glovo_competitors
  )

# Combine benchmark metrics into a single comparison table
SELECT
  "Menu size (items)" AS metric,
  CAST(menu_items AS STRING) AS our_restaurant_value,
  CAST(ROUND(median_menu_size, 0) AS STRING) AS market_value
FROM our_rest, market
UNION ALL
SELECT
  "Menu categories",
  CAST(menu_categories AS STRING),
  CAST(ROUND(median_menu_categories, 0) AS STRING)
FROM our_rest, market
UNION ALL
SELECT
  "Avg catalog price (UAH)",
  CAST(ROUND(avg_catalog_price, 0) AS STRING),
  CAST(ROUND(median_price, 0) AS STRING)
FROM our_catalog, market
UNION ALL
SELECT
  "Avg selling price (UAH)",
  CAST(ROUND(avg_selling_price, 0) AS STRING),
  "-"
FROM our_rest
UNION ALL
SELECT
  "Operating window",
  CAST(window_hours AS STRING),
  CAST(ROUND(median_hours, 1) AS STRING)
FROM our_rest, market_hours
UNION ALL
SELECT
  "Sunday availability",
  CASE WHEN sunday_open = 1 THEN "Open" ELSE "Closed" END,
  CONCAT(CAST(ROUND(100 - pct_closed_sunday, 0) AS STRING), "% of market restaurants open")
FROM our_rest, market_hours
UNION ALL
SELECT
  "Price segment",
  CASE
    WHEN avg_catalog_price <= budget_upper THEN "Budget"
    WHEN avg_catalog_price <= midrange_upper THEN "Mid-range"
    ELSE "Premium"
    END,
  "Budget / Mid-range / Premium (terciles)"
FROM our_catalog, market
UNION ALL
SELECT
  "Cuisine competitors",
  CAST(lviv_competitors AS STRING),
  CAST(glovo_competitors AS STRING)
FROM cuisine_check
UNION ALL
SELECT
  "Top dish revenue share (%)",
  CAST(share_pct AS STRING),
  CONCAT(CAST(bestseller_share_pct AS STRING), " (Glovo bestseller share)")
FROM flagship, market_bestseller
UNION ALL
SELECT
  "% of market operating hours",
  CONCAT(CAST(ROUND(window_hours / median_hours * 100, 0) AS STRING), "%"),
  "100% (market baseline)"
FROM our_rest, market_hours
UNION ALL
SELECT
  "Revenue concentration ratio (x market)",
  CONCAT(CAST(ROUND(share_pct / bestseller_share_pct, 1) AS STRING), "x"),
  "1x (market baseline)"
FROM flagship, market_bestseller
UNION ALL
SELECT
  "Price gap vs market (%)",
  CONCAT(
    CAST(
      ROUND((avg_catalog_price - median_price) / median_price * 100, 1)
      AS STRING),
    "%"),
  "0% (market baseline)"
FROM our_catalog, market;
