with
    source_stateprovince as (
        select *
        from {{ source('sap_adw', 'stateprovince') }}
    )

    , renamed as (
        select
            cast(stateprovinceid as int) as state_province_pk
            , cast(stateprovincecode as string) as state_province_code
            , cast(countryregioncode as string) as country_region_fk
            , cast(name as string) as state_province_name
        from source_stateprovince
    )

select * from renamed
