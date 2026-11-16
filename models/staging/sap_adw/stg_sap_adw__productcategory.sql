with
    source_productcategory as (
        select *
        from {{ source('sap_adw', 'productcategory') }}
    )

    , renamed as (
        select
            cast(productcategoryid as int) as product_category_pk
            , cast(name as string) as product_category_name
        from source_productcategory
    )

select * from renamed
