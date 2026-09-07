# Competitive Benchmark: Category Concentration
# Compares revenue concentration within restaurant categories with the Glovo marketplace.

# Calculate Our Restaurant revenue by category and dish
WITH
  revenue_dish AS (
    SELECT
      category,
      line_item_name,
      SUM(gross_sales_uah) AS dish_revenue
    FROM `lviv-food-marketplace.lviv_food.restaurant_sales`
    GROUP BY category, line_item_name
  ),
  
  category_revenue AS (
    SELECT
      category,
      SUM(dish_revenue) AS category_total,
      COUNT(DISTINCT line_item_name) AS products_count
    FROM revenue_dish
    GROUP BY category
  ),
  ranked_dishes AS (
    SELECT
      d.category,
      d.line_item_name,
      c.products_count,
      ROUND(d.dish_revenue / c.category_total * 100, 1) AS share_pct,
      ROW_NUMBER()
        OVER (PARTITION BY d.category ORDER BY d.dish_revenue DESC) AS rnk
    FROM revenue_dish d
    JOIN category_revenue c
      USING (category)
  ),
  our_top_per_category AS (
    SELECT
      category,
      line_item_name,
      products_count,
      share_pct
    FROM ranked_dishes
    WHERE rnk = 1
  ),

# Calculate Glovo category concentration
  glovo_category_bestseller AS (
    SELECT
      menu_category_group,
      COUNT(*) AS products_count,
      ROUND(SUM(CAST(is_bestseller AS INT64)) / COUNT(*) * 100, 1)
        AS bestseller_share_pct
    FROM `lviv-food-marketplace.lviv_food.glovo_marketplace`
    GROUP BY menu_category_group
  )

# Combine category concentration metrics
SELECT
  'Our Restaurant' AS source,
  category AS category_group,
  line_item_name AS top_item,
  products_count,
  share_pct AS concentration_pct
FROM our_top_per_category

UNION ALL

SELECT
  'Glovo Market',
  menu_category_group,
  CAST(NULL AS STRING),
  products_count,
  bestseller_share_pct
FROM glovo_category_bestseller;
