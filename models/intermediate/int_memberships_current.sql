-- Collapses the SCD2 membership history to the current guild + tier per
-- customer. One row per customer who currently belongs to a guild.
--
-- A customer has at most one open (is_current) membership row; we join in
-- the guild name so downstream dims don't re-touch the guild table.

with memberships as (
    select * from {{ ref('stg_grimoire_crm__guild_memberships') }}
),

guilds as (
    select * from {{ ref('stg_grimoire_crm__guilds') }}
),

current_memberships as (
    select * from memberships where is_current
),

final as (
    select
        -- ids
        current_memberships.customer_id,
        current_memberships.membership_id,
        current_memberships.guild_id,

        -- attributes
        guilds.guild_name,
        current_memberships.tier,

        -- timestamps
        current_memberships.valid_from as member_since
    from current_memberships
    inner join guilds on current_memberships.guild_id = guilds.guild_id
)

select * from final
