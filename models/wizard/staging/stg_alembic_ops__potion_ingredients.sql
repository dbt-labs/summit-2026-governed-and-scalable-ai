with source as (
    select * from {{ source('alembic_ops', 'raw_potion_ingredients') }}
),

renamed as (
    select
        -- ids
        potion_sku,
        ingredient_id,

        -- recipe attributes
        quantity::integer as ingredient_quantity,
        lower(trim(unit)) as ingredient_unit
    from source
)

select * from renamed
