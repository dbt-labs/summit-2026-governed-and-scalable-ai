-- Order-item grain enriched with parent-order context. One row per order item.
--
-- The parent-order join supplies customer, shop, and order timestamp context
-- while preserving the one-row-per-order-item grain for fct_order_items.

with order_items as (
    select * from {{ ref('stg_abra_pos__order_items') }}
),

orders as (
    select * from {{ ref('stg_abra_pos__orders') }}
),

final as (
    select
        -- ids / fks
        order_items.order_item_id,
        order_items.order_id,
        order_items.potion_sku,
        orders.customer_id,
        orders.shop_id,

        -- measures
        order_items.quantity,
        order_items.unit_price_gold,
        order_items.line_revenue_gold,

        -- timestamps
        orders.ordered_at
    from order_items
    inner join orders on order_items.order_id = orders.order_id
)

select * from final
