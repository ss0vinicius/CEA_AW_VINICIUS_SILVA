with
    source_store as (
        select *
        from {{ source('sap_adw', 'store') }}
    )

    , renamed as (
        select
            cast(businessentityid as int) as store_pk
            , cast(name as string) as store_name
            , cast(salespersonid as int) as salesperson_fk
        from source_store
    )

select * from renamed
