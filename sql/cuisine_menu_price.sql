# Competitive Benchmark: Cuisine, Menu Size & Price
# Compares restaurant count, median menu size and median price by cuisine.

# Keep restaurant-level menu metrics to avoid item-level weighting
WITH
  glovo_restaurant_level AS (
    SELECT DISTINCT restaurant_key, menu_size, median_price
    FROM `lviv-food-marketplace.lviv_food.glovo_marketplace`
  ),

# Calculate cuisine-level market benchmarks
  cuisine_stats AS (
    SELECT
      c.cuisine_tag,
      COUNT(DISTINCT c.restaurant_key) AS restaurants,
      APPROX_QUANTILES(r.menu_size, 2)[OFFSET(1)] AS median_menu_size,
      ROUND(APPROX_QUANTILES(r.median_price, 2)[OFFSET(1)], 2) AS median_price
    FROM `lviv-food-marketplace.lviv_food.glovo_cuisine` c
    JOIN glovo_restaurant_level r
      ON c.restaurant_key = r.restaurant_key
    GROUP BY c.cuisine_tag
  ),
  
# Add Our Restaurant as a benchmark category
  our_restaurant AS (
    SELECT
      'West African (Our Restaurant)' AS cuisine_tag,
      1 AS restaurants,
      (
        SELECT COUNT(DISTINCT line_item_name)
        FROM `lviv-food-marketplace.lviv_food.restaurant_sales`
      ) AS median_menu_size,
      (
        SELECT ROUND(AVG(price_per_item * 59.6544), 2)
        FROM
          (
            SELECT DISTINCT line_item_name, price_per_item
            FROM `lviv-food-marketplace.lviv_food.restaurant_sales`
          )
      ) AS median_price
  )

# Combine market cuisines with Our Restaurant
SELECT
  cuisine_tag,
  restaurants,
  median_menu_size,
  median_price,
  FALSE AS is_our_restaurant
FROM cuisine_stats

UNION ALL

SELECT
  cuisine_tag,
  restaurants,
  median_menu_size,
  median_price,
  TRUE AS is_our_restaurant
FROM our_restaurant
