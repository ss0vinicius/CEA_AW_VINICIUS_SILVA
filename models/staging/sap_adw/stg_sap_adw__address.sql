with
    source_address as (
        select *
        from {{ source('sap_adw', 'address') }}
    )

    , renamed as (
        select
            cast(addressid as int) as address_pk
            , cast(stateprovinceid as int) as state_province_fk
            , cast(city as string) as city
            , cast(postalcode as string) as postal_code
        from source_address
    )

select * from renamed
