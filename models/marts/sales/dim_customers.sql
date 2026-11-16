with
    customers as (
        select * from {{ ref('int_sales__customers') }}
    )

select
    {{ dbt_utils.generate_surrogate_key(['customer_pk']) }} as customer_sk
    , customer_pk as customer_id
    , customer_name
    , customer_type
    , store_name
from customers
