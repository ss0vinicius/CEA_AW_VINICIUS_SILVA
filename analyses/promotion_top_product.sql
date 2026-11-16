select
    products.product_name
    , sum(sales.order_qty) as units
from {{ ref('fct_sales') }} as sales
inner join (
    select distinct bridge.sales_order_id
    from {{ ref('bridge_sales_reasons') }} as bridge
    inner join {{ ref('dim_sales_reasons') }} as reasons
        on bridge.sales_reason_fk = reasons.sales_reason_sk
    where reasons.sales_reason_name = 'On Promotion'
) as promotion_orders
    on sales.sales_order_id = promotion_orders.sales_order_id
inner join {{ ref('dim_products') }} as products
    on sales.product_fk = products.product_sk
group by products.product_name
order by units desc
limit 5
