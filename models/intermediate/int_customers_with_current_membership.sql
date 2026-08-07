-- Customer grain enriched with current guild membership. One row per customer.
--
-- Membership history is collapsed upstream in int_memberships_current, so this
-- join preserves customer grain while keeping dim_wizards as a simple public
-- projection.

with customers as (
    select * from {{ ref('stg_grimoire_crm__customers') }}
),

memberships as (
    select * from {{ ref('int_memberships_current') }}
),

final as (
    select
        -- ids
        customers.customer_id,

        -- attributes
        customers.full_name,
        customers.email,
        customers.home_region,
        customers.favored_discipline,
        customers.birth_year,

        -- current guild membership (nullable)
        memberships.guild_id,
        memberships.guild_name,
        memberships.tier as membership_tier,
        memberships.customer_id is not null as is_guild_member,

        -- timestamps
        customers.signed_up_at,
        memberships.member_since
    from customers
    left join memberships on customers.customer_id = memberships.customer_id
)

select * from final
