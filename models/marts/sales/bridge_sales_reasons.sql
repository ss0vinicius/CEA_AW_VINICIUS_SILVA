-- grain: one row per sales order x sales reason (resolves the many-to-many)
with
    order_reasons as (
        select * from {{ ref('stg_sap_adw__salesorderheadersalesreason') }}
    )

select
    {{ dbt_utils.generate_surrogate_key(['sales_order_fk', 'sales_reason_fk']) }} as sales_order_reason_sk
    , sales_order_fk as sales_order_id
    , {{ dbt_utils.generate_surrogate_key(['sales_reason_fk']) }} as sales_reason_fk
from order_reasons
