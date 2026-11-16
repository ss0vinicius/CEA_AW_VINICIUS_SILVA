-- grain: one row per product
with
    products as (
        select * from {{ ref('stg_sap_adw__product') }}
    )

    , subcategories as (
        select * from {{ ref('stg_sap_adw__productsubcategory') }}
    )

    , categories as (
        select * from {{ ref('stg_sap_adw__productcategory') }}
    )

    , joined as (
        select
            products.product_pk
            , products.product_name
            , products.product_number
            , coalesce(subcategories.product_subcategory_name, 'Not informed') as product_subcategory
            , coalesce(categories.product_category_name, 'Not informed') as product_category
            , products.color
            , products.list_price
        from products
        left join subcategories
            on products.product_subcategory_fk = subcategories.product_subcategory_pk
        left join categories
            on subcategories.product_category_fk = categories.product_category_pk
    )

select * from joined
