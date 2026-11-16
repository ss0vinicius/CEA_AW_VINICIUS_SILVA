-- grain: one row per sales order line
with
    order_items as (
        select * from {{ ref('int_sales__order_items') }}
    )

    , final as (
        select
            {{ dbt_utils.generate_surrogate_key(['sales_order_detail_pk']) }} as sales_sk
            , sales_order_fk as sales_order_id
            , sales_order_detail_pk as sales_order_detail_id
            , {{ dbt_utils.generate_surrogate_key(['customer_fk']) }} as customer_fk
            , {{ dbt_utils.generate_surrogate_key(['product_fk']) }} as product_fk
            , {{ dbt_utils.generate_surrogate_key(['ship_to_address_fk']) }} as ship_to_address_fk
            , order_date
            , order_status
            , card_type
            , is_online_order
            , is_promotion_order
            , order_qty
            , unit_price
            , unit_price_discount
            , cast(unit_price * order_qty as decimal(18,4)) as gross_amount
            , cast(unit_price * order_qty * unit_price_discount as decimal(18,4)) as discount_amount
            , cast(unit_price * order_qty * (1 - unit_price_discount) as decimal(18,4)) as net_amount
        from order_items
    )

select * from final
