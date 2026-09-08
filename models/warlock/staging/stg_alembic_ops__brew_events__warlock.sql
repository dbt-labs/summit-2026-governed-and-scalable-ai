with source as (
    select * from {{ source('alembic_ops', 'raw_brew_events') }}
),

renamed as (
    select
        brew_id,
        potion_sku,
        shop_id,
        cauldron_id,
        batch_size::int as batch_size,
        brew_duration_minutes::int as brew_duration_minutes,
        lower(trim(quality_check)) as quality_check,
        brewer_name,
        brewed_at::timestamp_ntz as brewed_at
    from source
)

select * from renamed
