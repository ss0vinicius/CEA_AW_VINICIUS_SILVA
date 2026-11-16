with
    source_product as (
        select *
        from {{ source('sap_adw', 'product') }}
    )

    , renamed as (
        select
            cast(productid as int) as product_pk
            , cast(productsubcategoryid as int) as product_subcategory_fk
            , cast(name as string) as product_name
            , cast(productnumber as string) as product_number
            , cast(color as string) as color
            , cast(productline as string) as product_line
            , cast(standardcost as decimal(18,4)) as standard_cost
            , cast(listprice as decimal(18,4)) as list_price
        from source_product
    )

select * from renamed
