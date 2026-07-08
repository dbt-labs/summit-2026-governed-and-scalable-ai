# /// script
# requires-python = ">=3.10"
# dependencies = []
# ///
"""Generate raw source data for Merlin & Co. Apothecaries.

Produces 12 lightly-messy CSV seed files under seeds/<size>_data/,
organized by fictional source system:

    abra_pos      — point-of-sale: potions, orders, order_items, payments
    grimoire_crm  — CRM: customers, guilds, guild_memberships
    alembic_ops   — ops: shops, suppliers, ingredients, potion_ingredients, brew_events

Deterministic: a fixed RNG seed means re-running produces identical output.
Run with:  uv run scripts/generate_data.py --size medium
           uv run scripts/generate_data.py --size large
"""

from __future__ import annotations

import argparse
import csv
import os
import random
from bisect import bisect_right
from datetime import date, datetime, timedelta

# ---------------------------------------------------------------------------
# Tunables
# ---------------------------------------------------------------------------

RNG_SEED = 42

# fact-table scale per size tier; dimensions (potions, shops, …) stay fixed
SIZES = {
    "medium": {"customers": 5_000, "orders": 15_000, "brew_events": 8_000},
    "large": {"customers": 20_000, "orders": 75_000, "brew_events": 40_000},
}

# overwritten from --size in main()
N_CUSTOMERS = SIZES["medium"]["customers"]
N_ORDERS = SIZES["medium"]["orders"]
N_BREW_EVENTS = SIZES["medium"]["brew_events"]

N_POTIONS = 120
N_INGREDIENTS = 80

WINDOW_START = date(2024, 7, 1)   # first order date
WINDOW_END = date(2026, 6, 30)    # last order date
SIGNUP_START = date(2023, 1, 1)   # earliest customer signup

GROWTH_FACTOR = 2.0               # order volume at window end vs. start
WEEKEND_BOOST = 1.35              # Sat/Sun order-volume multiplier
PRICE_INFLATION = 0.08            # unit prices drift up ~8% across the window

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SEEDS_DIR = os.path.join(REPO_ROOT, "seeds", "medium_data")  # overwritten from --size in main()

rng = random.Random(RNG_SEED)

# ---------------------------------------------------------------------------
# Reference vocabulary (all original fantasy — no borrowed IP)
# ---------------------------------------------------------------------------

REGIONS = {
    "Northern Reaches": "NR",
    "Ember Coast": "EC",
    "Silverwood": "SW",
    "The Marshlands": "ML",
    "Crystal Vale": "CV",
}

CITIES = {
    "Northern Reaches": ["Frosthollow", "Wolfsgate", "Aldermere"],
    "Ember Coast": ["Cinderport", "Saltflame Bay", "Kilnhaven"],
    "Silverwood": ["Gleamdale", "Thornbury", "Elderglen"],
    "The Marshlands": ["Bogwick", "Reedham", "Murkwater Crossing"],
    "Crystal Vale": ["Shardfall", "Lumenbrook", "Prismgate"],
}

SHOP_NAMES = [
    "The Gilded Alembic", "Moonpetal & Mortar", "The Bubbling Crucible",
    "Wyrmfire Remedies", "The Crooked Cauldron", "Starwell Apothecary",
    "The Sable Retort", "Hollowroot Elixirs", "The Copper Kettle",
    "Nightbloom Dispensary", "The Whispering Vial", "Emberglass Apothecary",
    "Thornwick & Vale", "The Silver Pestle", "Mistral Tonics",
]

SUPPLIER_NAMES = [
    "Ember & Sons Reagents", "Blackroot Botanicals", "Wyrmscale Imports",
    "The Mandrake Cooperative", "Moonharvest Farms", "Gloomfen Gatherers",
    "Stonewell Minerals", "Featherdown Traders", "Ashenfield Combustibles",
    "Silverleaf Estates", "Tidepool Curiosities", "Grimmarsh Fungals",
    "Skyloom Apiaries", "Deepdelve Crystals", "Hearthfire Provisions",
]

GUILD_NAMES = [
    "Order of the Silver Quill", "Circle of the Bubbling Flask",
    "The Midnight Athenaeum", "Brotherhood of the Brazen Cauldron",
    "Sisterhood of the Verdant Bough", "The Gilded Retort Society",
    "Wardens of the Old Ways", "The Alchemists' Concord",
    "Fellowship of the Third Moon", "The Ashen Veil",
    "Keepers of the Crystal Codex", "The Wandering Court",
]

FIRST_NAMES = [
    "Alaric", "Bramble", "Cassia", "Dorian", "Elowen", "Fenwick", "Grizelda",
    "Hawthorne", "Isolde", "Jasper", "Kestrel", "Lyra", "Morwenna", "Nimbus",
    "Oswin", "Peregrine", "Quilla", "Rowan", "Seraphine", "Thaddeus", "Umbra",
    "Vesper", "Wendeline", "Xanthe", "Yarrow", "Zephyrine", "Ambrose",
    "Belladonna", "Caspian", "Delphine", "Edric", "Fiora", "Gideon", "Hesper",
    "Ignatius", "Juniper", "Corvin", "Maribel", "Oleander", "Petra",
]

LAST_NAMES = [
    "Thistledown", "Emberwhisk", "Moonbrook", "Cinderfell", "Wandwright",
    "Glimmerstone", "Nightbloom", "Ashgrove", "Ravenscroft", "Foxglove",
    "Hollowbranch", "Stormbottle", "Copperkettle", "Winterbourne", "Mossheart",
    "Fernwhistle", "Duskwater", "Brightmantle", "Owlsworth", "Quickbramble",
    "Saltmarsh", "Tanglewood", "Umberfall", "Vexley", "Wyrmwood",
    "Yewbarrow", "Zellandine", "Barrowmere", "Crowfeather", "Dimbleby",
    "Everbright", "Frostpetal", "Gorsebush", "Hazelrigg", "Ironquill",
    "Jackdaw", "Kilnworth", "Larkspur", "Mistlethorn", "Netherfield",
]

EMAIL_DOMAINS = ["ravenpost.net", "owlmail.co", "crystalball.io", "grimoire.org", "moonmail.net"]

DISCIPLINES = ["Healing", "Divination", "Alchemy", "Transmutation", "Herbalism", "Enchantment", "Illusion"]

CATEGORIES = ["Healing", "Clarity", "Luck", "Strength", "Invisibility", "Love"]

BASE_CATEGORY_WEIGHTS = {
    "Healing": 1.4, "Clarity": 1.2, "Luck": 1.0,
    "Strength": 0.9, "Invisibility": 0.7, "Love": 0.6,
}

# month-of-year demand multipliers per category
SEASONALITY = {
    "Healing": {11: 1.3, 12: 1.6, 1: 1.6, 2: 1.6, 3: 1.3},
    "Love": {2: 2.5},
    "Luck": {12: 1.8, 1: 1.6},
    "Clarity": {9: 1.4, 10: 1.4},
    "Strength": {6: 1.2, 7: 1.2},
    "Invisibility": {10: 1.5},
}
LOVE_OFFSEASON = 0.9  # Love sells below base weight outside February

# regions have different wizard populations, so revenue by region shows a
# real structural spread (not just sampling noise) at any size tier
REGION_POPULATION = {
    "Northern Reaches": 1.40,
    "Ember Coast": 1.15,
    "Silverwood": 1.00,
    "The Marshlands": 0.80,
    "Crystal Vale": 0.65,
}

# each region over-indexes on a couple of categories
REGION_CATEGORY_BOOST = {
    "Northern Reaches": ["Healing", "Strength"],
    "Ember Coast": ["Luck"],
    "Silverwood": ["Clarity"],
    "The Marshlands": ["Invisibility"],
    "Crystal Vale": ["Love", "Clarity"],
}
REGION_BOOST = 1.5

POTION_FORMS = ["Elixir", "Draught", "Tonic", "Philter", "Tincture", "Brew", "Decoction", "Essence", "Infusion", "Cordial"]

POTION_PHRASES = {
    "Healing": ["Mended Bones", "the Quiet Pulse", "Swift Recovery", "Knitted Flesh", "Gentle Fevers",
                "the Steady Heart", "Bruisebane", "Feverbreak", "the Whole Body", "Silvered Wounds"],
    "Clarity": ["Focused Mind", "the Clear Eye", "Unclouded Thought", "Sharp Recall", "the Waking Dream",
                "Steady Nerves", "the Open Book", "Quicksilver Wit", "the Third Question", "Bright Attention"],
    "Luck": ["Fortunate Turns", "the Winning Hand", "Found Coins", "Fair Winds", "the Lucky Step",
             "Golden Chances", "the Kind Roll", "Serendip", "the Charmed Hour", "Narrow Escapes"],
    "Strength": ["Iron Sinews", "the Ox's Burden", "Unbent Knees", "Stone Grip", "the Long March",
                 "Bull's Vigor", "the Heavy Lift", "Tireless Arms", "the Tenth Round", "Granite Will"],
    "Invisibility": ["Passing Shadows", "the Unseen Guest", "Thin Air", "Fading Footsteps", "the Missed Glance",
                     "Smoke and Dusk", "the Quiet Room", "Veiled Faces", "the Empty Chair", "Forgotten Names"],
    "Love": ["Warm Regard", "the First Blush", "Honeyed Words", "the Second Glance", "Tender Hearts",
             "Sweet Meetings", "the Long Letter", "Moonlit Vows", "the Shared Umbrella", "Kindled Sparks"],
}

INGREDIENT_BASES = [
    "moonpetal", "wyrm scale", "mandrake root", "beetle shell", "embermoss",
    "frost lotus", "glowcap mushroom", "raven feather", "salamander tail",
    "nightshade berry", "kelpwrack", "sun amber", "hollowroot", "silverleaf",
    "bog myrtle", "crystal dust", "phoenix ash", "thistle seed", "wolfsbane",
    "duskthorn bark", "marsh reed", "starwell water", "gorgon kelp",
    "hearthstone shard", "wisp silk", "toadstool cap", "elderflower",
    "grave moss", "sprite wing", "tidal pearl", "cinder bloom", "yew sap",
    "basilisk fang", "mirror lichen", "storm glass", "fen lily", "owl pellet",
    "quartz vein", "shade fern", "honeycomb wax",
]
INGREDIENT_PREPS = ["", "powdered ", "dried ", "crushed ", "distilled ", "candied "]

UNITS = ["gram", "sprig", "vial", "pinch", "dram", "bundle"]

SEASONS = ["Spring", "Summer", "Autumn", "Winter", "Year-round"]

PAYMENT_METHODS = ["coin", "guild_credit", "crystal_transfer", "barter"]
PAYMENT_METHOD_WEIGHTS = [45, 25, 20, 10]

TIERS = ["apprentice", "adept", "archmage"]

# ---------------------------------------------------------------------------
# Messiness helpers — the "lightly messy" dirt lives here
# ---------------------------------------------------------------------------


def mangle_case(value: str) -> str:
    """Return value in its canonical form ~70% of the time, else Title/UPPER."""
    roll = rng.random()
    if roll < 0.70:
        return value
    if roll < 0.90:
        return value.title()
    return value.upper()


def fmt_ts(dt: datetime) -> str:
    """Mix ISO-with-Z and space-separated timestamp formats."""
    if rng.random() < 0.60:
        return dt.strftime("%Y-%m-%dT%H:%M:%SZ")
    return dt.strftime("%Y-%m-%d %H:%M:%S")


def messy_region_code(region: str) -> str:
    """CRM stores home regions inconsistently: abbrevs, lowercase, full names."""
    roll = rng.random()
    code = REGIONS[region]
    if roll < 0.45:
        return code
    if roll < 0.70:
        return code.lower()
    if roll < 0.90:
        return region
    return region.lower()


def messy_bool(value: bool) -> str:
    roll = rng.random()
    if roll < 0.85:
        return "Y" if value else "N"
    if roll < 0.95:
        return "yes" if value else "no"
    return "TRUE" if value else "FALSE"


def rand_date(start: date, end: date) -> date:
    return start + timedelta(days=rng.randint(0, (end - start).days))


def rand_time_of_day(d: date) -> datetime:
    """Shop hours 8:00–20:00, weighted toward midday."""
    hour = min(19, max(8, int(rng.triangular(8, 20, 13))))
    return datetime(d.year, d.month, d.day, hour, rng.randint(0, 59), rng.randint(0, 59))


def window_position(d: date) -> float:
    """0.0 at window start, 1.0 at window end."""
    return (d - WINDOW_START).days / (WINDOW_END - WINDOW_START).days


# ---------------------------------------------------------------------------
# Dimension-ish tables
# ---------------------------------------------------------------------------


def build_shops() -> list[dict]:
    shops = []
    region_cycle = []
    for region in REGIONS:  # 3 shops per region
        region_cycle.extend([region] * 3)
    for i, (name, region) in enumerate(zip(SHOP_NAMES, region_cycle), start=1):
        shops.append({
            "shop_id": f"SHP-{i:02d}",
            "shop_name": name,
            "city": rng.choice(CITIES[region]),
            "region": region,
            "opened_at": rand_date(date(2012, 1, 1), date(2023, 6, 1)).isoformat(),
        })
    return shops


def build_suppliers() -> list[dict]:
    return [{
        "supplier_id": f"SUP-{i:02d}",
        "supplier_name": name,
        "region": rng.choice(list(REGIONS)),
        "reliability_rating": rng.randint(1, 5),
        "contracted_since": rand_date(date(2015, 1, 1), date(2024, 1, 1)).isoformat(),
    } for i, name in enumerate(SUPPLIER_NAMES, start=1)]


def build_ingredients(suppliers: list[dict]) -> list[dict]:
    names = []
    for base in INGREDIENT_BASES:
        preps = rng.sample(INGREDIENT_PREPS, 2)
        names.extend(f"{p}{base}" for p in preps)
    names = names[:N_INGREDIENTS]
    return [{
        "ingredient_id": f"ING-{i:03d}",
        "ingredient_name": name,
        "supplier_id": rng.choice(suppliers)["supplier_id"],
        "unit": mangle_case(rng.choice(UNITS)),
        "unit_cost_copper": rng.randint(3, 220),
        "is_hazardous": messy_bool(rng.random() < 0.15),
        "harvest_season": rng.choice(SEASONS),
    } for i, name in enumerate(names, start=1)]


def build_potions() -> list[dict]:
    potions = []
    used_names = set()
    per_category = N_POTIONS // len(CATEGORIES)
    i = 0
    for category in CATEGORIES:
        for j in range(per_category):
            while True:
                name = f"{rng.choice(POTION_FORMS)} of {rng.choice(POTION_PHRASES[category])}"
                if name not in used_names:
                    used_names.add(name)
                    break
            i += 1
            # first 5 per category predate the order window so every category
            # has sellable stock on day one; the rest launch mid-window
            if j < 5 or rng.random() < 0.55:
                introduced = rand_date(date(2019, 1, 1), WINDOW_START - timedelta(days=30))
            else:
                introduced = rand_date(WINDOW_START, WINDOW_END - timedelta(days=90))
            potions.append({
                "potion_sku": f"POT-{i:04d}",
                "potion_name": name,
                "category": mangle_case(category),
                "base_price_copper": rng.randint(4, 60) * 25,  # 100–1500 copper
                "potency": rng.randint(1, 10),
                "shelf_life_days": rng.choice([14, 30, 60, 90, 180, 365]),
                "is_regulated": messy_bool(rng.random() < 0.2),
                "introduced_at": introduced.isoformat(),
                # generator-internal fields (stripped before writing)
                "_category": category,
                "_introduced": introduced,
                "_popularity": rng.uniform(0.5, 2.0),
            })
    return potions


def build_potion_ingredients(potions: list[dict], ingredients: list[dict]) -> list[dict]:
    rows = []
    unit_by_ing = {ing["ingredient_id"]: ing["unit"] for ing in ingredients}
    for potion in potions:
        for ing in rng.sample(ingredients, rng.randint(2, 5)):
            rows.append({
                "potion_sku": potion["potion_sku"],
                "ingredient_id": ing["ingredient_id"],
                "quantity": rng.randint(1, 12),
                "unit": mangle_case(unit_by_ing[ing["ingredient_id"]].lower()),
            })
    return rows


def build_customers() -> list[dict]:
    customers = []
    for i in range(1, N_CUSTOMERS + 1):
        first, last = rng.choice(FIRST_NAMES), rng.choice(LAST_NAMES)
        # 40% of signups predate the order window; the base keeps growing after
        if rng.random() < 0.40:
            signed_up = rand_date(SIGNUP_START, WINDOW_START)
        else:
            signed_up = rand_date(WINDOW_START, WINDOW_END - timedelta(days=14))
        email = ""
        if rng.random() > 0.02:  # ~2% missing emails
            email = f"{first}.{last}{rng.randint(1, 999)}@{rng.choice(EMAIL_DOMAINS)}".lower()
        region = rng.choices(list(REGION_POPULATION), weights=list(REGION_POPULATION.values()))[0]
        customers.append({
            "customer_id": f"WIZ-{i:05d}",
            "full_name": f"{first} {last}",
            "email": email,
            "home_region": messy_region_code(region),
            "signed_up_at": signed_up.isoformat(),
            "birth_year": rng.randint(1885, 2007),  # wizards age gracefully
            "favored_discipline": mangle_case(rng.choice(DISCIPLINES)),
            "_region": region,
            "_signed_up": signed_up,
            "_activity": rng.paretovariate(1.8),  # power-law: a few whales
        })
    return customers


def build_guilds() -> list[dict]:
    return [{
        "guild_id": f"GLD-{i:02d}",
        "guild_name": name,
        "founded_year": rng.randint(1650, 1990),
    } for i, name in enumerate(GUILD_NAMES, start=1)]


def build_guild_memberships(customers: list[dict], guilds: list[dict]) -> list[dict]:
    rows = []
    mem_id = 0
    for cust in customers:
        if rng.random() > 0.65:  # ~65% of wizards belong to a guild
            continue
        guild = rng.choice(guilds)
        signed_up = cust["_signed_up"]
        joined = rand_date(signed_up, min(signed_up + timedelta(days=400), WINDOW_END))
        tier_idx = rng.choices([0, 1, 2], weights=[55, 33, 12])[0]
        # ~30% carry a promotion history: a closed row at the prior tier
        # (needs enough runway between joining and the window end)
        if tier_idx > 0 and rng.random() < 0.30 and joined + timedelta(days=60) <= WINDOW_END:
            promoted = rand_date(joined + timedelta(days=30), min(joined + timedelta(days=700), WINDOW_END))
            mem_id += 1
            rows.append({
                "membership_id": f"MEM-{mem_id:05d}",
                "customer_id": cust["customer_id"],
                "guild_id": guild["guild_id"],
                "tier": mangle_case(TIERS[tier_idx - 1]),
                "valid_from": joined.isoformat(),
                "valid_to": promoted.isoformat(),
            })
            joined = promoted
        mem_id += 1
        rows.append({
            "membership_id": f"MEM-{mem_id:05d}",
            "customer_id": cust["customer_id"],
            "guild_id": guild["guild_id"],
            "tier": mangle_case(TIERS[tier_idx]),
            "valid_from": joined.isoformat(),
            "valid_to": "",
        })
    return rows


# ---------------------------------------------------------------------------
# Fact tables
# ---------------------------------------------------------------------------


def sample_order_dates() -> list[date]:
    """Order dates with ~2x growth across the window plus a weekend bump."""
    days = [WINDOW_START + timedelta(days=n) for n in range((WINDOW_END - WINDOW_START).days + 1)]
    weights = []
    for d in days:
        w = 1.0 + (GROWTH_FACTOR - 1.0) * window_position(d)
        if d.weekday() >= 5:
            w *= WEEKEND_BOOST
        weights.append(w)
    return sorted(rng.choices(days, weights=weights, k=N_ORDERS))


def pick_customer(customers_sorted: list[dict], cum_weights: list[float], order_date: date) -> dict:
    """Weighted pick among customers already signed up by order_date."""
    # customers_sorted is ordered by signup date; find the eligible prefix
    lo, hi = 0, len(customers_sorted)
    while lo < hi:
        mid = (lo + hi) // 2
        if customers_sorted[mid]["_signed_up"] <= order_date:
            lo = mid + 1
        else:
            hi = mid
    k = lo  # first k customers are eligible
    if k == 0:
        return customers_sorted[0]
    target = rng.uniform(0, cum_weights[k - 1])
    return customers_sorted[bisect_right(cum_weights, target, 0, k)]


def pick_potion(potions: list[dict], region: str, order_date: date) -> dict:
    month = order_date.month
    cat_weights = []
    for cat in CATEGORIES:
        w = BASE_CATEGORY_WEIGHTS[cat]
        w *= SEASONALITY[cat].get(month, LOVE_OFFSEASON if cat == "Love" else 1.0)
        if cat in REGION_CATEGORY_BOOST[region]:
            w *= REGION_BOOST
        cat_weights.append(w)
    category = rng.choices(CATEGORIES, weights=cat_weights)[0]
    available = [p for p in potions if p["_category"] == category and p["_introduced"] <= order_date]
    return rng.choices(available, weights=[p["_popularity"] for p in available])[0]


def build_orders_items_payments(customers: list[dict], shops: list[dict], potions: list[dict]):
    customers_sorted = sorted(customers, key=lambda c: c["_signed_up"])
    cum_weights = []
    total = 0.0
    for c in customers_sorted:
        total += c["_activity"]
        cum_weights.append(total)

    shops_by_region: dict[str, list[dict]] = {}
    for s in shops:
        shops_by_region.setdefault(s["region"], []).append(s)

    orders, items, payments = [], [], []
    item_id = 0
    pay_id = 0
    for i, order_date in enumerate(sample_order_dates(), start=1):
        cust = pick_customer(customers_sorted, cum_weights, order_date)
        # wizards mostly shop close to home
        if rng.random() < 0.80:
            shop = rng.choice(shops_by_region[cust["_region"]])
        else:
            shop = rng.choice(shops)
        ordered_at = rand_time_of_day(order_date)

        n_items = rng.choices([1, 2, 3, 4, 5, 6, 7, 8],
                              weights=[18, 20, 19, 15, 11, 8, 5, 4])[0]
        drift = 1.0 + PRICE_INFLATION * window_position(order_date)
        order_total = 0
        chosen_skus = set()
        for _ in range(n_items):
            potion = pick_potion(potions, shop["region"], order_date)
            if potion["potion_sku"] in chosen_skus:
                continue  # quantity covers repeats; skip duplicate lines
            chosen_skus.add(potion["potion_sku"])
            qty = rng.choices([1, 2, 3, 4, 5], weights=[62, 20, 10, 5, 3])[0]
            unit_price = int(potion["base_price_copper"] * drift * rng.uniform(0.95, 1.05))
            item_id += 1
            items.append({
                "order_item_id": f"ITM-{item_id:06d}",
                "order_id": f"ORD-{i:06d}",
                "potion_sku": potion["potion_sku"],
                "quantity": qty,
                "unit_price_copper": unit_price,
            })
            order_total += qty * unit_price

        discount = 0
        if rng.random() < 0.10:
            discount = min(order_total, rng.randint(2, 20) * 25)
        order_total -= discount

        days_from_end = (WINDOW_END - order_date).days
        if days_from_end <= 14 and rng.random() < 0.30:
            status = "placed"
        else:
            status = rng.choices(["completed", "returned", "cancelled"], weights=[93, 4, 3])[0]

        orders.append({
            "order_id": f"ORD-{i:06d}",
            "customer_id": cust["customer_id"],
            "shop_id": shop["shop_id"],
            "ordered_at": fmt_ts(ordered_at),
            "status": mangle_case(status),
            "channel": rng.choices(["in_store", "courier_owl", "marketplace"], weights=[60, 25, 15])[0],
            "discount_copper": discount,
            "_status": status,
            "_total": order_total,
        })

        # -- payments -------------------------------------------------------
        def add_payment(amount: int, status: str, method: str, minutes_after: int):
            nonlocal pay_id
            pay_id += 1
            payments.append({
                "payment_id": f"PAY-{pay_id:06d}",
                "order_id": f"ORD-{i:06d}",
                "method": method,
                "amount_copper": amount,
                "status": status,
                "paid_at": fmt_ts(ordered_at + timedelta(minutes=minutes_after)),
            })

        method = rng.choices(PAYMENT_METHODS, weights=PAYMENT_METHOD_WEIGHTS)[0]
        if status == "cancelled":
            if rng.random() < 0.40:  # a failed attempt before giving up
                add_payment(order_total, "failed", method, rng.randint(1, 10))
        else:
            if rng.random() < 0.05:  # failed attempt, then a successful retry
                add_payment(order_total, "failed", method, rng.randint(1, 5))
            if order_total > 500 and rng.random() < 0.08:  # split payment
                part = order_total // 2 + rng.randint(-100, 100)
                add_payment(part, "success", method, rng.randint(5, 20))
                add_payment(order_total - part,
                            "success",
                            rng.choices(PAYMENT_METHODS, weights=PAYMENT_METHOD_WEIGHTS)[0],
                            rng.randint(21, 40))
            else:
                add_payment(order_total, "success", method, rng.randint(5, 30))
            if status == "returned":
                add_payment(order_total, "refunded", method, rng.randint(60, 20_000))

    return orders, items, payments


def build_brew_events(potions: list[dict], shops: list[dict]) -> list[dict]:
    brewers = [f"{rng.choice(FIRST_NAMES)} {rng.choice(LAST_NAMES)}" for _ in range(30)]
    rows = []
    for i in range(1, N_BREW_EVENTS + 1):
        potion = rng.choices(potions, weights=[p["_popularity"] for p in potions])[0]
        earliest = max(potion["_introduced"], WINDOW_START - timedelta(days=60))
        brewed = rand_date(earliest, WINDOW_END)
        brewed_at = rand_time_of_day(brewed).replace(hour=rng.randint(5, 11))  # brewing is morning work
        duration = ""
        if rng.random() > 0.01:  # ~1% of brew logs are missing durations
            duration = int(30 + potion["potency"] * 12 + rng.gauss(0, 15))
            duration = max(15, duration)
        rows.append({
            "brew_id": f"BRW-{i:05d}",
            "potion_sku": potion["potion_sku"],
            "shop_id": rng.choice(shops)["shop_id"],
            "cauldron_id": f"CDR-{rng.randint(1, 40):02d}",
            "brewed_at": fmt_ts(brewed_at),
            "batch_size": rng.randint(10, 60),
            "brew_duration_minutes": duration,
            "quality_check": mangle_case("pass" if rng.random() < 0.93 else "fail"),
            "brewer_name": rng.choice(brewers),
        })
    return rows


# ---------------------------------------------------------------------------
# Output + validation
# ---------------------------------------------------------------------------


def write_csv(system: str, table: str, rows: list[dict]) -> None:
    path = os.path.join(SEEDS_DIR, system, f"{table}.csv")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    fields = [k for k in rows[0] if not k.startswith("_")]
    with open(path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore", lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    size_kb = os.path.getsize(path) / 1024
    print(f"  {system}/{table}.csv  —  {len(rows):>6,} rows, {size_kb:>8,.0f} KB")


def validate(tables: dict[str, list[dict]]) -> None:
    def pks_unique(table: str, key: str):
        vals = [r[key] for r in tables[table]]
        assert len(vals) == len(set(vals)), f"duplicate {key} in {table}"

    def fks_resolve(child: str, key: str, parent: str, parent_key: str):
        parent_ids = {r[parent_key] for r in tables[parent]}
        missing = [r[key] for r in tables[child] if r[key] not in parent_ids]
        assert not missing, f"{len(missing)} orphaned {key} in {child}"

    for table, key in [
        ("customers", "customer_id"), ("guilds", "guild_id"),
        ("guild_memberships", "membership_id"), ("shops", "shop_id"),
        ("suppliers", "supplier_id"), ("ingredients", "ingredient_id"),
        ("potions", "potion_sku"), ("orders", "order_id"),
        ("order_items", "order_item_id"), ("payments", "payment_id"),
        ("brew_events", "brew_id"),
    ]:
        pks_unique(table, key)

    fks_resolve("guild_memberships", "customer_id", "customers", "customer_id")
    fks_resolve("guild_memberships", "guild_id", "guilds", "guild_id")
    fks_resolve("ingredients", "supplier_id", "suppliers", "supplier_id")
    fks_resolve("potion_ingredients", "potion_sku", "potions", "potion_sku")
    fks_resolve("potion_ingredients", "ingredient_id", "ingredients", "ingredient_id")
    fks_resolve("orders", "customer_id", "customers", "customer_id")
    fks_resolve("orders", "shop_id", "shops", "shop_id")
    fks_resolve("order_items", "order_id", "orders", "order_id")
    fks_resolve("order_items", "potion_sku", "potions", "potion_sku")
    fks_resolve("payments", "order_id", "orders", "order_id")
    fks_resolve("brew_events", "potion_sku", "potions", "potion_sku")
    fks_resolve("brew_events", "shop_id", "shops", "shop_id")

    # successful payments reconcile to order totals for every paid order
    paid = {}
    for p in tables["payments"]:
        if p["status"] == "success":
            paid[p["order_id"]] = paid.get(p["order_id"], 0) + p["amount_copper"]
    for o in tables["orders"]:
        if o["_status"] in ("completed", "returned", "placed"):
            assert paid.get(o["order_id"]) == o["_total"], f"payment mismatch on {o['order_id']}"
        else:
            assert o["order_id"] not in paid, f"cancelled order {o['order_id']} has a successful payment"

    # every order has at least one line item, all timestamps inside the window
    order_ids_with_items = {r["order_id"] for r in tables["order_items"]}
    assert all(o["order_id"] in order_ids_with_items for o in tables["orders"]), "order without items"
    for o in tables["orders"]:
        d = date.fromisoformat(o["ordered_at"][:10])
        assert WINDOW_START <= d <= WINDOW_END, f"order date out of window: {d}"

    print("  all assertions passed: unique PKs, resolved FKs, payments reconcile, dates in window")


def main() -> None:
    global N_CUSTOMERS, N_ORDERS, N_BREW_EVENTS, SEEDS_DIR

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--size", choices=sorted(SIZES), default="medium",
                        help="size tier to generate (default: medium)")
    args = parser.parse_args()

    scale = SIZES[args.size]
    N_CUSTOMERS = scale["customers"]
    N_ORDERS = scale["orders"]
    N_BREW_EVENTS = scale["brew_events"]
    SEEDS_DIR = os.path.join(REPO_ROOT, "seeds", f"{args.size}_data")
    print(f"Size tier: {args.size} ({N_ORDERS:,} orders, {N_CUSTOMERS:,} customers)")

    print("Building dimensions…")
    shops = build_shops()
    suppliers = build_suppliers()
    ingredients = build_ingredients(suppliers)
    potions = build_potions()
    potion_ingredients = build_potion_ingredients(potions, ingredients)
    customers = build_customers()
    guilds = build_guilds()
    guild_memberships = build_guild_memberships(customers, guilds)

    print("Building facts…")
    orders, order_items, payments = build_orders_items_payments(customers, shops, potions)
    brew_events = build_brew_events(potions, shops)

    tables = {
        "customers": customers, "guilds": guilds, "guild_memberships": guild_memberships,
        "potions": potions, "orders": orders, "order_items": order_items, "payments": payments,
        "shops": shops, "suppliers": suppliers, "ingredients": ingredients,
        "potion_ingredients": potion_ingredients, "brew_events": brew_events,
    }

    print("Validating…")
    validate(tables)

    print(f"Writing CSVs to {SEEDS_DIR}/")
    write_csv("grimoire_crm", "raw_customers", customers)
    write_csv("grimoire_crm", "raw_guilds", guilds)
    write_csv("grimoire_crm", "raw_guild_memberships", guild_memberships)
    write_csv("abra_pos", "raw_potions", potions)
    write_csv("abra_pos", "raw_orders", orders)
    write_csv("abra_pos", "raw_order_items", order_items)
    write_csv("abra_pos", "raw_payments", payments)
    write_csv("alembic_ops", "raw_shops", shops)
    write_csv("alembic_ops", "raw_suppliers", suppliers)
    write_csv("alembic_ops", "raw_ingredients", ingredients)
    write_csv("alembic_ops", "raw_potion_ingredients", potion_ingredients)
    write_csv("alembic_ops", "raw_brew_events", brew_events)
    print("Done.")


if __name__ == "__main__":
    main()
