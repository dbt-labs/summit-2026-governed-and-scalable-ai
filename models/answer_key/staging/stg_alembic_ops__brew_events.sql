-- ANSWER KEY (disabled). Reference solution for the procurement lab; not built.

with source as (
    select * from {{ source('alembic_ops', 'raw_brew_events') }}
),

renamed as (
    select
        -- ids
        brew_id,
        potion_sku,
        shop_id,
        cauldron_id,

        -- attributes
        lower(trim(quality_check)) as quality_check,
        brewer_name,

        -- measures
        batch_size::int as batch_size,
        brew_duration_minutes::int as brew_duration_minutes, -- ~1% null in raw

        -- timestamps
        {{ parse_dual_timestamp('brewed_at') }} as brewed_at
    from source
)

select * from renamed
