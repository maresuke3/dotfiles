# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# starship setting
eval "$(starship init zsh)"
# plugin manager setting
eval "$(sheldon source)"

## 補完機能の導入
autoload -Uz compinit
compinit -u

## 補完の背景色付け
autoload -Uz colors
colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

zstyle ':completion:*' menu select

# 単語の途中で補完を有効化
setopt complete_in_word

# 補完候補をハイライト
zstyle ':completion:*:default' menu select=1
# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true
# 大文字、小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# aliasの設定
alias gonbe="pokemon 446"
alias rukario="pokemon 448"
alias syandera="pokemon 609"
alias arigeitsu="pokemon 159"
alias ls="ls -FG"    # ディレクトリの色付け
alias l="ls -a"
alias ll="ls -l"
alias la="ls -la"
alias ..="cd .."
alias vim="nvim"
alias sed="gsed"

# gitのalias
alias st='git status'
alias sw='git switch'
alias swc='git switch -c'
alias ad='git add'
alias cm='git commit'
alias gpl='git pull'
alias gps='git push'
alias log='git log'

# anyenvの設定
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# pyenv

# pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# ndoenv
eval "$(nodenv init - zsh)"

# goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/shims:$PATH"
export GO111MODULE=on
eval "$(goenv init -)"
export GOPRIVATE=gitlab.chamo-chat.com/*

# gomock
#export PATH=$PATH:$(go env GOPATH)/bin

# gcp sdk
export GOOGLE_APPLICATION_CREDENTIALS='~/.gcp/credential.json'

export PATH="/usr/local/sbin:$PATH"

# glow
alias md='glow -p -'

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

eval "(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
