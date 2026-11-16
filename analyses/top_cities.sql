select
    locations.city
    , locations.state_province_name
    , locations.country_name
    , round(sum(sales.net_amount), 2) as net_value
from {{ ref('fct_sales') }} as sales
inner join {{ ref('dim_locations') }} as locations
    on sales.ship_to_address_fk = locations.location_sk
group by locations.city, locations.state_province_name, locations.country_name
order by net_value desc
limit 5
