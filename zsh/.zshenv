typeset -U path

## ───────────────────────────────────────────
## 環境変数（全シェル共通）
## ───────────────────────────────────────────

# editor setting
export EDITOR=nvim
export VISUAL=nvim

# Cargo
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# go env settings
export GO111MODULE=on
export GOPRIVATE=<REDACTED>

# gcp sdk
export GOOGLE_APPLICATION_CREDENTIALS=<REDACTED>
#export PATH="/usr/local/sbin:$PATH"

# PHP env value
export PHP_CONFIGURE_OPTS="--without-gd"

# ClaudeCode
# this setting is only office
#export CLAUDE_CODE_USE_VERTEX=1
#export CLOUD_ML_REGION=global
#export ANTHROPIC_VERTEX_PROJECT_ID=<REDACTED>

# local bin (sheldon etc...)
path=($HOME/.local/bin $path)
