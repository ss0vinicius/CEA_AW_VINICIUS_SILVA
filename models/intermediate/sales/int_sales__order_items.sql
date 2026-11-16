-- grain: one row per sales order line (salesorderdetail)
with
    order_details as (
        select * from {{ ref('stg_sap_adw__salesorderdetail') }}
    )

    , order_headers as (
        select * from {{ ref('stg_sap_adw__salesorderheader') }}
    )

    , credit_cards as (
        select * from {{ ref('stg_sap_adw__creditcard') }}
    )

    , order_reasons as (
        select * from {{ ref('stg_sap_adw__salesorderheadersalesreason') }}
    )

    , sales_reasons as (
        select * from {{ ref('stg_sap_adw__salesreason') }}
    )

    -- one row per order with at least one reason of type 'Promotion' (distinct, so no fan-out)
    -- verify the value with: select * from salesreason
    , promotion_orders as (
        select distinct order_reasons.sales_order_fk
        from order_reasons
        inner join sales_reasons
            on order_reasons.sales_reason_fk = sales_reasons.sales_reason_pk
        where sales_reasons.sales_reason_type = 'Promotion'
    )

    , joined as (
        select
            order_details.sales_order_detail_pk
            , order_details.sales_order_fk
            , order_headers.customer_fk
            , order_details.product_fk
            , order_headers.ship_to_address_fk
            , order_headers.order_date
            , order_headers.order_status
            , order_headers.is_online_order
            , coalesce(credit_cards.card_type, 'Not informed') as card_type
            , promotion_orders.sales_order_fk is not null as is_promotion_order
            , order_details.order_qty
            , order_details.unit_price
            , order_details.unit_price_discount
        from order_details
        inner join order_headers
            on order_details.sales_order_fk = order_headers.sales_order_pk
        left join credit_cards
            on order_headers.credit_card_fk = credit_cards.credit_card_pk
        left join promotion_orders
            on order_details.sales_order_fk = promotion_orders.sales_order_fk
    )

select * from joined
