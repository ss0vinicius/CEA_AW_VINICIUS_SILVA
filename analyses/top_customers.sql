select
    customers.customer_id
    , customers.customer_name
    , round(sum(sales.net_amount), 2) as net_value
from {{ ref('fct_sales') }} as sales
inner join {{ ref('dim_customers') }} as customers
    on sales.customer_fk = customers.customer_sk
group by customers.customer_id, customers.customer_name
order by net_value desc
limit 10
