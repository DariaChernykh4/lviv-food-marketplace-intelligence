# Competitive Benchmark & Strategic Positioning
## Methodology Note
This section benchmarks an independent restaurant's operational data (Kaggle dataset, West African / Nigerian cuisine, UK-based, 2023–2025) against the Lviv food market (934 restaurants) and the Glovo delivery marketplace (234 restaurants, 15,898 menu items). Financial figures were converted from GBP to UAH at a fixed rate of 59.6544, and all comparisons are hosted in BigQuery as a set of SQL views built on top of the three Tableau-ready datasets.

## ! Important Note !
 
**This is a hypothetical market-entry exercise, not an analysis of an actual Lviv restaurant.** The restaurant used for comparison operates in a different country, on different delivery platforms (JustEat, Deliveroo - not Glovo), in a cuisine absent from both Lviv datasets. The project applies real market-positioning methodology to real operational data to ask *"how would this restaurant compare if it entered this market?"* - metrics without a genuine market equivalent (ratings, discounts, channel mix, profit margin) were deliberately excluded rather than forced into a misleading comparison.

---

## Key Findings

| Metric | Our Restaurant | Lviv Market / Glovo | Signal |
|---|---|---|---|
| Menu size | 62 items / 8 categories | 60 items / 7 categories (median) | In line with market norms |
| Catalog price | 491 UAH | 215 UAH (median) | **+128.5%** - Premium price segment |
| Operating window (recorded) | 5h/day, closed Sunday | 12h/day median, 92% open Sunday | **42%** of market availability |
| Cuisine competitors | 0 (West African / Nigerian) | 0 in both Lviv (934) and Glovo (234) datasets | **Blue-ocean** cuisine |
| Revenue concentration | 45% (single flagship dish) | 3.4% (avg. Glovo bestseller share) | **13.2x** more concentrated |

**Menu structure is close to market norms, but pricing is not.**

The restaurant's menu (62 unique dishes across 8 categories) sits almost exactly at the Glovo market median (60 items, 7 categories). However, the average menu price (491 UAH) is 128.5% higher than the Glovo average (215 UAH). This puts the restaurant in the Premium price group. Interestingly, the average price of items customers actually buy (322 UAH) is much lower. Customers choose cheaper items more often than expensive ones. The business should watch this difference if it wants to keep a premium strategy.

**The cuisine shows a genuine blue-ocean opportunity.** 

Zero restaurants tagged West African, Nigerian, or African cuisine were identified in either the Lviv market (934 restaurants, 46 cuisine types) or the Glovo marketplace (234 restaurants, 20 cuisine tags). This extends a pattern the Lviv Cuisine Competition Matrix already flagged for Asian, Italian, and Ukrainian cuisine - smaller segments with room to grow - to its most extreme case: a segment with no direct competitors at all.

**Recorded working hours are much shorter than the market norm.** 
In the dataset, people ordered food during only a 5-hour window each day. The Lviv average is 12 hours. Also, there are no orders on Sundays, while 92% of Lviv restaurants stay open that day. Please note that this is just recorded order time, not confirmed open hours. This difference might happen because the restaurant truly has short hours or because of how the data was collected.

**Revenue is heavily concentrated in a single flagship dish.** 

After excluding categories with fewer than five menu items (to avoid the trivial 100% concentration scores that tiny categories produce by construction), the single highest-concentration dish - Efo Riro, within the Soups category - brings in 45% of the money for that group. This is 13.2 times higher than the Glovo average (3.4%). This shows that the business relies too much on one product.

---

## Strategic Positioning
We can view this as a plan to enter a new market:
- **Premium positioning:** A premium strategy makes sense, but it is unproven. The high prices match other premium foods on Glovo (like Sushi or Italian). But we do not know if Lviv customers will actually pay these high prices for this specific food.
- **Underserved cuisine:** The missing food type is the restaurant's best advantage. It has zero competitors in this market. This is a true and rare difference, not just a marketing trick.
- **Availability gap:** The business can test growth by adding more hours. A 5-hour window and no Sunday work show that the restaurant could try working longer hours without changing the food or prices.
- **Product dependency:** Relying on one dish is a big risk. Since one item makes 45% of the category's money, the business depends too much on this single dish staying popular.

---

## Final Conclusion
The benchmark points to a **restaurant with a differentiated, premium-priced offer in a genuinely underserved cuisine niche**, whose main identified risks are limited recorded availability and unusually concentrated product revenue, rather than direct competitive pressure. If this restaurant were to position itself in the Lviv market, the clearest opportunity is the cuisine gap itself; the clearest risks to manage before scaling are the narrow operating window, absent Sunday trading, and dependence on a single flagship dish for a disproportionate share of revenue.

![Market Positioning](/dashboards/screenshots/04-Market-Positioning.png)
