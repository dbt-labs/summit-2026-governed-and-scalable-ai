with source as (
    select * from {{ source('alembic_ops', 'raw_brew_events') }}
),

renamed as (
    select
        brew_id,
        potion_sku,
        shop_id,
        cauldron_id,
        lower(trim(quality_check)) as quality_check,
        brewer_name,
        batch_size::integer as batch_size,
        brew_duration_minutes::integer as brew_duration_minutes,
        brewed_at::timestamp_ntz as brewed_at
    from source
),

final as (
    select
        brew_id,
        potion_sku,
        shop_id,
        cauldron_id,
        quality_check,
        brewer_name,
        batch_size,
        brew_duration_minutes,
        brewed_at
    from renamed
)

select * from final
