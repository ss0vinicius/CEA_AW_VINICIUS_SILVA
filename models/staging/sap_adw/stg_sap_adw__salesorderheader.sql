with
    source_salesorderheader as (
        select *
        from {{ source('sap_adw', 'salesorderheader') }}
    )

    , renamed as (
        select
            cast(salesorderid as int) as sales_order_pk
            , cast(customerid as int) as customer_fk
            , cast(salespersonid as int) as salesperson_fk
            , cast(territoryid as int) as territory_fk
            , cast(billtoaddressid as int) as bill_to_address_fk
            , cast(shiptoaddressid as int) as ship_to_address_fk
            , cast(creditcardid as int) as credit_card_fk
            , cast(orderdate as date) as order_date
            , cast(duedate as date) as due_date
            , cast(shipdate as date) as ship_date
            , cast(status as int) as order_status_code
            , case cast(status as int)
                when 1 then 'In Process'
                when 2 then 'Approved'
                when 3 then 'Backordered'
                when 4 then 'Rejected'
                when 5 then 'Shipped'
                when 6 then 'Cancelled'
                else 'Unknown'
              end as order_status
            , cast(onlineorderflag as boolean) as is_online_order
            , cast(subtotal as decimal(18,4)) as subtotal
            , cast(taxamt as decimal(18,4)) as tax_amount
            , cast(freight as decimal(18,4)) as freight
            , cast(totaldue as decimal(18,4)) as total_due
        from source_salesorderheader
    )

select * from renamed
