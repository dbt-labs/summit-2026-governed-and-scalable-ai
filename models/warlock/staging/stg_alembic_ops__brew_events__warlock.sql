with source as (

    select * from {{ source('alembic_ops', 'raw_brew_events') }}

),

renamed as (

    select
        trim(brew_id) as brew_id,
        trim(potion_sku) as potion_sku,
        trim(shop_id) as shop_id,
        trim(cauldron_id) as cauldron_id,
        try_to_timestamp_ntz(brewed_at) as brewed_at,
        try_to_number(batch_size)::number(18, 0) as batch_size,
        try_to_number(brew_duration_minutes)::number(18, 0) as brew_duration_minutes,
        lower(trim(quality_check)) as quality_check,
        trim(brewer_name) as brewer_name
    from source

)

select * from renamed
