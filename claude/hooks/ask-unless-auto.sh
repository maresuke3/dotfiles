#!/usr/bin/env bash
# PreToolUse(Bash) hook: auto mode 以外のときだけ、指定コマンドで確認プロンプトを出す
input=$(cat)

mode=$(jq -r '.permission_mode // empty' <<<"$input")
case "$mode" in
  default|acceptEdits|plan) ;;
  *) exit 0 ;;  # auto / bypassPermissions / dontAsk では何もしない
esac

cmd=$(jq -r '.tool_input.command // empty' <<<"$input")
# 旧 permissions.ask 相当。&& ; | $() で繋がれた後続コマンドや xargs/env 等の前置も対象にする
pattern='(^|[;&|(]|\$\()[[:space:]]*((xargs|env|nohup|time|command|exec|nice)([[:space:]]+-[^[:space:]]+)*[[:space:]]+|[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*(rm|rmdir|git (add|checkout|commit|pull|rebase|reflog|reset --soft|switch)|pnpm (install|add)|npm install|go (build|get)|composer|docker|docker-compose|herdr|terraform|make clean)([[:space:]]|$)'
if grep -qE "$pattern" <<<"$cmd"; then
  jq -n --arg m "$mode" '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: ("ask-unless-auto: " + $m + " mode")}}'
fi
exit 0
