---
name: herdr-loop
description: >-
  Orchestrates multi-agent loop engineering ("Cabinet Governance Model") using Herdr panes/tabs and Hunk live diff sessions.
  Use when the user asks for loop engineering, multi-agent coding/review orchestration, spawning sub-agents in Herdr panes/tabs, or running an autonomous implement-test-review cycle with Herdr and Hunk.
---

# Herdr × Hunk Cabinet Loop Engineering Skill (`herdr-loop`)

This skill defines the **Cabinet Governance Model (内閣統治型ループエンジニアリング)** where you act as the **Prime Minister (内閣総理大臣 / Main AI)** orchestrating **Ministers (各国務大臣 / Sub-Agents)** in visible **Herdr** panes/tabs while using **Hunk** (`watch = true`) as the shared review plaza (評定の広場) and final presentation board for the **Emperor (天皇 / User)**.

Make sure to also load or follow the `hunk-review` skill for exact `hunk session *` syntax.

---

## 0. Core Prerequisites & Safety Rules

1. **Verify Herdr Environment**:
   Before running any `herdr` command, verify you are inside a Herdr-managed pane:
   ```bash
   test "${HERDR_ENV:-}" = 1
   ```
   If this fails, inform the user that you are not running inside Herdr and stop.
2. **Never Launch Interactive TUIs Directly in Your Own Shell**:
   - Never run bare `herdr`, `hunk diff`, or `hunk show` directly in your own tool shell.
   - Always launch `hunk diff` inside a dedicated Herdr pane via `herdr pane run <pane_id> "hunk diff"`.
3. **Never Steal User Focus**:
   - Always pass `--no-focus` and `--cwd "$PWD"` to `herdr pane split`, `herdr tab create`, and `herdr pane move`.
   - Always target explicit IDs (`--current`, `$HERDR_PANE_ID`, `$HERDR_WORKSPACE_ID`, or parsed `.result.*` IDs from JSON).

---

## 1. Minister Appointment Rules (`--kind` Selection)

When spawning a Minister AI in a Herdr pane via `herdr agent start <name> --kind <kind> --pane <pane_id>`, strictly assign the agent kind by role:

| Role Category | Assigned `--kind` | Typical Minister Names (`[a-z][a-z0-9_-]{0,31}`) | Responsibilities |
| :--- | :--- | :--- | :--- |
| **Coding / Implementation / Code Review** | **`claude`** (Claude Code) | `coder`, `reviewer`, `fixer`, `refactorer` | Writing code, fixing bugs, performing strict code reviews on Hunk diffs |
| **Research / Investigation / Analysis** | **`agy`** (Antigravity CLI) | `researcher`, `investigator`, `architect` | Codebase exploration, specification analysis, dependency/impact research |

---

## 2. Layout Topologies (議事堂の部屋割り規約)

Before creating panes, inspect the current workspace layout (`herdr pane list --workspace "$HERDR_WORKSPACE_ID"` and `hunk session list --json`) so you reuse an existing Hunk Plaza pane if one is already running.

### Case A: Single Minister (大臣AIが1名のみの場合 — 1タブ内分割構成)

When only **1 Minister AI** is needed, keep everything visible inside the Prime Minister's current tab:
- **Left (or Top-Left)**: Prime Minister AI (`$HERDR_PANE_ID`)
- **Top-Right**: Hunk Plaza (`hunk diff` — auto-watching working tree)
- **Bottom-Left / Bottom-Right**: The single Minister AI pane and/or Verification (test/lint) pane.

```text
+-----------------------+-----------------------+
|                       |      Hunk Plaza       |
|   Prime Minister AI   |     (hunk diff)       |
|   ($HERDR_PANE_ID)    +-----------------------+
|                       |   Verification /      |
+-----------------------+   Minister AI Pane    |
|   Minister AI Pane    |                       |
|   (optional 4-split)  |                       |
+-----------------------+-----------------------+
```

**Setup Commands (Single Minister)**:
```bash
# 1. Create Top-Right pane for Hunk Plaza
HUNK_SPLIT=$(herdr pane split --pane "$HERDR_PANE_ID" --direction right --cwd "$PWD" --no-focus)
HUNK_PANE=$(echo "$HUNK_SPLIT" | jq -r '.result.pane.pane_id')
herdr pane rename "$HUNK_PANE" "Hunk-Plaza"
herdr pane run "$HUNK_PANE" "hunk diff"

# 2. Create Bottom-Right pane (for Verification/Test or Minister)
BR_SPLIT=$(herdr pane split --pane "$HUNK_PANE" --direction down --cwd "$PWD" --no-focus)
BR_PANE=$(echo "$BR_SPLIT" | jq -r '.result.pane.pane_id')

# 3. (If also splitting Bottom-Left for Minister while keeping Bottom-Right for tests)
BL_SPLIT=$(herdr pane split --pane "$HERDR_PANE_ID" --direction down --cwd "$PWD" --no-focus)
BL_PANE=$(echo "$BL_SPLIT" | jq -r '.result.pane.pane_id')
herdr pane rename "$BL_PANE" "Minister:coder"
herdr agent start coder --kind claude --pane "$BL_PANE"
```

---

### Case B: Two or More Ministers (大臣AIが2名以上の場合 — マルチタブ編成)

When **2 or more Minister AIs** are active (e.g., `researcher` + `coder`, or `coder` + `reviewer`), do **NOT** cram multiple Ministers into the main tab. Instead:

1. **Prime Minister's Tab (`$HERDR_TAB_ID`)**:
   - **Left**: Prime Minister AI (`$HERDR_PANE_ID`)
   - **Top-Right**: Hunk Plaza (`hunk diff`)
   - **Bottom-Right**: Free utility / verification pane (for running tests, builds, linters, or quick commands)
2. **Dedicated Tab per Minister**:
   - Create a separate tab for each Minister AI (`herdr tab create`), named clearly after the Minister's role.
   - *(Note: If you started with 1 Minister in a split pane on the main tab and now need a 2nd Minister, move the 1st Minister's pane to its own tab via `herdr pane move <pane_id> --new-tab --label "Minister:<name>" --no-focus` and create a new tab for the 2nd Minister.)*

**Setup Commands (Multi-Minister Tabs)**:
```bash
# 1. In Prime Minister's tab: Left = PM, Top-Right = Hunk Plaza, Bottom-Right = Free/Verify Pane
HUNK_SPLIT=$(herdr pane split --pane "$HERDR_PANE_ID" --direction right --cwd "$PWD" --no-focus)
HUNK_PANE=$(echo "$HUNK_SPLIT" | jq -r '.result.pane.pane_id')
herdr pane rename "$HUNK_PANE" "Hunk-Plaza"
herdr pane run "$HUNK_PANE" "hunk diff"

FREE_SPLIT=$(herdr pane split --pane "$HUNK_PANE" --direction down --cwd "$PWD" --no-focus)
FREE_PANE=$(echo "$FREE_SPLIT" | jq -r '.result.pane.pane_id')
herdr pane rename "$FREE_PANE" "Verify-Sandbox"

# 2. Spawn Minister 1 (e.g., Researcher -> agy) in its own Tab
TAB1_JSON=$(herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$PWD" --label "Minister:researcher" --no-focus)
RES_PANE=$(echo "$TAB1_JSON" | jq -r '.result.root_pane.pane_id')
herdr agent start researcher --kind agy --pane "$RES_PANE"

# 3. Spawn Minister 2 (e.g., Coder -> claude) in its own Tab
TAB2_JSON=$(herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$PWD" --label "Minister:coder" --no-focus)
CODER_PANE=$(echo "$TAB2_JSON" | jq -r '.result.root_pane.pane_id')
herdr agent start coder --kind claude --pane "$CODER_PANE"

# 4. Spawn Minister 3 (e.g., Reviewer -> claude) in its own Tab
TAB3_JSON=$(herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$PWD" --label "Minister:reviewer" --no-focus)
REV_PANE=$(echo "$TAB3_JSON" | jq -r '.result.root_pane.pane_id')
herdr agent start reviewer --kind claude --pane "$REV_PANE"
```

---

## 3. Cabinet Loop Protocol (閣内ループ〜献上〜退勤の実行手順)

### Step 1: Dispatch & Monitor Ministers (指揮・実装・調査)

Send instructions to Ministers and wait for completion:
```bash
herdr agent prompt coder "Implement feature X according to the plan. Run tests and annotate key decisions in Hunk." --wait --timeout 300000
herdr agent read coder --source recent-unwrapped --lines 120
```
- If `agent prompt` returns `agent_blocked` or `blocked`, inspect `herdr agent read <name> --source visible` and ask the user before approving any prompt.

### Step 2: Check for Emperor's Direct Intervention (有事の直接介入チェック)

Because `watch = true` streams all changes to the Hunk Plaza in real time, the User (Emperor) may drop inline `user` notes in Hunk at any point during the loop.
Always check for human notes between iterations:
```bash
hunk session comment list --repo . --type user --json
```
- If any `user` notes exist, **treat them as top-priority imperial decrees**: immediately instruct the responsible Minister to address them and reply via `hunk session comment add --repo . --reply-to <noteId> --summary "..."`.

### Step 3: Cross-Minister Review via Hunk Plaza (閣内相互レビューと検証)

Before presenting the work to the User:
1. Run the test suite / linter in the Verification pane (`$FREE_PANE` or `$BR_PANE`):
   ```bash
   herdr pane run "$FREE_PANE" "<test-command>"
   ```
2. Have the `reviewer` Minister (`--kind claude`) or yourself inspect the diff in Hunk (`hunk session review --repo . --include-notes --json`) and post actionable review comments on Hunk (`hunk session comment apply --repo . --stdin --json`).
3. If issues or test failures are found, loop back with `coder` until all tests pass and all review comments are resolved.

### Step 4: Presentation to the Emperor & Standby (献上と待機状態)

Once the inner loop converges and quality is assured:
1. Clear internal AI-to-AI scratch notes from Hunk so the plaza is clean for the User (never pass `--include-user` or `--all`):
   ```bash
   hunk session comment clear --repo . --yes --json
   ```
2. Apply concise, high-signal presentation annotations on Hunk (`hunk session comment apply --repo . --stdin --focus --json`) highlighting architectural intent, trade-offs, and key lines for the User to inspect.
3. **Keep all Ministers on standby (`idle`)**:
   - **Do NOT close Minister panes or tabs upon presentation.**
   - If the User is not yet satisfied or adds new `user` notes in Hunk, immediately put the idle Ministers back to work ("馬車馬モード") to iterate until the User is satisfied.

### Step 5: Dismissal / Clocking Out (ご満悦後の退勤・ペイン閉鎖)

Only when the User explicitly expresses satisfaction (e.g., "OK", "満足", "LGTM", "完了", "退勤してよし"):
- Close all Minister tabs and/or Minister panes that you created for this task:
  ```bash
  # Close dedicated Minister tabs:
  herdr tab close <minister_tab_id>
  # Or close Minister pane in the main tab:
  herdr pane close <minister_pane_id>
  ```
- Leave the Prime Minister's pane and the `Hunk-Plaza` pane open unless the User asks to close Hunk as well.
