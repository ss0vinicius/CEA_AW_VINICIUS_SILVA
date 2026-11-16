-- grain: one row per customer
-- customer_name follows the data dictionary (person name); store customers without a person fall back to the store name
with
    customers as (
        select * from {{ ref('stg_sap_adw__customer') }}
    )

    , persons as (
        select * from {{ ref('stg_sap_adw__person') }}
    )

    , stores as (
        select * from {{ ref('stg_sap_adw__store') }}
    )

    , joined as (
        select
            customers.customer_pk
            , coalesce(
                persons.person_name
                , stores.store_name
                , concat('Customer ', cast(customers.customer_pk as string))
              ) as customer_name
            , case
                when customers.store_fk is not null then 'Store'
                else 'Individual'
              end as customer_type
            , stores.store_name
        from customers
        left join persons
            on customers.person_fk = persons.person_pk
        left join stores
            on customers.store_fk = stores.store_pk
    )

select * from joined
