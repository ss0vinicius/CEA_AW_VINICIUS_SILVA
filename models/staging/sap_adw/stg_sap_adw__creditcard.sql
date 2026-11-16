with
    source_creditcard as (
        select *
        from {{ source('sap_adw', 'creditcard') }}
    )

    , renamed as (
        select
            cast(creditcardid as int) as credit_card_pk
            , cast(cardtype as string) as card_type
        from source_creditcard
    )

select * from renamed
