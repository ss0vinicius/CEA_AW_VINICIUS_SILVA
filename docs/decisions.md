# Decisions

Each decision records the context, the choice and its consequence.

## 1. Fact grain: one row per sales order line
- **Context:** a sale (`salesorderheader`) contains several products (`salesorderdetail`). Quantity, price and discount live on the line.
- **Decision:** `fct_sales` has one row per order line.
- **Consequence:** orders are counted with `count(distinct sales_order_id)`; order-level values (freight, tax, total due) stay out of the fact to avoid double counting.

## 2. Sales reasons through a bridge table
- **Context:** reasons are recorded per order, not per item (`salesorderheadersalesreason` has no product column). Measured on the source: of 31,465 orders, 8,453 (26.9%) have no reason, 18,530 (58.9%) have one, 4,329 have two and 153 have three. Joining reasons into the order lines inflated 2011 gross sales to 15,705,533.01, against the audited 12,646,112.16 (+24.2%).
- **Decision:** `bridge_sales_reasons` (one row per order and reason) links `dim_sales_reasons` to `fct_sales` through `sales_order_id`. `is_promotion_order` flags orders with at least one reason of type Promotion, computed with `distinct` so it adds no rows.
- **Consequence:** totals filtered by reason do not add up to the grand total, because one order can have several reasons. Results by reason read as "orders where this was one of the reasons", not as the cause of each item.

## 3. Card type as a degenerate attribute
- **Context:** an order has at most one card; card type is the only attribute needed.
- **Decision:** `card_type` lives in `fct_sales`; orders without a card are labeled "Not informed".
- **Consequence:** one less dimension and relationship; no rows dropped.

## 4. Order status decoded in staging
- **Decision:** status codes become labels: 1 In Process, 2 Approved, 3 Backordered, 4 Rejected, 5 Shipped, 6 Cancelled.

## 5. Geography from the ship-to address
- **Decision:** city, state and country come from `shiptoaddressid`, where the sale is delivered.

## 6. Net value formula corrected
- **Context:** the challenge dictionary defines net value as `unitprice * orderqty - (1 - discount)`.
- **Decision:** `net_amount = unit_price * order_qty * (1 - unit_price_discount)`; documented in the model YAML and the dashboard glossary.

## 7. Customer name follows the data dictionary
- **Decision:** `customer_name` is the person's first and last name; customers without a person fall back to the store name. `customer_type` tells individuals from stores.

## 8. Sensitive columns excluded at staging
- **Decision:** credit card numbers and street address lines are never selected; no analysis needs them.

## 9. Full calendar years in the date dimension
- **Decision:** `dim_dates` runs from January 1 of the first order year to December 31 of the last, so Power BI time intelligence works reliably.

## 10. Full refresh instead of incremental models
- **Context:** the sales tables are well under one million rows, the threshold the course gives for considering incremental loads.
- **Decision:** marts are rebuilt as tables on every run; incremental models are a next step only when volume requires them.

## 11. Source load defect repaired in staging (Namibia)
- **Context:** the source test `not_null` on `person_countryregion.countryregioncode` failed on one row: Namibia. Its ISO code is "NA", which the EL load read as a null marker. No state or province references the affected row.
- **Decision:** keep the source test as a warning (the raw layer cannot be changed) and restore "NA" in `stg_sap_adw__countryregion`; the staging key test (`unique`, `not_null`) proves the repair.
- **Consequence:** `dbt test --select source:*` reports 1 documented warning and no errors. The EL step should be fixed at the source (disable default null markers when reading files).

## 12. No source freshness check
- **Context:** the dataset is a static snapshot that ends in 2014.
- **Decision:** source freshness is not configured, because it would always fail; it is a production next step together with incremental ingestion.
