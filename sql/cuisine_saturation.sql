# Competitive Benchmark: Cuisine Saturation
# Compares the presence of Our Restaurant's cuisine with Lviv and Glovo competitors.

# Count Lviv restaurant competitors by cuisine
WITH
  lviv_counts AS (
    SELECT
      cuisine_tag,
      COUNT(DISTINCT place_id) AS lviv_restaurants
    FROM `lviv-food-marketplace.lviv_food.lviv_restaurant_market`
    GROUP BY cuisine_tag
  ),

# Count Glovo restaurant competitors by cuisine
  glovo_counts AS (
    SELECT
      cuisine_tag,
      COUNT(DISTINCT restaurant_key) AS glovo_restaurants
    FROM `lviv-food-marketplace.lviv_food.glovo_cuisine`
    WHERE cuisine_tag != 'cuisine_tag'
    GROUP BY cuisine_tag
  ),
  
  lviv_normalized AS (
    SELECT
      CASE
        WHEN LOWER(cuisine_tag) = 'kebab' THEN 'Kebab / Shawarma'
        ELSE cuisine_tag
        END AS cuisine_tag,
      lviv_restaurants
    FROM lviv_counts
  ),
  
  glovo_normalized AS (
    SELECT
      CASE
        WHEN LOWER(cuisine_tag) = 'kebab & shawarma' THEN 'Kebab / Shawarma'
        ELSE cuisine_tag
        END AS cuisine_tag,
      glovo_restaurants
    FROM glovo_counts
  ),

# Add Our Restaurant cuisine for comparison
  combined AS (
    SELECT
      COALESCE(l.cuisine_tag, g.cuisine_tag) AS cuisine,
      COALESCE(l.lviv_restaurants, 0) AS lviv_restaurants,
      COALESCE(g.glovo_restaurants, 0) AS glovo_restaurants
    FROM lviv_normalized l
    FULL OUTER JOIN glovo_normalized g
      ON LOWER(l.cuisine_tag) = LOWER(g.cuisine_tag)
  )
  
# Combine cuisine saturation metrics
SELECT
  cuisine,
  lviv_restaurants,
  glovo_restaurants,
  FALSE AS is_our_cuisine
FROM combined

UNION ALL

SELECT
  'West African / Nigerian',
  0,
  0,
  TRUE;
