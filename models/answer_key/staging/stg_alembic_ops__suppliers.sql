-- ANSWER KEY (disabled). Reference solution for the procurement lab; not built.
-- See models/answer_key/README.md.

with source as (
    select * from {{ source('alembic_ops', 'raw_suppliers') }}
),

renamed as (
    select
        -- ids
        supplier_id,

        -- attributes
        supplier_name,
        region,
        reliability_rating::int as reliability_rating,

        -- timestamps
        contracted_since::date as contracted_since
    from source
)

select * from renamed
