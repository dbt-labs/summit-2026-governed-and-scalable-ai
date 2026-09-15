with source as (
    select * from {{ source('alembic_ops', 'raw_potion_ingredients') }}
),

renamed as (
    select
        -- composite key
        potion_sku,
        ingredient_id,

        -- measures
        quantity::int as quantity,

        -- attributes
        lower(trim(unit)) as unit
    from source
)

select * from renamed
