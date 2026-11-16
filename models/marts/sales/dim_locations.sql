with
    locations as (
        select * from {{ ref('int_sales__locations') }}
    )

select
    {{ dbt_utils.generate_surrogate_key(['address_pk']) }} as location_sk
    , address_pk as address_id
    , city
    , state_province_code
    , state_province_name
    , country_region_code
    , country_name
from locations
