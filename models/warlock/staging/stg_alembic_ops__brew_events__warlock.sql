with source as (

    select * from {{ source('alembic_ops', 'raw_brew_events') }}

),

renamed as (

    select
        trim(brew_id) as brew_id,
        trim(potion_sku) as potion_sku,
        trim(shop_id) as shop_id,
        trim(cauldron_id) as cauldron_id,
        coalesce(
            try_to_timestamp_ntz(brewed_at, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
            try_to_timestamp_ntz(brewed_at, 'YYYY-MM-DD HH24:MI:SS')
        ) as brewed_at,
        try_to_number(batch_size) as batch_size,
        try_to_number(brew_duration_minutes) as brew_duration_minutes,
        lower(trim(quality_check)) as quality_check,
        trim(brewer_name) as brewer_name
    from source

)

select * from renamed
