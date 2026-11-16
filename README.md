# Adventure Works Sales Data Warehouse

Analytics Engineering certification project (Indicium AI Academy). A Modern Analytics Stack for Adventure Works, a bicycle manufacturer: Databricks for storage and compute, dbt for transformation, tests and documentation, and Power BI for self-service analysis.

## Business context

- **Goal:** give the Commercial area trustworthy, self-service sales analytics, so business users answer their own questions without SQL or IT support.
- **Sponsors:** Innovation Director (project champion) and CEO. Main user: Commercial Director.
- **Acceptance criterion (CEO):** gross sales for 2011 must match the accounting audit, **$12,646,112.16**. All monetary values are in US dollars.

## Architecture

```
PostgreSQL ERP (SAP)
  -> raw: fea_academy.adventure_works      (landed by the EL step, declared as dbt sources)
  -> staging: stg_sap_adw__*               (views: rename, cast, decode)
  -> intermediate: int_sales__*            (views: joins, flags)
  -> marts: dim_*, fct_sales, bridge_*     (tables: star schema, documented and tested)
  -> Power BI (Import mode) and AI consumers (Unity Catalog comments)
```

Stack: Databricks (Unity Catalog, SQL warehouse), dbt with `dbt_utils`, GitHub, Power BI.

## Data model (sales mart)

| Model | Grain | Purpose |
| --- | --- | --- |
| `fct_sales` | one row per sales order line | quantity, gross, discount and net amounts; order status, card type, channel and promotion flag as degenerate attributes |
| `dim_customers` | one row per customer | customer name and type (individual or store) |
| `dim_products` | one row per product | product, subcategory, category |
| `dim_locations` | one row per address | city, state or province, country (ship-to address) |
| `dim_dates` | one row per day, full calendar years | year, quarter, month (English and Portuguese names) |
| `dim_sales_reasons` | one row per sales reason | reason name and type |
| `bridge_sales_reasons` | one row per order and reason | resolves the many-to-many between orders and reasons |

Metric definitions:

- `gross_amount = unit_price * order_qty`
- `discount_amount = unit_price * order_qty * unit_price_discount`
- `net_amount = unit_price * order_qty * (1 - unit_price_discount)` (the challenge dictionary writes `- (1 - discount)`, a typo corrected here)
- Average ticket = net amount / distinct orders

The conceptual model diagram is part of the delivery package.

## Key decisions

See [docs/decisions.md](docs/decisions.md). In short: order-line grain; sales reasons through a bridge (measured, not assumed); card type kept in the fact; ship-to geography; sensitive columns (card numbers, street lines) excluded at staging.

## Data quality

- **Source tests (57):** unique and not null on every source primary key; referential integrity between source tables; valid status codes; quantity, price and discount ranges; unique combination on the order and reason link.
- **Model tests:** unique and not null on every primary key; relationships from the fact to each dimension; accepted values on order status; `net_amount <= gross_amount`.
- **Audit test:** `tests/assert_gross_sales_2011_matches_audit.sql` asserts 2011 gross sales = 12,646,112.16.
- **Exploratory findings that shaped the model:**
  - 31,465 orders and 121,317 order lines (about 3.9 lines per order); staging keeps both counts exactly.
  - Every order has status 5 (Shipped). The status filter exists as requested and the decode is tested for all six codes.
  - 26.9% of orders have no sales reason, 58.9% have one, 14.2% have two or three.
  - 1,131 orders (3.6%) have no credit card; they are kept and labeled "Not informed".
  - The intermediate layer reproduces the audited 2011 gross sales (12,646,112.16) and flags 3,515 promotion orders, matching the source exactly.
  - Joining reasons straight into the order lines would inflate 2011 gross sales to 15,705,533.01 (+24.2% vs the audit).
- **Load defect caught by source tests:** Namibia's ISO code "NA" arrived as null (read as a null marker by the load). The source test is kept as a documented warning and the value is restored in staging.
- **Answer key (`analyses/`):** SQL answers to the business questions, independent of the dashboard, used to reconcile every page:

  | File | Question |
  | --- | --- |
  | `audit_2011_gross_sales.sql` | 2011 gross sales vs the audit |
  | `top_products_ticket.sql` | 4b: products with the highest average ticket |
  | `top_customers.sql` | 4c: top 10 customers |
  | `top_cities.sql` | 4d: top 5 cities |
  | `monthly_series.sql` | 4e: orders, quantity and value by month |
  | `promotion_top_product.sql` | 4f: top product for the Promotion reason |

## How to run

```bash
dbt deps                       # install dbt_utils
dbt build                      # build and test all models
dbt test --select source:*     # source tests only
dbt docs generate              # documentation site (dbt Core)
```

Mart descriptions are also persisted to Databricks as table and column comments (`persist_docs`).

## Project structure

```
models/
  staging/sap_adw/        sources, staging models and their YAML
  intermediate/sales/     joins at order-line grain, customers, products, locations
  marts/sales/            star schema and documentation
tests/                    singular tests (2011 audit)
analyses/                 answer key for dashboard reconciliation
docs/                     decisions and AI readiness
```

## Dashboard

Power BI, Import mode, labels in Portuguese for the client:

| Page | Answers |
| --- | --- |
| Visão Geral | KPIs and monthly series of orders, quantity and value |
| Análise de Vendas | orders, quantity and value by product, card type, reason, date, customer, status, city, state, country |
| Produtos | products with the highest average ticket; top product for the Promotion reason |
| Clientes e Cidades | top 10 customers, top 5 cities |
| Confiabilidade dos Dados | 2011 audit reconciliation |
| Glossário | metric definitions and caveats |

## AI readiness

Mart tables and columns are documented in dbt and persisted as Unity Catalog comments, so Databricks Genie, an MCP server or an LLM can read what each column means. See [docs/ai_readiness.md](docs/ai_readiness.md).

## Next steps

- Incremental, daily ingestion from the ERP (by `modifieddate`), then a scheduled dbt job running `dbt build`, then a scheduled Power BI refresh.
- `dbt source freshness` alerts on the raw layer.
- Gross margin using historical product cost (`productcosthistory`).
- Salesperson quota attainment and customer retention.

## Links

- Presentation video: <add link>
