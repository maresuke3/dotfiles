# plugin manager setting
fpath=(~/dotfiles/zsh/completions ~/.zsh $fpath)

## ───────────────────────────────────────────
## ヒストリ設定
## ───────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt SHARE_HISTORY          # 複数タブ/ペインで履歴を共有
setopt INC_APPEND_HISTORY     # 実行のたびに履歴ファイルへ追記
setopt HIST_IGNORE_DUPS       # 直前と同じコマンドは残さない
setopt HIST_IGNORE_ALL_DUPS   # 重複は全て除去
setopt HIST_FIND_NO_DUPS      # 検索時も重複を飛ばす
setopt HIST_IGNORE_SPACE      # 先頭スペース付きのコマンドは記録しない
setopt HIST_REDUCE_BLANKS     # 余分な空白を削除
setopt EXTENDED_HISTORY       # タイムスタンプ付きで保存

## alias settings ##
# base aliasの設定
alias gonbe="pokemon 446"
alias rukario="pokemon 448"
alias syandera="pokemon 609"
alias arigeitsu="pokemon 159"
alias ls="ls --color=auto"    # ディレクトリの色付け
alias l="ls -a"
alias ll="ls -l"
alias la="ls -la"
alias ..="cd .."
alias vim="nvim"
#alias sed="gsed"

# gitのalias
alias st='git status'
alias sw='git switch'
alias swc='git switch -c'
alias ad='git add'
alias cm='git commit'
alias gpl='git pull'
alias gps='git push'
alias log='git log'

# glow's alias
alias md='glow -p -'

# mapr's alias
alias devmarp='marp -s . --html'


## ───────────────────────────────────────────
## zsh-autosuggestions
## ───────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888888"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
bindkey '^ ' autosuggest-accept

## ───────────────────────────────────────────
## zsh-syntax-highlighting
## ───────────────────────────────────────────
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)


## -------------------------------------------
## any plugin settings
## -------------------------------------------
# mise settings
# shims mode: precmd hook を廃止し起動を高速化
path=($HOME/.local/share/mise/shims $path)
# もし自動的な環境切り替えが必要な場合は以下を有効にしてください
# eval "$(mise activate zsh)"


# ==============================================================
# sheldon & mise CLI 補完スクリプトを ~/.zsh にキャッシュして高速化
# ==============================================================
mkdir -p ~/.zsh
_ZCOMPDUMP_NEEDS_REFRESH=0

# sheldon source の出力をキャッシュして高速化
if [[ ! -f ~/.zsh/sheldon.zsh || ~/.config/sheldon/plugins.toml -nt ~/.zsh/sheldon.zsh ]]; then
  sheldon completions --shell zsh > ~/.zsh/_sheldon
  sheldon source > ~/.zsh/sheldon.zsh
  _ZCOMPDUMP_NEEDS_REFRESH=1
fi

# 1) mise インストールディレクトリ内の同梱補完ファイルをコピー（プロセス起動不要）
_copy_mise_comp() {
  local target="$1" src="$2"
  if [[ ! -f "$target" && -n "$src" && -f "$src" ]]; then
    cp "$src" "$target"
    _ZCOMPDUMP_NEEDS_REFRESH=1
  fi
}
if [[ ! -f ~/.zsh/_rg || ! -f ~/.zsh/_fd || ! -f ~/.zsh/_glow || ! -f ~/.zsh/_yazi || ! -f ~/.zsh/_ya || ! -f ~/.zsh/_hx ]]; then
  _copy_mise_comp ~/.zsh/_rg   "$HOME"/.local/share/mise/installs/ripgrep/*/ripgrep-*/complete/_rg(N[-1])
  _copy_mise_comp ~/.zsh/_fd   "$HOME"/.local/share/mise/installs/fd/*/fd-*/autocomplete/_fd(N[-1])
  _copy_mise_comp ~/.zsh/_glow "$HOME"/.local/share/mise/installs/glow/*/glow_*/completions/glow.zsh(N[-1])
  _copy_mise_comp ~/.zsh/_yazi "$HOME"/.local/share/mise/installs/yazi/*/yazi-*/completions/_yazi(N[-1])
  _copy_mise_comp ~/.zsh/_ya   "$HOME"/.local/share/mise/installs/yazi/*/yazi-*/completions/_ya(N[-1])
  _copy_mise_comp ~/.zsh/_hx   "$HOME"/.local/share/mise/installs/helix/*/helix-*/contrib/completion/hx.zsh(N[-1])
fi

# 2) CLI の completion サブコマンドから生成してキャッシュ（初回のみ実行）
_gen_zsh_comp() {
  local target="$1"
  shift
  if [[ ! -f "$target" ]] && command -v "$1" >/dev/null 2>&1; then
    if "$@" > "$target.tmp" 2>/dev/null && grep -q '^#compdef' "$target.tmp" 2>/dev/null; then
      mv "$target.tmp" "$target"
      _ZCOMPDUMP_NEEDS_REFRESH=1
    else
      rm -f "$target.tmp"
    fi
  fi
}
_gen_zsh_comp ~/.zsh/_herdr         herdr completion zsh
# _gen_zsh_comp ~/.zsh/_hunk          hunk completion zsh
_gen_zsh_comp ~/.zsh/_uv            uv generate-shell-completion zsh
_gen_zsh_comp ~/.zsh/_pnpm          pnpm completion zsh
_gen_zsh_comp ~/.zsh/_deno          deno completions zsh
_gen_zsh_comp ~/.zsh/_golangci-lint golangci-lint completion zsh
_gen_zsh_comp ~/.zsh/_starship      starship completions zsh
_gen_zsh_comp ~/.zsh/_codex         codex completion zsh
_gen_zsh_comp ~/.zsh/_tree-sitter   tree-sitter complete --shell zsh
if [[ ! -f ~/.zsh/_bun ]] && command -v bun >/dev/null 2>&1; then
  if SHELL=zsh bun completions > ~/.zsh/_bun.tmp 2>/dev/null && grep -q '^#compdef' ~/.zsh/_bun.tmp 2>/dev/null; then
    mv ~/.zsh/_bun.tmp ~/.zsh/_bun
    _ZCOMPDUMP_NEEDS_REFRESH=1
  else
    rm -f ~/.zsh/_bun.tmp
  fi
fi

if (( _ZCOMPDUMP_NEEDS_REFRESH )); then
  rm -f "${ZDOTDIR:-$HOME}/.zcompdump"
fi
unset -f _copy_mise_comp _gen_zsh_comp
unset _ZCOMPDUMP_NEEDS_REFRESH

source ~/.zsh/sheldon.zsh

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
zsh-defer source ~/.orbstack/shell/init.zsh 2>/dev/null || :


## ───────────────────────────────────────────
## 補完設定
## ───────────────────────────────────────────
# 単語の途中で補完を有効化
setopt complete_in_word

# 補完候補をハイライト
zstyle ':completion:*' menu select=2

# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true

# 大文字、小文字を区別せず補完する
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z-_}={A-Za-z_-}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# 補完候補の説明グループを表示
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# 補完の背景色付け
autoload -Uz colors
colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# エラー時のメッセージ
zstyle ':completion:*:warnings' format '%F{red}No matches%f'

# プロセス補完（kill などで便利）
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ==============================================================
# 補完スクリプトのパスをキャッシュして起動を高速化
# ==============================================================
CACHE_FILE="$HOME/.zsh_comp_paths_cache"

# キャッシュファイルが存在しない場合のみ、パスを探して保存する
if [ ! -f "$CACHE_FILE" ]; then
  _GCLOUD_ROOT=$(gcloud info --format='value(installation.sdk_root)' 2>/dev/null)
  _TF_LATEST=$(find "$HOME/.local/share/mise/installs/terraform" -maxdepth 2 -type f -name terraform 2>/dev/null | sort -V | tail -n 1)
  _AWS_COMPLETER=$(mise which aws_completer 2>/dev/null)
  
  echo "export _GCLOUD_ROOT=\"$_GCLOUD_ROOT\"" > "$CACHE_FILE"
  echo "export _TF_LATEST=\"$_TF_LATEST\"" >> "$CACHE_FILE"
  echo "export _AWS_COMPLETER=\"$_AWS_COMPLETER\"" >> "$CACHE_FILE"
fi

# キャッシュされたパスを読み込む
source "$CACHE_FILE"

# ==============================================================
# 以下、既存のロジックと全く同じ補完の有効化処理
# ==============================================================

# Google Cloud SDK
if [ -n "$_GCLOUD_ROOT" ] && [ -f "$_GCLOUD_ROOT/completion.zsh.inc" ]; then
  source "$_GCLOUD_ROOT/completion.zsh.inc"
elif [ -f "/usr/share/google-cloud-sdk/completion.zsh.inc" ]; then
  source "/usr/share/google-cloud-sdk/completion.zsh.inc"
fi

# Terraform completion (must be after compinit/sheldon)
autoload -U +X bashcompinit && bashcompinit
if [ -n "$_TF_LATEST" ]; then
  complete -o nospace -C "$_TF_LATEST" terraform
fi

# AWS CLI completion
if [ -n "$_AWS_COMPLETER" ]; then
  complete -C "$_AWS_COMPLETER" aws
fi



## ───────────────────────────────────────────
## zoxide, starship & fzf (must be after compinit)
## ───────────────────────────────────────────
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
if [[ ! -f ~/.zsh/fzf.zsh ]] && command -v fzf >/dev/null 2>&1; then
  fzf --zsh > ~/.zsh/fzf.zsh 2>/dev/null
fi
[[ -f ~/.zsh/fzf.zsh ]] && source ~/.zsh/fzf.zsh

## ───────────────────────────────────────────
## WSL用 CLIラッパー (Windowsの.exeをLinux名で扱えるようにする)
## ───────────────────────────────────────────
if [ -n "$WSL_DISTRO_NAME" ]; then
    # wsl_binディレクトリを作成
    mkdir -p "$HOME/.wsl_bin"
    # wezterm -> wezterm.exe のラッパーを動的に作成
    if [ ! -f "$HOME/.wsl_bin/wezterm" ]; then
        echo '#!/bin/sh' > "$HOME/.wsl_bin/wezterm"
        echo 'wezterm.exe "$@"' >> "$HOME/.wsl_bin/wezterm"
        chmod +x "$HOME/.wsl_bin/wezterm"
    fi
    # PATHの先頭に追加
    export PATH="$HOME/.wsl_bin:$PATH"
fi


# =============================================================================
# mise aliases
# =============================================================================
# `mise use -g` writes to config.toml, which breaks our conf.d/ separation.
# Use `mguse` (mise global use) to safely write tools to tools.toml instead.
alias mguse="mise use --path ~/dotfiles/mise/conf.d/tools.toml"
