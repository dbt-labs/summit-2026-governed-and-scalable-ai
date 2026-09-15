with source as (
    select * from {{ source('alembic_ops', 'raw_brew_events') }}
),

renamed as (
    select
        -- ids / fks
        brew_id,
        potion_sku,
        shop_id,
        cauldron_id,

        -- timestamps
        brewed_at::timestamp_ntz as brewed_at,

        -- production measures
        batch_size::integer as batch_size,
        brew_duration_minutes::integer as brew_duration_minutes,

        -- attributes
        lower(trim(quality_check)) as quality_check,
        brewer_name
    from source
)

select * from renamed
