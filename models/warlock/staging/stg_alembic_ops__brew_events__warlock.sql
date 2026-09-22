with source as (

    select * from {{ source('alembic_ops', 'raw_brew_events') }}

),

renamed as (

    select
        brew_id,
        potion_sku,
        shop_id,
        cauldron_id,
        try_to_timestamp_ntz(brewed_at) as brewed_at,
        try_to_number(batch_size)::integer as batch_size,
        try_to_number(brew_duration_minutes)::integer as brew_duration_minutes,
        lower(quality_check) as quality_check,
        brewer_name
    from source

),

final as (

    select * from renamed

)

select * from final
