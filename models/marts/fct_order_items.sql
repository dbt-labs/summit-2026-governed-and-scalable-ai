-- Line-grain fact. One row per potion per order, with parent-order context
-- carried through from the intermediate layer for convenient slicing.

with order_items as (
    select * from {{ ref('int_order_items_with_order_context') }}
),

final as (
    select
        -- ids / fks
        order_item_id::varchar as order_item_id,
        order_id::varchar as order_id,
        potion_sku::varchar as potion_sku,
        customer_id::varchar as customer_id,
        shop_id::varchar as shop_id,

        -- measures
        quantity::integer as quantity,
        unit_price_gold::number(38, 2) as unit_price_gold,
        line_revenue_gold::number(38, 2) as line_revenue_gold,

        -- timestamps
        ordered_at::timestamp_ntz as ordered_at,
        ordered_at::date as ordered_date
    from order_items
)

select * from final
