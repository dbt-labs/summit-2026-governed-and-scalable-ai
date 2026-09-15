with source as (

    select * from {{ source('alembic_ops', 'raw_ingredients') }}

),

renamed as (

    select
        trim(ingredient_id) as ingredient_id,
        trim(ingredient_name) as ingredient_name,
        trim(supplier_id) as supplier_id,
        lower(trim(unit)) as unit,
        unit_cost_copper,
        case
            when lower(trim(is_hazardous)) in ('true', 'yes', 'y') then true
            when lower(trim(is_hazardous)) in ('false', 'no', 'n') then false
        end as is_hazardous,
        lower(trim(harvest_season)) as harvest_season
    from source

)

select * from renamed
