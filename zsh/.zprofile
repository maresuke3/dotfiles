typeset -U path

## ───────────────────────────────────────────
## ログインシェルの初期化
## ───────────────────────────────────────────

# Homebrew
case "$OSTYPE" in
  darwin*)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
  linux*)
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ;;
esac

