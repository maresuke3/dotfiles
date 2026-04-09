## ───────────────────────────────────────────
## 補完設定
## ───────────────────────────────────────────
autoload -Uz compinit

# OSに応じた日次キャッシュ（macOS / Linux 両対応）
_compinit_with_cache() {
  local zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  local today
  today=$(date +'%j')

  local mtime
  if [[ "$OSTYPE" == darwin* ]]; then
    mtime=$(stat -f '%Sm' -t '%j' "$zcompdump" 2>/dev/null)
  else
    # Linux (GNU stat)
    mtime=$(stat -c '%y' "$zcompdump" 2>/dev/null | date -d "$(cat)" +'%j' 2>/dev/null)
  fi

  if [[ "$today" != "$mtime" ]]; then
    compinit
  else
    compinit -C
  fi
}
_compinit_with_cache
unfunction _compinit_with_cache

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
# starship setting
eval "$(starship init zsh)"
# plugin manager setting
eval "$(sheldon source)"
# mise setting
eval "$(mise activate zsh)"
