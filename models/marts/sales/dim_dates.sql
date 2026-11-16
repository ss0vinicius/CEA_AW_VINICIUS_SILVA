-- grain: one row per calendar day, from January 1 of the first order year to December 31 of the last
-- full years keep Power BI time intelligence (year to date, same period last year) reliable
with
    order_dates as (
        select
            make_date(year(min(order_date)), 1, 1) as min_date
            , make_date(year(max(order_date)), 12, 31) as max_date
        from {{ ref('stg_sap_adw__salesorderheader') }}
    )

    , days as (
        select explode(sequence(min_date, max_date, interval 1 day)) as date_day
        from order_dates
    )

select
    date_day
    , year(date_day) as year
    , case when month(date_day) <= 6 then 1 else 2 end as semester
    , concat(cast(year(date_day) as string), '-S', case when month(date_day) <= 6 then '1' else '2' end) as year_semester
    , quarter(date_day) as quarter
    , concat(cast(year(date_day) as string), '-Q', cast(quarter(date_day) as string)) as year_quarter
    , month(date_day) as month
    , date_format(date_day, 'MMMM') as month_name
    , case month(date_day)
        when 1 then 'Janeiro'
        when 2 then 'Fevereiro'
        when 3 then 'Março'
        when 4 then 'Abril'
        when 5 then 'Maio'
        when 6 then 'Junho'
        when 7 then 'Julho'
        when 8 then 'Agosto'
        when 9 then 'Setembro'
        when 10 then 'Outubro'
        when 11 then 'Novembro'
        when 12 then 'Dezembro'
      end as month_name_pt
    , date_format(date_day, 'yyyy-MM') as year_month
    , cast(date_trunc('month', date_day) as date) as month_start_date
    , weekofyear(date_day) as week_of_year
    , cast(date_trunc('week', date_day) as date) as week_start_date
    , day(date_day) as day_of_month
    , dayofweek(date_day) as day_of_week
    , date_format(date_day, 'EEEE') as day_name
    , case dayofweek(date_day)
        when 1 then 'Domingo'
        when 2 then 'Segunda-feira'
        when 3 then 'Terça-feira'
        when 4 then 'Quarta-feira'
        when 5 then 'Quinta-feira'
        when 6 then 'Sexta-feira'
        when 7 then 'Sábado'
      end as day_name_pt
    , dayofweek(date_day) in (1, 7) as is_weekend
from days
