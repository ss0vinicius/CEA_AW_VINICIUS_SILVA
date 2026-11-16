with
    source_countryregion as (
        select *
        from {{ source('sap_adw', 'countryregion') }}
    )

    , renamed as (
        select
            -- the EL load read Namibia's ISO code "NA" as null; restore it
            coalesce(
                cast(countryregioncode as string)
                , case when name = 'Namibia' then 'NA' end
            ) as country_region_pk
            , cast(name as string) as country_region_name
        from source_countryregion
    )

select * from renamed
