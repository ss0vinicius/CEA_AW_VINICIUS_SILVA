with
    products as (
        select * from {{ ref('int_sales__products') }}
    )

select
    {{ dbt_utils.generate_surrogate_key(['product_pk']) }} as product_sk
    , product_pk as product_id
    , product_name
    , product_number
    , product_subcategory
    , product_category
    , color
    , list_price
from products
