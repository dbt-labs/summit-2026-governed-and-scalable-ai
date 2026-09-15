with source as (

    select * from {{ source('alembic_ops', 'raw_shops') }}

),

renamed as (

    select
        trim(shop_id) as shop_id,
        trim(shop_name) as shop_name,
        trim(city) as city,
        trim(region) as region,
        opened_at
    from source

)

select * from renamed
