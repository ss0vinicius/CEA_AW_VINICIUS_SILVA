with
    source_salesorderdetail as (
        select *
        from {{ source('sap_adw', 'salesorderdetail') }}
    )

    , renamed as (
        select
            cast(salesorderdetailid as int) as sales_order_detail_pk
            , cast(salesorderid as int) as sales_order_fk
            , cast(productid as int) as product_fk
            , cast(specialofferid as int) as special_offer_fk
            , cast(orderqty as int) as order_qty
            , cast(unitprice as decimal(18,4)) as unit_price
            , cast(unitpricediscount as decimal(18,4)) as unit_price_discount
        from source_salesorderdetail
    )

select * from renamed
