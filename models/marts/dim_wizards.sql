-- Wizard (customer) dimension. One row per customer.

with customers as (
    select * from {{ ref('int_customers_with_current_membership') }}
),

final as (
    select
        -- ids
        customer_id::varchar as customer_id,

        -- attributes
        full_name::varchar as full_name,
        email::varchar as email,
        home_region::varchar as home_region,
        favored_discipline::varchar as favored_discipline,
        birth_year::integer as birth_year,

        -- current guild membership (nullable)
        guild_id::varchar as guild_id,
        guild_name::varchar as guild_name,
        membership_tier::varchar as membership_tier,
        is_guild_member::boolean as is_guild_member,

        -- timestamps
        signed_up_at::date as signed_up_at,
        member_since::date as member_since
    from customers
)

select * from final
