with source as (
    select * from {{ source('alembic_ops', 'raw_ingredients') }}
),

renamed as (
    select
        -- ids
        ingredient_id,
        supplier_id,

        -- attributes
        ingredient_name,
        lower(trim(unit)) as ingredient_unit,
        {{ to_boolean('is_hazardous') }} as is_hazardous,
        trim(harvest_season) as harvest_season,

        -- money
        unit_cost_copper::integer as unit_cost_copper,
        {{ copper_to_gold('unit_cost_copper') }} as unit_cost_gold
    from source
)

select
    ingredient_id,
    ingredient_name,
    supplier_id,
    ingredient_unit,
    unit_cost_copper,
    unit_cost_gold,
    is_hazardous,
    harvest_season
from renamed
