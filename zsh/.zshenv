typeset -U path

## ───────────────────────────────────────────
## 環境変数（全シェル共通）
## ───────────────────────────────────────────

# editor setting
export EDITOR=nvim
export VISUAL=nvim

# Cargo
# [[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# go env settings
export GO111MODULE=on

# PHP env value
export PHP_CONFIGURE_OPTS="--without-gd"

# local bin (sheldon etc...)
path=($HOME/.local/bin $path)
