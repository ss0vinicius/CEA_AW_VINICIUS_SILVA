select round(sum(gross_amount), 2) as gross_sales_2011
from {{ ref('fct_sales') }}
where year(order_date) = 2011
