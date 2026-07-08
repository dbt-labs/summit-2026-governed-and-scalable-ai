# /// script
# requires-python = ">=3.10"
# dependencies = ["duckdb>=1.0"]
# ///
"""Export the large seed data to parquet under seeds/parquet_data/.

Two flavors:
  1. One parquet per raw table (12 files) — byte-faithful mirrors of the CSVs,
     read all-varchar so every raw quirk (mixed-case statuses, dual timestamp
     formats, Y/N/TRUE booleans) survives verbatim.
  2. merlin_large_denormalized.parquet — a single shareable file at order-item
     grain with orders, customers, shops, and potions joined in and proper
     types, for easy inspection in any parquet-aware tool.

Run with:  uv run scripts/export_parquet.py
"""

from __future__ import annotations

import os

import duckdb

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_DIR = os.path.join(REPO_ROOT, "seeds", "large_data")
OUT_DIR = os.path.join(REPO_ROOT, "seeds", "parquet_data")

TABLES = {
    "abra_pos": ["raw_potions", "raw_orders", "raw_order_items", "raw_payments"],
    "grimoire_crm": ["raw_customers", "raw_guilds", "raw_guild_memberships"],
    "alembic_ops": ["raw_shops", "raw_suppliers", "raw_ingredients",
                    "raw_potion_ingredients", "raw_brew_events"],
}

DENORM_SQL = f"""
copy (
    select
        oi.order_item_id,
        oi.order_id,
        o.ordered_at,
        o.ordered_at::timestamp                          as ordered_at_ts,
        o.status                                         as order_status,
        o.channel,
        o.discount_copper::int                           as order_discount_copper,
        oi.quantity::int                                 as quantity,
        oi.unit_price_copper::int                        as unit_price_copper,
        oi.quantity::int * oi.unit_price_copper::int     as line_revenue_copper,
        c.customer_id,
        c.full_name                                      as customer_name,
        c.home_region                                    as customer_home_region,
        c.signed_up_at::date                             as customer_signed_up_at,
        c.favored_discipline,
        s.shop_id,
        s.shop_name,
        s.city                                           as shop_city,
        s.region                                         as shop_region,
        p.potion_sku,
        p.potion_name,
        p.category                                       as potion_category,
        p.base_price_copper::int                         as base_price_copper,
        p.potency::int                                   as potency,
        p.is_regulated
    from read_csv('{SOURCE_DIR}/abra_pos/raw_order_items.csv', all_varchar=true) oi
    join read_csv('{SOURCE_DIR}/abra_pos/raw_orders.csv', all_varchar=true) o using (order_id)
    join read_csv('{SOURCE_DIR}/grimoire_crm/raw_customers.csv', all_varchar=true) c using (customer_id)
    join read_csv('{SOURCE_DIR}/alembic_ops/raw_shops.csv', all_varchar=true) s using (shop_id)
    join read_csv('{SOURCE_DIR}/abra_pos/raw_potions.csv', all_varchar=true) p using (potion_sku)
    order by oi.order_item_id
) to '{OUT_DIR}/merlin_large_denormalized.parquet' (format parquet, compression zstd)
"""


def main() -> None:
    os.makedirs(OUT_DIR, exist_ok=True)
    con = duckdb.connect()

    for system, tables in TABLES.items():
        for table in tables:
            src = os.path.join(SOURCE_DIR, system, f"{table}.csv")
            dst = os.path.join(OUT_DIR, f"{table}.parquet")
            con.execute(f"""
                copy (select * from read_csv('{src}', all_varchar=true))
                to '{dst}' (format parquet, compression zstd)
            """)
            rows = con.execute(f"select count(*) from '{dst}'").fetchone()[0]
            print(f"  {table}.parquet  —  {rows:>7,} rows, {os.path.getsize(dst) / 1024:>7,.0f} KB")

    print("Building denormalized order-item file…")
    con.execute(DENORM_SQL)
    denorm = os.path.join(OUT_DIR, "merlin_large_denormalized.parquet")
    rows = con.execute(f"select count(*) from '{denorm}'").fetchone()[0]
    print(f"  merlin_large_denormalized.parquet  —  {rows:,} rows, "
          f"{os.path.getsize(denorm) / 1024 / 1024:.1f} MB")
    print("Done.")


if __name__ == "__main__":
    main()
