# Competitive Benchmark: Price Segment & Cuisine Composition
# Compares cuisine composition across price segments in the Glovo marketplace  
# and identifies the price segment of Our Restaurant.

# Restaurant-level price segments
WITH
  restaurant_segments AS (
    SELECT DISTINCT
      restaurant_key,
      price_segment
    FROM `lviv-food-marketplace.lviv_food.glovo_marketplace`
  ),

# Restaurant count by price segment and cuisine
  segment_cuisines AS (
    SELECT
      rs.price_segment,
      gc.cuisine_tag,
      COUNT(DISTINCT gc.restaurant_key) AS restaurants
    FROM restaurant_segments rs
    JOIN `lviv-food-marketplace.lviv_food.glovo_cuisine` gc
      ON rs.restaurant_key = gc.restaurant_key
    GROUP BY rs.price_segment, gc.cuisine_tag
  ),

# Total restaurant count within each price segment
  segment_totals AS (
    SELECT
      price_segment,
      SUM(restaurants) AS total
    FROM segment_cuisines
    GROUP BY price_segment
  ),

# Our Restaurant average catalog price in UAH
  our_price AS (
    SELECT AVG(price_per_item * 59.6544) AS avg_price
    FROM (
      SELECT DISTINCT
        line_item_name,
        price_per_item
      FROM `lviv-food-marketplace.lviv_food.restaurant_sales`
    )
  ),

# Price boundaries based on Glovo restaurant-level median prices
  segment_bounds AS (
    SELECT
      APPROX_QUANTILES(median_price, 3)[OFFSET(1)] AS budget_upper,
      APPROX_QUANTILES(median_price, 3)[OFFSET(2)] AS midrange_upper
    FROM (
      SELECT DISTINCT
        restaurant_key,
        median_price
      FROM `lviv-food-marketplace.lviv_food.glovo_marketplace`
    )
  ),

# Assign Our Restaurant to a market price segment
  our_segment AS (
    SELECT
      CASE
        WHEN avg_price <= budget_upper THEN "Budget"
        WHEN avg_price <= midrange_upper THEN "Mid-range"
        ELSE "Premium"
      END AS our_price_segment
    FROM our_price, segment_bounds
  )

SELECT
  sc.price_segment,
  sc.cuisine_tag,
  sc.restaurants,
  ROUND(sc.restaurants / st.total * 100, 1) AS share_pct,
  (sc.price_segment = (
    SELECT our_price_segment
    FROM our_segment
  )) AS is_our_segment
FROM segment_cuisines sc
JOIN segment_totals st
  ON sc.price_segment = st.price_segment;
