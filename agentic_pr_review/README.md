# dbt ADO PR Review
AI-powered peer review for dbt pull requests in Azure DevOps.

This script fetches changed dbt files from a pull request, reviews each file using an LLM, and posts a single structured review comment to the PR thread.

Supports **Claude (Anthropic)** by default, or **Snowflake Cortex** via the `--use-cortex` flag. See [Swapping the LLM](#swapping-the-llm) for OpenAI or Azure OpenAI.

---

## How it works

### Two-path review approach

**Path A — Custom skills (recommended):** If your repo has a `.agents/` folder at the project root containing skill and workflow files, the script loads those files at runtime and uses them as review criteria. When you update a skill file, reviews automatically improve on the next run without touching this script.

**Path B — Built-in dbt best practices:** If no `.agents/` folder is found, the script falls back to a built-in prompt based on dbt community best practices. It works out of the box for any dbt project.

### Review flow
1. Checks for `.agents/` skill files in the repo — loads them if found
2. Fetches PR metadata and changed files from ADO via REST API
3. Filters to reviewable dbt files (`.sql` and `.yml`/`.yaml` under `models/`)
4. Detects the layer for each file from its path
5. Sends each file to the LLM with the appropriate review criteria
6. Compiles all reviews into a single structured comment and posts it to the PR

### Layer detection

| Path contains | Layer | Notes |
|---|---|---|
| `/models/staging/` | staging | Standard dbt convention |
| `/models/bronze/` | staging | Medallion alias |
| `/models/intermediate/` | intermediate | Standard dbt convention |
| `/models/int/` | intermediate | Common shorthand |
| `/models/silver/` | intermediate | Medallion alias |
| `/models/marts/` | marts | Standard dbt convention |
| `/models/gold/` | marts | Medallion alias |

To customize, edit the `LAYER_MAP` list near the top of `dbt_pr_review.py`.

### Review output
Each file gets a structured review with a **Verdict**, layer-appropriate findings, **Must fix before merge**, and **Nice to have** sections.

> This AI review checks structural patterns and conventions. It does not replace CI job validation, data testing, or your team's business logic sign-off.

---

## What you need to supply

### 1. ADO configuration
Open `dbt_pr_review.py` and `mock_test.py` and fill in the config block near the top of each:

```python
ADO_ORG     = "your-ado-org"
ADO_PROJECT = "your-ado-project"
ADO_REPO    = "your-repo-name"
```

### 2. ADO Personal Access Token (PAT)
Scope required: **Code: Read & Write**

1. In ADO, click your profile icon → **Personal Access Tokens → New Token**
2. Under Scopes → Custom defined → check **Code: Read & write**
3. Click **Create** and copy the token immediately

### 3. LLM credentials

#### Option A — Anthropic (default)
Get an API key at [console.anthropic.com](https://console.anthropic.com) under API Keys.

#### Option B — Snowflake Cortex (`--use-cortex`)
Requires ACCOUNTADMIN or a role with `CREATE NETWORK POLICY`, `ALTER USER`, and Cortex model access.

**Step 1 — Generate a Snowflake Programmatic Access Token (PAT):**

In Snowflake: Profile → Settings → Authentication → Programmatic Access Tokens → Generate New Token. Copy it immediately — it is shown only once.

Or via SQL:
```sql
ALTER USER YOUR_USERNAME
  ADD PROGRAMMATIC ACCESS TOKEN pr_review_script
  ROLE_RESTRICTION = 'ACCOUNTADMIN'
  COMMENT = 'PR review script token';
```

**Step 2 — Set a network policy for your IP:**

Snowflake requires API calls to come from an approved IP address.

```bash
# Find your current IP
curl -s https://api.ipify.org
```

```sql
-- Create and attach a network policy (replace with your actual IP)
CREATE NETWORK POLICY pr_review_network_policy
  ALLOWED_IP_LIST = ('YOUR.IP.ADDRESS.HERE/32')
  COMMENT = 'Network policy for PR review script';

ALTER USER YOUR_USERNAME
  SET NETWORK_POLICY = pr_review_network_policy;
```

Clean up when done testing:
```sql
ALTER USER YOUR_USERNAME UNSET NETWORK_POLICY;
DROP NETWORK POLICY pr_review_network_policy;
```

**For Phase 2 (Azure Pipelines):**
- **Self-hosted agents (recommended):** Add the static IP(s) of your build agent machines to `ALLOWED_IP_LIST` permanently.
- **Microsoft-hosted agents:** IPs change weekly. Dynamically fetch the agent IP at pipeline runtime via `curl -s https://api.ipify.org` and update the policy before the review step runs.

---

## Setup

```bash
# 1. Create and activate a virtual environment
python3 -m venv venv
source venv/bin/activate       # Mac/Linux
venv\Scripts\activate          # Windows

# 2. Install dependencies
pip install requests

# 3. Create a .env file for your credentials (never commit this file)
touch .env
# Edit .env — choose one option:
#
# Anthropic (default):
# ADO_TOKEN=your_ado_pat_here
# ANTHROPIC_API_KEY=your_anthropic_key_here
#
# Snowflake Cortex:
# ADO_TOKEN=your_ado_pat_here
# SNOWFLAKE_PAT=your_snowflake_pat_here
# SNOWFLAKE_ACCOUNT=MYORG-MYACCOUNT

# 4. Load your credentials
export $(cat .env | xargs)
```

---

## Usage

### Verify connectivity first

```bash
# Check .agents/ skill files (both LLM paths)
python mock_test.py --check-skills

# Check Snowflake Cortex connectivity (Cortex path only)
python mock_test.py --check-cortex
```

### Test ADO write access

```bash
python mock_test.py --pr <PR_ID> --dry-run   # print without posting
python mock_test.py --pr <PR_ID>             # post mock comment to ADO
```

### Real review — Anthropic (default)

```bash
python dbt_pr_review.py --pr <PR_ID> --dry-run   # print to stdout
python dbt_pr_review.py --pr <PR_ID>              # post to ADO
```

### Real review — Snowflake Cortex

```bash
python dbt_pr_review.py --pr <PR_ID> --use-cortex --dry-run   # print to stdout
python dbt_pr_review.py --pr <PR_ID> --use-cortex              # post to ADO
```

---

## Adding custom skills to your repo

Create a `.agents/` folder at your dbt project root:

```
.agents/
  README.md
  skills/
    reviewing-sql-model-quality/
      SKILL.md
    reviewing-model-yaml-and-tests/
      SKILL.md
    checking-model-yaml-entries/
      SKILL.md
  workflows/
    peer-review-staging-model/
      WORKFLOW.md
    peer-review-intermediate-model/
      WORKFLOW.md
    peer-review-marts-model/
      WORKFLOW.md
```

Write skill files as instructions to an AI agent — clear, specific, and grounded in your team's actual conventions. Missing files are skipped gracefully.

---

## File reference

| File | Purpose |
|---|---|
| `dbt_pr_review.py` | Main script — loads skills, fetches PR, calls LLM, posts review |
| `mock_test.py` | Test script — verifies connectivity and skill files without calling the LLM |
| `azure-pipelines.yml` | Phase 2 pipeline trigger — drop into your dbt repo root |
| `.env` | Local credentials — never commit this |
| `.gitignore` | Excludes `.env` and Python artifacts from git |
| `README.md` | This file |

---

## Phase 2 — Pipeline automation

An `azure-pipelines.yml` file is included. See the inline comments for Anthropic vs Cortex configuration. The file needs two updates: your target branch name and your build agent pool name.

### Step-by-step

1. **Provision a build agent** — Linux, Python 3.10+, outbound HTTPS to ADO and your LLM endpoint
2. **Store credentials as secret pipeline variables** — Pipeline → Edit → Variables → lock icon
3. **Configure `azure-pipelines.yml`** — update branch name and pool name
4. **Add files to your dbt repo root** — `dbt_pr_review.py`, `mock_test.py`, `azure-pipelines.yml`
5. **Create the pipeline in ADO** — Pipelines → New Pipeline → Existing Azure Pipelines YAML file
6. **Test with a real PR** into your target branch

### Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Pipeline doesn't trigger | Branch name mismatch | Check `pr.branches.include` matches your branch |
| 401 on ADO API call | PAT expired or wrong scope | Regenerate with Code: Read & Write |
| 401 on Anthropic call | Wrong API key | Verify `ANTHROPIC_API_KEY` pipeline variable |
| 401/403 on Cortex call | PAT invalid or network policy blocking agent IP | Run `mock_test.py --check-cortex` locally; check network policy |
| Skill files not loading | `.agents/` path wrong or token lacks read access | Run `mock_test.py --check-skills` locally |
| No reviewable files found | Path filter too narrow | Check `paths` filter in `azure-pipelines.yml` |

---

## Swapping the LLM

The script supports Anthropic (default) and Snowflake Cortex (`--use-cortex`).

To use **OpenAI** or **Azure OpenAI**, update the `review_with_llm()` function in `dbt_pr_review.py`:

```python
# OpenAI
# URL: https://api.openai.com/v1/chat/completions
# Header: Authorization: Bearer YOUR_KEY
# Payload: {"model": "gpt-4o", "messages": [{"role": "system", ...}, {"role": "user", ...}]}
# Response: r.json()["choices"][0]["message"]["content"]

# Azure OpenAI
# URL: https://YOUR_RESOURCE.openai.azure.com/openai/deployments/YOUR_DEPLOYMENT/chat/completions?api-version=2024-02-01
# Header: api-key: YOUR_AZURE_KEY
```

---

## Phase 1 expansion opportunities

1. **Comment thread status management** — resolve the thread automatically when a re-run finds no must-fix items
2. **Work item linking** — parse the PR title for a ticket number and link the review thread to the ADO work item
3. **Re-run on new commits** — trigger a fresh review when the developer pushes fixes