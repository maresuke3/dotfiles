---
name: hunk-review
description: >-
  Interacts with live Hunk diff review sessions via CLI (`hunk session *`) for interactive AI coding and code review.
  Use when the user has a Hunk session running, asks to explain or annotate changes in Hunk, asks to check/read/fix inline comments left in Hunk, or wants an interactive diff walkthrough.
---

# Hunk Interactive Coding & Review Skill (`watch = true` Environment)

Hunk is an interactive terminal diff viewer used for collaborative coding and review between the human and the AI agent.

## 0. Core Rules & Environment Assumptions

1. **NEVER run interactive TUI commands directly**:
   - Do **NOT** run `hunk diff`, `hunk show`, `hunk log`, or bare `hunk` in your shell tool — they launch an interactive TUI and will hang your execution.
   - Always use non-interactive `hunk session *` CLI commands to inspect and control live sessions through the local Hunk daemon.
   - If no active session exists (`"sessions": []` or `"No active Hunk sessions"`), ask the user to run `hunk diff` in their terminal pane first.
2. **`watch = true` is enabled by default in `~/.config/hunk/config.toml`**:
   - When the user runs `hunk diff`, Hunk automatically watches the working tree and live-reloads whenever files are created, edited, or saved.
   - **Do NOT run `hunk session reload --repo . -- diff` after normal file edits.** Let Hunk's built-in file watcher update the diff automatically. Unnecessary `reload` calls waste tool turns and reset visual highlights.
   - Only use `hunk session reload` when explicitly switching the review target (e.g., switching to `show HEAD~1`, `diff main...HEAD`, `diff --staged`, `diff --exclude-untracked`, or returning to working-tree `diff` from another target).

---

## 1. Interactive Engineering Workflows

### Workflow A: Post-Implementation Self-Review & Annotation (AI → Human)

When you finish implementing a feature/fix and want to hand it off for review in Hunk (or when the user asks you to annotate/explain your changes in Hunk):

1. **Verify the live session & inspect current diff structure**:
   ```bash
   hunk session review --repo . --include-notes --json
   ```
   - This returns `.review.files` (each with `path` and `hunks: [{ index, header, oldRange, newRange }]`) and `.review.reviewNotes` without inflating context with raw patch text.
   - Only add `--include-patch` if you did not author the changes yourself and need to read the raw unified diff text.
2. **Clean up stale AI comments (if re-annotating after major edits)**:
   - If old agent notes from a previous iteration are now obsolete, clear only agent notes (preserving human `user` notes):
   ```bash
   hunk session comment clear --repo . --yes
   ```
   *(Never pass `--include-user` or `--all` unless the user explicitly asks to wipe their own notes.)*
3. **Batch-apply focused inline annotations**:
   - Annotate non-obvious design decisions (Intent), edge cases or risks to verify (Risk), or open questions for the user (Question).
   - Prefer a single `comment apply --stdin` call over multiple `comment add` calls:
   ```bash
   printf '%s\n' '{
     "comments": [
       {
         "filePath": "src/handler.ts",
         "newLine": 42,
         "summary": "Validate payload before state mutation",
         "rationale": "Prevents partial updates when optional fields are malformed."
       }
     ]
   }' | hunk session comment apply --repo . --stdin --focus --json
   ```
   - Keep notes concise and high-signal; do not comment on every trivial hunk.

---

### Workflow B: Addressing Human Inline Comments (Human → AI → Human)

When the user adds inline comments (`user` notes) in the Hunk TUI and asks you to check Hunk comments, answer questions, or fix the flagged code:

1. **Fetch human-authored inline comments**:
   ```bash
   hunk session comment list --repo . --type user --json
   ```
   - To see full conversation threads (both human and agent notes), use `--type all`.
   - Returns `.comments`: each item includes `noteId` (e.g., `"user:1"`), `source` (`"user"` or `"agent"`), `filePath`, `hunkIndex`, `newRange` / `oldRange` (`[start, end]`), and `body`.
2. **Implement fixes & verify**:
   - Edit the requested files and run relevant tests/linters.
   - Because `watch = true` is active, Hunk will automatically reload the updated working-tree diff as soon as files are saved (do **not** run `hunk session reload`).
3. **Reply directly to each human comment thread**:
   - Reply to each addressed `user:<id>` note so the user can see the resolution inline in Hunk:
   ```bash
   # Single reply:
   hunk session comment add --repo . --reply-to user:1 --summary "Fixed: extracted validation helper and added nil guard." --json

   # Or batch multiple replies (and any new root comments) in one call:
   printf '%s\n' '{
     "comments": [
       {
         "replyTo": "user:1",
         "summary": "Fixed: extracted validation helper and added nil guard."
       },
       {
         "replyTo": "user:2",
         "summary": "Kept this synchronous because the caller already holds the mutex."
       }
     ]
   }' | hunk session comment apply --repo . --stdin --focus --json
   ```

---

### Workflow C: Guided Walkthrough & Pair Review (Navigation & Attention Marks)

When walking the user through a changeset interactively:

1. **Steer the user's viewport** to the file and line under discussion before or while explaining it:
   ```bash
   hunk session navigate --repo . --file src/App.tsx --new-line 120 --json
   ```
2. **Light up specific expressions** with character-range attention marks (`[start, end)` in 0-based UTF-16 code units):
   ```bash
   hunk session highlight add --repo . --file src/App.tsx --new-line 120 --start 8 --end 24 --tone warning --focus --json
   ```
   - Clear highlights with `hunk session highlight clear --repo .` before moving to the next topic.

---

## 2. CLI Reference (`hunk session *`)

### Session Selection

Most session commands accept:
- `--repo <path>` — match the live session by its loaded repo root (most common: `--repo .`)
- `<session-id>` — match by exact ID (use when multiple sessions share a repo)
- If only one session exists, it auto-resolves.

### Inspect

```bash
hunk session list [--json]
hunk session get (<session-id> | --repo <path>) [--json]
hunk session context (<session-id> | --repo <path>) [--json]
hunk session review (<session-id> | --repo <path>) [--include-patch] [--include-notes] [--json]
```

- `get` shows the session `Path`, `Repo`, and `Source`.
- `context` shows the user's current cursor/viewport focus and active experimental features.
- `review --json` returns file and hunk structure by default; add `--include-patch` only when raw unified diff text is needed, and `--include-notes` to include live review notes.

### Navigate

```bash
hunk session navigate (<session-id> | --repo <path>) --file <path> (--hunk <n> | --old-line <n> | --new-line <n>) [--json]
hunk session navigate (<session-id> | --repo <path>) --comment <id> [--json]
hunk session navigate (<session-id> | --repo <path>) (--next-comment | --prev-comment) [--json]
```

- `--hunk <n>` is 1-based.
- `--new-line` / `--old-line` are 1-based line numbers on that diff side.
- Specify exactly one target (`--hunk`, `--old-line`, or `--new-line`, or `--comment <id>`, or `--next-comment` / `--prev-comment`).

### Comments

```bash
hunk session comment add (<session-id> | --repo <path>) (--reply-to <note-id> | --file <path> (--old-line <n> | --new-line <n>)) --summary <text> [--rationale <text>] [--author <name>] [--markup <stml>] [--focus] [--json]
hunk session comment apply (<session-id> | --repo <path>) --stdin [--focus] [--json]
hunk session comment list (<session-id> | --repo <path>) [--file <path>] [--type <live|all|ai|agent|user>] [--json]
hunk session comment rm (<session-id> | --repo <path>) <comment-id> [--json]
hunk session comment clear (<session-id> | --repo <path>) [--file <path>] [--include-user|--all] --yes [--json]
```

- `comment list --type user --json` lists human-authored inline notes.
- Root notes require `--file`, `--summary`, and either `--old-line` or `--new-line`.
- Replies use `--reply-to <note-id>` with `--summary` and inherit the parent's anchor.
- `comment apply --stdin` accepts `{ "comments": [ ... ] }` where each item has `summary` plus either `replyTo` or `filePath` + one target (`newLine`, `oldLine`, or `hunk`).

### Attention Marks (Highlights)

```bash
hunk session highlight add (<session-id> | --repo <path>) --file <path> (--old-line <n> | --new-line <n>) --start <n> --end <n> [--tone <tone>] [--focus] [--json]
hunk session highlight clear (<session-id> | --repo <path>) [--file <path>] [--json]
```

- `--start` is 0-based inclusive and `--end` is exclusive (`[start, end)` in UTF-16 code units).
- Tones: `match` (default), `info`, `warning`, `error`, `dim`, `current` (reverse video).

### Reload (Target Switching Only)

Because `watch = true` is enabled in config, only use `reload` when switching *what* diff target Hunk is displaying:

```bash
hunk session reload --repo . -- diff
hunk session reload --repo . -- diff --staged
hunk session reload --repo . -- diff --exclude-untracked
hunk session reload --repo . -- diff main...HEAD
hunk session reload --repo . -- show HEAD~1
```

### Troubleshooting / Common Errors

- **"No active Hunk sessions"**:
  - If the user says Hunk is running, the command sandbox may be blocking the local socket/localhost connection; retry with unsandboxed execution if needed. Otherwise, ask the user to launch `hunk diff` in their terminal.
- **"No diff file matches ..."**:
  - The file has no uncommitted changes in the current diff view, or Hunk is viewing a different target. Run `hunk session review --repo . --json` to inspect loaded files.
- **"daemon-build-mismatch"**:
  - Inform the user which build is newer and how many windows are attached, and ask for confirmation before running `hunk daemon restart --yes`.
