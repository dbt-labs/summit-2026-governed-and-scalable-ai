with source as (

    select * from {{ source('alembic_ops', 'raw_ingredients') }}

),

renamed as (

    select
        ingredient_id,
        ingredient_name,
        supplier_id,
        lower(unit) as unit,
        unit_cost_copper::integer as unit_cost_copper,
        case
            when lower(is_hazardous) in ('y', 'yes', 'true') then true
            when lower(is_hazardous) in ('n', 'no', 'false') then false
        end as is_hazardous,
        lower(harvest_season) as harvest_season
    from source

),

final as (

    select * from renamed

)

select * from final
