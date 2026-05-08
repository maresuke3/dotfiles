#!/bin/bash

file="$1"
port=6275

if [ -z "$file" ]; then
  echo "Usage: $0 <file>" >&2
  exit 1
fi

# ディレクトリまたはPDFの場合はopenで開く
if [ -d "$file" ] || [[ "$file" == *.pdf ]]; then
  open "$file"
  exit 0
fi

# 既存のmoプロセスがあれば停止
if lsof -ti :"$port" >/dev/null 2>&1; then
  kill "$(lsof -ti :"$port")" 2>/dev/null
fi

# moでファイルを開く
mo "$file" --port "$port" &
mo_pid=$!

# サーバー起動を待機（最大5秒）
for i in $(seq 1 50); do
  curl -s -o /dev/null "http://127.0.0.1:$port/" && break
  sleep 0.1
done

# 既存のmoブラウザペインがあればフォーカス、なければ新規作成
existing_pane=$(cmux tree --all 2>/dev/null | grep -B1 "http://127.0.0.1:$port/" | grep -o 'pane pane:[0-9]*' | awk '{print $2}')

if [ -n "$existing_pane" ]; then
  cmux focus-pane --pane "$existing_pane"
else
  cmux new-pane --type browser --direction right --url "http://127.0.0.1:$port/"
fi
