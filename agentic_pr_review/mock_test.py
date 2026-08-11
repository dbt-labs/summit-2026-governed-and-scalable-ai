#!/usr/bin/env python3
"""
Mock test script — verify ADO connectivity, skill file availability,
and optionally Snowflake Cortex connectivity.

Modes:
  --check-skills   Check whether .agents/ skill files are accessible in the repo
  --check-cortex   Verify Snowflake Cortex is reachable and responding
  --dry-run        Print a mock review comment to stdout without posting to ADO
  (default)        Post a mock review comment to a PR to verify ADO write access

Usage:
    python mock_test.py --check-skills
    python mock_test.py --check-cortex
    python mock_test.py --pr <PR_ID> --dry-run
    python mock_test.py --pr <PR_ID>
"""

import argparse
import os
import sys
import requests
from requests.auth import HTTPBasicAuth

# ── ADO config — must match dbt_pr_review.py ─────────────────────────────────
ADO_ORG     = "your-ado-org"
ADO_PROJECT = "your-ado-project"
ADO_REPO    = "your-repo-name"

ADO_REPO_BASE   = f"https://dev.azure.com/{ADO_ORG}/{ADO_PROJECT}/_apis/git/repositories/{ADO_REPO}"
ADO_API_VERSION = "7.1"

CORTEX_MODEL = "claude-sonnet-4-6"

AGENT_FILES = {
    "readme":           "/.agents/README.md",
    "skill_sql":        "/.agents/skills/reviewing-sql-model-quality/SKILL.md",
    "skill_yaml":       "/.agents/skills/reviewing-model-yaml-and-tests/SKILL.md",
    "skill_yaml_check": "/.agents/skills/checking-model-yaml-entries/SKILL.md",
    "workflow_staging": "/.agents/workflows/peer-review-staging-model/WORKFLOW.md",
    "workflow_int":     "/.agents/workflows/peer-review-intermediate-model/WORKFLOW.md",
    "workflow_marts":   "/.agents/workflows/peer-review-marts-model/WORKFLOW.md",
}

MOCK_REVIEW = """## 🤖 AI Code Review

*Reviewing PR: example PR*
*Powered by Claude — this is a starting point for human review, not a replacement for it.*
*Review criteria: built-in dbt best practices*

---

### `/models/marts/orders/fct_orders.sql`
**Layer:** marts

**Verdict:** Merge after fixes

**Grain:** One row per order.

**What looks good:**
- Upstream refs are appropriate for the marts layer
- Status field has accepted_values test
- Model description is present and clear

**Must fix before merge:**
1. Join to `dim_customers` on `customer_id` looks like it could fan out — confirm this is a many-to-one join and add a comment if so
2. Primary key `order_id` is missing a `unique` test in the YAML

**Nice to have:**
- Consider adding a `not_null` test on `order_date` since it is used in downstream date logic
- The `order_status` CASE expression has an implicit else null — worth making that explicit

---

> **Reminder:** This AI review checks structural patterns and conventions. It does not replace CI job validation, data testing, or your team's business logic sign-off.

---
*⚠️ This is a MOCK review posted to test the ADO integration pipeline. Disregard the findings above.*"""


def ado_auth(token: str):
    return HTTPBasicAuth("", token)

def post_pr_comment(pr_id: int, comment_text: str, token: str) -> bool:
    url = f"{ADO_REPO_BASE}/pullRequests/{pr_id}/threads"
    payload = {
        "comments": [{"parentCommentId": 0, "content": comment_text, "commentType": 1}],
        "status": "active",
    }
    r = requests.post(url, auth=ado_auth(token), params={"api-version": ADO_API_VERSION}, json=payload)
    r.raise_for_status()
    return True

def check_skills(token: str):
    print("Checking for .agents/ folder and skill files...")
    print("=" * 65)
    readme_url = f"{ADO_REPO_BASE}/items"
    readme_params = {"path": "/.agents/README.md", "api-version": ADO_API_VERSION, "$format": "text"}
    try:
        r = requests.get(readme_url, auth=ado_auth(token), params=readme_params)
        if r.status_code == 404:
            print("  ℹ️  No .agents/ folder found in this repo.")
            print("      The script will use the built-in dbt best practices prompt.")
            print("=" * 65)
            return
    except Exception as e:
        print(f"  ❌  Could not reach ADO: {e}")
        return

    print("  📂 .agents/ folder found — checking individual skill files...")
    print()
    all_ok = True
    for name, path in AGENT_FILES.items():
        url = f"{ADO_REPO_BASE}/items"
        params = {"path": path, "api-version": ADO_API_VERSION, "$format": "text"}
        try:
            r = requests.get(url, auth=ado_auth(token), params=params)
            if r.status_code == 200 and len(r.text) > 0:
                print(f"  ✅ {name:20s}  {path}  ({len(r.text.split())} words)")
            elif r.status_code == 404:
                print(f"  ⚠️  {name:20s}  {path}  — not found (will be skipped)")
            else:
                print(f"  ❌ {name:20s}  {path}  — status {r.status_code}")
                all_ok = False
        except Exception as e:
            print(f"  ❌ {name:20s}  {path}  — error: {e}")
            all_ok = False

    print("=" * 65)
    if all_ok:
        print("✅ All skill files found. Custom skills will be used for reviews.")
    else:
        print("⚠️  Some skill files are missing — those will be skipped.")
        print("   Missing workflow files are fine if your team hasn't created them yet.")

def check_cortex(snowflake_pat: str, snowflake_account: str):
    print(f"Checking Snowflake Cortex connectivity ({snowflake_account})...")
    url = f"https://{snowflake_account}.snowflakecomputing.com/api/v2/cortex/v1/chat/completions"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {snowflake_pat}",
        "Accept": "application/json",
    }
    payload = {
        "model": CORTEX_MODEL,
        "messages": [{"role": "user", "content": "Reply with only the word: ready"}],
        "stream": False,
    }
    try:
        r = requests.post(url, headers=headers, json=payload)
        r.raise_for_status()
        response = r.json()["choices"][0]["message"]["content"]
        print(f"  ✅ Cortex responded: \"{response.strip()}\"")
        print(f"  ✅ Model: {CORTEX_MODEL}")
        print("✅ Snowflake Cortex is reachable. Ready for a real review run.")
    except requests.HTTPError as e:
        print(f"  ❌ HTTP error: {e}")
        try:
            print(f"  Response: {r.text}")
        except Exception:
            pass
        print("\nCommon causes:")
        print("  401 — PAT is invalid or expired")
        print("  403 — Network policy is blocking your IP")
        print("       Run: curl -s https://api.ipify.org  to find your IP")
        print("       Then add it to your Snowflake network policy (see README.md)")
        print("  404 — Account identifier is wrong")
        print('  {"message": "unknown model..."} — use claude-sonnet-4-6')
    except Exception as e:
        print(f"  ❌ Error: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Mock test — verify ADO and Cortex connectivity")
    parser.add_argument("--pr", type=int, help="ADO Pull Request ID")
    parser.add_argument("--ado-token", default=os.environ.get("ADO_TOKEN"), help="ADO Personal Access Token")
    parser.add_argument("--snowflake-pat", default=os.environ.get("SNOWFLAKE_PAT"), help="Snowflake PAT (for --check-cortex)")
    parser.add_argument("--snowflake-account", default=os.environ.get("SNOWFLAKE_ACCOUNT"), help="Snowflake account identifier (for --check-cortex)")
    parser.add_argument("--dry-run", action="store_true", help="Print mock comment to stdout without posting to ADO")
    parser.add_argument("--check-skills", action="store_true", help="Check .agents/ skill file availability")
    parser.add_argument("--check-cortex", action="store_true", help="Check Snowflake Cortex connectivity")
    args = parser.parse_args()

    if args.check_skills:
        if not args.ado_token:
            print("ERROR: --ado-token or ADO_TOKEN required for --check-skills")
            sys.exit(1)
        check_skills(args.ado_token)
    elif args.check_cortex:
        if not args.snowflake_pat or not args.snowflake_account:
            print("ERROR: SNOWFLAKE_PAT and SNOWFLAKE_ACCOUNT env vars (or flags) required for --check-cortex")
            sys.exit(1)
        check_cortex(args.snowflake_pat, args.snowflake_account)
    elif args.dry_run:
        print("DRY RUN — mock comment that would be posted to ADO:")
        print("=" * 60)
        print(MOCK_REVIEW)
        print("=" * 60)
        print("Nothing was posted.")
    else:
        if not args.pr:
            print("ERROR: --pr is required unless using --check-skills, --check-cortex, or --dry-run")
            sys.exit(1)
        if not args.ado_token:
            print("ERROR: --ado-token or ADO_TOKEN required")
            sys.exit(1)
        print(f"Posting mock review to PR #{args.pr}...")
        try:
            post_pr_comment(args.pr, MOCK_REVIEW, args.ado_token)
            print("✅ Mock review posted successfully! Check the PR in ADO.")
        except Exception as e:
            print(f"❌ Failed: {e}")