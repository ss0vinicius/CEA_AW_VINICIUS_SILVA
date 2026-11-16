select
    products.product_name
    , count(distinct sales.sales_order_id) as orders
    , round(sum(sales.net_amount), 2) as net_value
    , round(sum(sales.net_amount) / count(distinct sales.sales_order_id), 2) as average_ticket
from {{ ref('fct_sales') }} as sales
inner join {{ ref('dim_products') }} as products
    on sales.product_fk = products.product_sk
group by products.product_name
order by average_ticket desc
limit 10
