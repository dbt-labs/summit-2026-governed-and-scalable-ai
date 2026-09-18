with source as (

    select * from {{ source('alembic_ops', 'raw_ingredients') }}

),

renamed as (

    select
        trim(ingredient_id) as ingredient_id,
        trim(ingredient_name) as ingredient_name,
        trim(supplier_id) as supplier_id,
        lower(trim(unit)) as unit,
        unit_cost_copper::number(18, 2) as unit_cost_copper,
        lower(trim(is_hazardous)) in ('y', 'yes', 'true') as is_hazardous,
        trim(harvest_season) as harvest_season
    from source

)

select * from renamed
