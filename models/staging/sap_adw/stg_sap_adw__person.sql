with
    source_person as (
        select *
        from {{ source('sap_adw', 'person') }}
    )

    , renamed as (
        select
            cast(businessentityid as int) as person_pk
            , cast(persontype as string) as person_type
            , cast(firstname as string) as first_name
            , cast(lastname as string) as last_name
            , concat_ws(' ', firstname, lastname) as person_name
        from source_person
    )

select * from renamed
