select
    date_format(order_date, 'yyyy-MM') as year_month
    , count(distinct sales_order_id) as orders
    , sum(order_qty) as units
    , round(sum(net_amount), 2) as net_value
from {{ ref('fct_sales') }}
group by date_format(order_date, 'yyyy-MM')
order by year_month
