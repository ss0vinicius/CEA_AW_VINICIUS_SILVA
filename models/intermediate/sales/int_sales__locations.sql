-- grain: one row per address
with
    addresses as (
        select * from {{ ref('stg_sap_adw__address') }}
    )

    , states as (
        select * from {{ ref('stg_sap_adw__stateprovince') }}
    )

    , countries as (
        select * from {{ ref('stg_sap_adw__countryregion') }}
    )

    , joined as (
        select
            addresses.address_pk
            , addresses.city
            , states.state_province_code
            , states.state_province_name
            , countries.country_region_pk as country_region_code
            , countries.country_region_name as country_name
        from addresses
        left join states
            on addresses.state_province_fk = states.state_province_pk
        left join countries
            on states.country_region_fk = countries.country_region_pk
    )

select * from joined
