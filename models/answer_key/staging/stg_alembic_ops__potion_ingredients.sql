-- ANSWER KEY (disabled). Reference solution for the procurement lab; not built.
-- The raw recipe bridge has no surrogate key; its natural key is the composite
-- (potion_sku, ingredient_id). We add a hashed recipe_id so the grain is
-- testable with a single `unique` test.

with source as (
    select * from {{ source('alembic_ops', 'raw_potion_ingredients') }}
),

renamed as (
    select
        -- ids
        {{ dbt_utils.generate_surrogate_key(['potion_sku', 'ingredient_id']) }} as recipe_id,
        potion_sku,
        ingredient_id,

        -- measures
        quantity::int as quantity,
        lower(trim(unit)) as unit
    from source
)

select * from renamed
