#!/bin/zsh
# =============================================================================
# macOS セットアップ自動化スクリプト
# =============================================================================
#
# 使い方:
#   bash setup.sh           # 通常実行
#   bash setup.sh --dry-run # dry run (実際には何もしない)
#

set -euo pipefail

# -----------------------------------------------------------------------------
# dry run フラグ
# -----------------------------------------------------------------------------
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=true ;;
    *) echo "Unknown option: $arg"; exit 1 ;;
  esac
done

# -----------------------------------------------------------------------------
# カラー・ログ関数
# -----------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

log_section() {
  echo ""
  echo "${BOLD}${BLUE}================================================================${RESET}"
  echo "${BOLD}${BLUE}  $1${RESET}"
  echo "${BOLD}${BLUE}================================================================${RESET}"
}

log_info() {
  echo "  ${CYAN}[INFO]${RESET} $1"
}

log_ok() {
  echo "  ${GREEN}[OK]${RESET}   $1"
}

log_skip() {
  echo "  ${YELLOW}[SKIP]${RESET} $1 (すでにインストール済み)"
}

log_error() {
  echo "  ${RED}[ERROR]${RESET} $1" >&2
}

log_run() {
  if $DRY_RUN; then
    echo "  ${BOLD}[DRY]${RESET}  $1"
  else
    echo "  ${BOLD}[RUN]${RESET}  $1"
  fi
}

log_dry() {
  echo "  ${BOLD}${YELLOW}[DRY]${RESET}  $1 (dry run のためスキップ)"
}

# -----------------------------------------------------------------------------
# ユーティリティ関数
# -----------------------------------------------------------------------------
command_exists() {
  command -v "$1" &>/dev/null
}

brew_formula_installed() {
  brew list --formula "$1" &>/dev/null 2>&1
}

brew_cask_installed() {
  brew list --cask "$1" &>/dev/null 2>&1
}

# dry run 対応コマンド実行: dry run 時は表示のみ、実行しない
run_cmd() {
  log_run "$*"
  if ! $DRY_RUN; then
    "$@"
  fi
}

symlink_create() {
  local src="$1"
  local dst="$2"
  if [ -L "$dst" ]; then
    log_skip "シンボリックリンク: $dst"
    return
  fi
  if [ -e "$dst" ]; then
    log_info "$dst が既存ファイルとして存在します。バックアップして置換します。"
    if ! $DRY_RUN; then
      mv "$dst" "${dst}.bak.$(date +%Y%m%d%H%M%S)"
    fi
  fi
  run_cmd ln -sfn "$src" "$dst"
  if ! $DRY_RUN; then
    log_ok "シンボリックリンク作成: $dst -> $src"
  fi
}

# -----------------------------------------------------------------------------
# 1. Homebrew インストール
# -----------------------------------------------------------------------------
# dry run バナー
if $DRY_RUN; then
  echo ""
  echo "${BOLD}${YELLOW}================================================================${RESET}"
  echo "${BOLD}${YELLOW}  DRY RUN モード: 実際のインストールは行いません${RESET}"
  echo "${BOLD}${YELLOW}  [DRY] と表示された行はスキップされます${RESET}"
  echo "${BOLD}${YELLOW}================================================================${RESET}"
fi

log_section "1. Homebrew のインストール"

if command_exists brew; then
  log_skip "Homebrew"
else
  run_cmd /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Apple Silicon の場合はパスを通す
  if ! $DRY_RUN && [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  if ! $DRY_RUN; then log_ok "Homebrew インストール完了"; fi
fi

# brew コマンドを確実に使えるようにする
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

log_info "Homebrew バージョン: $(brew --version | head -1)"

# -----------------------------------------------------------------------------
# 2. Homebrew Formulae インストール
# -----------------------------------------------------------------------------
log_section "2. Homebrew Formulae のインストール"

FORMULAE=(
  glow
  git
  fzf
  fd
  jq
  lazygit
  neovim
  mise
  mas
  sheldon
  tmux
  tree
  tree-sitter
  yazi
  z
  zsh
  docker
)

# yazi の依存関係
FORMULAE_DEPS=(
  ffmpeg
  imagemagick
  poppler
  unar
)

log_info "依存関係パッケージをインストール..."
for pkg in "${FORMULAE_DEPS[@]}"; do
  if ! $DRY_RUN && brew_formula_installed "$pkg"; then
    log_skip "formula: $pkg"
  else
    run_cmd brew install "$pkg"
    if ! $DRY_RUN; then log_ok "formula インストール完了: $pkg"; fi
  fi
done

log_info "Formulae パッケージをインストール..."
for pkg in "${FORMULAE[@]}"; do
  if ! $DRY_RUN && brew_formula_installed "$pkg"; then
    log_skip "formula: $pkg"
  else
    run_cmd brew install "$pkg"
    if ! $DRY_RUN; then log_ok "formula インストール完了: $pkg"; fi
  fi
done

# -----------------------------------------------------------------------------
# 3. Homebrew Casks インストール
# -----------------------------------------------------------------------------
log_section "3. Homebrew Casks のインストール"

CASKS=(
  alt-tab
  claude
  cmux
  dbeaver-community
  figma
  font-code-new-roman-nerd-font
  font-fira-code-nerd-font
  font-hack-nerd-font
  ghostty
  google-chrome
  google-japanese-ime
  karabiner-elements
  keycastr
  notion
  notion-calendar
  notion-mail
  obsidian
  orbstack
  postman
  raycast
  shortcat
  slack
  spotify
  zoom
  visual-studio-code
  docker-desktop
)

# Nerd Font のために font tap が必要
if ! $DRY_RUN && brew tap | grep -q "homebrew/cask-fonts"; then
  log_skip "tap: homebrew/cask-fonts"
else
  run_cmd brew tap homebrew/cask-fonts
  if ! $DRY_RUN; then log_ok "tap 追加: homebrew/cask-fonts"; fi
fi

log_info "Casks パッケージをインストール..."
for pkg in "${CASKS[@]}"; do
  if ! $DRY_RUN && brew_cask_installed "$pkg"; then
    log_skip "cask: $pkg"
  else
    run_cmd brew install --cask "$pkg"
    if ! $DRY_RUN; then log_ok "cask インストール完了: $pkg"; fi
  fi
done

log_ok "Homebrew パッケージのインストールがすべて完了しました"

# -----------------------------------------------------------------------------
# 4. dotfiles シンボリックリンク (.zshrc / .zshenv / .zprofile)
# -----------------------------------------------------------------------------
log_section "4. zsh 設定ファイルのシンボリックリンク作成"

DOTFILES_DIR="$HOME/dotfiles"

for config in .zshrc .zshenv .zprofile; do
  src="${DOTFILES_DIR}/zsh/${config}"
  dst="${HOME}/${config}"
  if [ ! -f "$src" ]; then
    log_info "ソースファイルが存在しません: $src (スキップ)"
    continue
  fi
  symlink_create "$src" "$dst"
done

# -----------------------------------------------------------------------------
# 5. mise シンボリックリンク & ランタイムインストール
# -----------------------------------------------------------------------------
log_section "5. mise のセットアップ & ランタイムインストール"

MISE_CONFIG_SRC="${DOTFILES_DIR}/mise"
MISE_CONFIG_DST="${HOME}/.config/mise"

if [ -d "$MISE_CONFIG_SRC" ]; then
  symlink_create "$MISE_CONFIG_SRC" "$MISE_CONFIG_DST"
else
  log_info "mise dotfiles が存在しません: $MISE_CONFIG_SRC (シンボリックリンクはスキップ)"
fi

# mise を PATH に通す
export PATH="$HOME/.local/bin:$PATH"

if ! command_exists mise; then
  log_error "mise コマンドが見つかりません。Homebrew でインストールされているか確認してください。"
else
  log_info "mise バージョン: $(mise --version)"

  # mise でインストールするランタイム定義
  # 形式: "plugin@version"
  MISE_RUNTIMES=(
    "go@latest"
    "aws-cli@latest"
    "bun@latest"
    "docker-compose@latest"
    "gcloud@latest"
    "golangci-lint@latest"
    "golangci-lint@1.64.6"
    "lua@latest"
    "marp-cli@latest"
    "node@24.14.1"
    "node@22.26.0"
    "node@20.20.2"
    "pnpm@latest"
    "python@latest"
    "terraform@latest"
    "yarn@1.22.22"
    "yarn@4.9.4"
  )

  for runtime in "${MISE_RUNTIMES[@]}"; do
    plugin="${runtime%%@*}"
    version="${runtime##*@}"
    if ! $DRY_RUN && mise ls "$plugin" 2>/dev/null | grep -q "$version"; then
      log_skip "mise: $runtime"
    else
      run_cmd mise install "$runtime"
      if ! $DRY_RUN; then log_ok "mise インストール完了: $runtime"; fi
    fi
  done
fi

# -----------------------------------------------------------------------------
# 6. starship インストール & シンボリックリンク
# -----------------------------------------------------------------------------
log_section "6. starship のインストール & シンボリックリンク"

if ! $DRY_RUN && command_exists starship; then
  log_skip "starship"
else
  log_run "curl -sS https://starship.rs/install.sh | sh -s -- --yes"
  if ! $DRY_RUN; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    log_ok "starship インストール完了"
  fi
fi

STARSHIP_SRC="${DOTFILES_DIR}/shell/starship.toml"
STARSHIP_DST="${HOME}/.config/starship.toml"
mkdir -p "${HOME}/.config"
if [ -f "$STARSHIP_SRC" ]; then
  symlink_create "$STARSHIP_SRC" "$STARSHIP_DST"
else
  log_info "starship.toml が存在しません: $STARSHIP_SRC (スキップ)"
fi

# -----------------------------------------------------------------------------
# 7. sheldon シンボリックリンク & プラグインインストール
# -----------------------------------------------------------------------------
log_section "7. sheldon のセットアップ"

SHELDON_SRC="${DOTFILES_DIR}/shell/sheldon"
SHELDON_DST="${HOME}/.config/sheldon"

if [ -d "$SHELDON_SRC" ]; then
  symlink_create "$SHELDON_SRC" "$SHELDON_DST"
else
  log_info "sheldon dotfiles が存在しません: $SHELDON_SRC"
  log_info "デフォルト設定を生成します..."
  mkdir -p "$SHELDON_DST"
  if [ ! -f "${SHELDON_DST}/plugins.toml" ]; then
    log_run "sheldon plugins.toml を作成"
    cat > "${SHELDON_DST}/plugins.toml" << 'TOML'
shell = "zsh"

[plugins.zsh-completions]
github = "zsh-users/zsh-completions"
apply = ["source"]

[plugins.zsh-defer]
github = "romkatv/zsh-defer"

[plugins.zsh-syntax-highlighting]
github = "zsh-users/zsh-syntax-highlighting"
apply = ["defer"]
TOML
    log_ok "plugins.toml 作成完了"
  fi
fi

if ! $DRY_RUN && ! command_exists sheldon; then
  log_error "sheldon コマンドが見つかりません"
else
  run_cmd sheldon lock --update
  if ! $DRY_RUN; then log_ok "sheldon プラグインインストール完了"; fi
fi

# -----------------------------------------------------------------------------
# 8. wezterm シンボリックリンク
# -----------------------------------------------------------------------------
log_section "8. wezterm のシンボリックリンク"

WEZTERM_SRC="${DOTFILES_DIR}/shell/.wezterm.lua"
WEZTERM_DST="${HOME}/.config/.wezterm.lua"

if [ -f "$WEZTERM_SRC" ]; then
  symlink_create "$WEZTERM_SRC" "$WEZTERM_DST"
else
  log_info ".wezterm.lua が存在しません: $WEZTERM_SRC (スキップ)"
fi

# -----------------------------------------------------------------------------
# 9. neovim シンボリックリンク
# -----------------------------------------------------------------------------
log_section "9. neovim のシンボリックリンク"

NVIM_SRC="${DOTFILES_DIR}/nvim"
NVIM_DST="${HOME}/.config/nvim"

if [ -d "$NVIM_SRC" ]; then
  symlink_create "$NVIM_SRC" "$NVIM_DST"
else
  log_info "nvim dotfiles が存在しません: $NVIM_SRC (スキップ)"
fi

# -----------------------------------------------------------------------------
# 10. gemini-cli インストール (node 経由)
# -----------------------------------------------------------------------------
log_section "10. gemini-cli のインストール"

# mise でアクティベートされた node を使う
if command_exists mise; then
  eval "$(mise activate zsh)" 2>/dev/null || true
fi

if ! $DRY_RUN && ! command_exists node; then
  log_error "node が見つかりません。mise で node をインストールしてから再実行してください。"
else
  if ! $DRY_RUN && command_exists gemini; then
    log_skip "gemini-cli"
  else
    run_cmd npm install -g @google/gemini-cli
    if ! $DRY_RUN; then log_ok "gemini-cli インストール完了"; fi
  fi
fi

# -----------------------------------------------------------------------------
# 11. Claude Code インストール
# -----------------------------------------------------------------------------
log_section "11. Claude Code のインストール"

if ! $DRY_RUN && command_exists claude; then
  log_skip "Claude Code"
else
  log_run "curl -fsSL https://claude.ai/install.sh | bash"
  if ! $DRY_RUN; then
    curl -fsSL https://claude.ai/install.sh | bash
    log_ok "Claude Code インストール完了"
  fi
fi

# -----------------------------------------------------------------------------
# 完了サマリー
# -----------------------------------------------------------------------------
log_section "セットアップ完了"
echo ""
if $DRY_RUN; then
  echo "  ${YELLOW}${BOLD}dry run が完了しました。実際のインストールは行われていません。${RESET}"
  echo "  ${YELLOW}実行するには --dry-run オプションなしで再実行してください。${RESET}"
else
  echo "  ${GREEN}${BOLD}すべてのセットアップが完了しました！${RESET}"
fi
echo ""
echo "  次のステップ:"
echo "  ${CYAN}1.${RESET} ターミナルを再起動するか ${BOLD}source ~/.zshrc${RESET} を実行してください"
echo "  ${CYAN}2.${RESET} Google Japanese IME の設定を行ってください"
echo "  ${CYAN}3.${RESET} Karabiner-Elements の設定を確認してください"
echo "  ${CYAN}4.${RESET} mise でインストールしたランタイムを ${BOLD}mise use --global${RESET} で設定してください"
echo "  ${CYAN}5.${RESET} OrbStack / Docker Desktop を起動して動作確認してください"
echo ""
