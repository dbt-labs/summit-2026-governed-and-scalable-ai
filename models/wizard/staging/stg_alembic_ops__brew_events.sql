with source as (
    select * from {{ source('alembic_ops', 'raw_brew_events') }}
),

final as (
    select
        brew_id,
        potion_sku,
        shop_id,
        cauldron_id,
        brewer_name,
        lower(trim(quality_check)) as quality_check,
        batch_size::integer as batch_size,
        nullif(trim(brew_duration_minutes), '')::integer as brew_duration_minutes,
        brewed_at::timestamp_ntz as brewed_at
    from source
)

select * from final
