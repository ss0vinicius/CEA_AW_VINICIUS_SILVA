with
    source_productsubcategory as (
        select *
        from {{ source('sap_adw', 'productsubcategory') }}
    )

    , renamed as (
        select
            cast(productsubcategoryid as int) as product_subcategory_pk
            , cast(productcategoryid as int) as product_category_fk
            , cast(name as string) as product_subcategory_name
        from source_productsubcategory
    )

select * from renamed
