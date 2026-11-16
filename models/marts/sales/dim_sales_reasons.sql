with
    sales_reasons as (
        select * from {{ ref('stg_sap_adw__salesreason') }}
    )

select
    {{ dbt_utils.generate_surrogate_key(['sales_reason_pk']) }} as sales_reason_sk
    , sales_reason_pk as sales_reason_id
    , sales_reason_name
    , sales_reason_type
from sales_reasons
