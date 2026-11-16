with
    source_salesorderheadersalesreason as (
        select *
        from {{ source('sap_adw', 'salesorderheadersalesreason') }}
    )

    , renamed as (
        select
            cast(salesorderid as int) as sales_order_fk
            , cast(salesreasonid as int) as sales_reason_fk
        from source_salesorderheadersalesreason
    )

select * from renamed
