with source as (
    select * from {{ source('alembic_ops', 'raw_brew_events') }}
),

renamed as (
    select
        -- ids / foreign keys
        brew_id,
        potion_sku,
        shop_id,
        cauldron_id,

        -- batch attributes
        batch_size::integer as batch_size,
        brew_duration_minutes::integer as brew_duration_minutes,
        lower(trim(quality_check)) as quality_check,
        brewer_name,

        -- timestamps
        brewed_at::timestamp_ntz as brewed_at
    from source
)

select * from renamed
