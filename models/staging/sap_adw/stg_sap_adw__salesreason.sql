with
    source_salesreason as (
        select *
        from {{ source('sap_adw', 'salesreason') }}
    )

    , renamed as (
        select
            cast(salesreasonid as int) as sales_reason_pk
            , cast(name as string) as sales_reason_name
            , cast(reasontype as string) as sales_reason_type
        from source_salesreason
    )

select * from renamed
