with source as (

    select * from {{ source('alembic_ops', 'raw_shops') }}

),

renamed as (

    select
        shop_id,
        shop_name,
        city,
        region,
        opened_at::date as opened_at
    from source

),

final as (

    select * from renamed

)

select * from final
