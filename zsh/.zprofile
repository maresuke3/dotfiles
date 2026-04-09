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

# mise settings
eval "$(mise activate zsh)"

# pyenv-virtualenv
if (( $+commands[pyenv-virtualenv-init] )); then
  eval "$(pyenv virtualenv-init -)"
fi

# zoxide
eval "$(zoxide init zsh)"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
