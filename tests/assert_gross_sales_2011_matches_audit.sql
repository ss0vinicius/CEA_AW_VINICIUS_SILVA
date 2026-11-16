with
    gross_sales_2011 as (
        select round(sum(gross_amount), 2) as gross_sales
        from {{ ref('fct_sales') }}
        where year(order_date) = 2011
    )

select *
from gross_sales_2011
where gross_sales <> 12646112.16
