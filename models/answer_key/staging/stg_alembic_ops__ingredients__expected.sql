with source as (
    select * from {{ source('alembic_ops', 'raw_ingredients') }}
),

renamed as (
    select
        ingredient_id,
        ingredient_name,
        supplier_id,
        lower(trim(unit)) as unit,
        unit_cost_copper::integer as unit_cost_copper,
        {{ copper_to_gold('unit_cost_copper') }} as unit_cost_gold,
        {{ to_boolean('is_hazardous') }} as is_hazardous,
        harvest_season
    from source
),

final as (
    select
        ingredient_id,
        ingredient_name,
        supplier_id,
        unit,
        unit_cost_copper,
        unit_cost_gold,
        is_hazardous,
        harvest_season
    from renamed
)

select * from final
