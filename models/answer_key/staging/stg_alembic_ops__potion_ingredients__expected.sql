with source as (
    select * from {{ source('alembic_ops', 'raw_potion_ingredients') }}
),

renamed as (
    select
        -- composite natural key / foreign keys
        potion_sku,
        ingredient_id,

        -- recipe component
        quantity::integer as quantity,
        lower(trim(unit)) as unit
    from source
)

select * from renamed
