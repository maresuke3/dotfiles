#!/bin/bash
# =============================================================================
# Linux (Ubuntu/WSL) 初期セットアップスクリプト
# =============================================================================
#
# 使い方:
#   bash ~/dotfiles/cmd/setup_linux.sh           # 通常実行
#   bash ~/dotfiles/cmd/setup_linux.sh --dry-run # 実行内容の確認のみ
#

set -euo pipefail

DOTFILES_DIR="${HOME}/dotfiles"

# -----------------------------------------------------------------------------
# オプション解析
# -----------------------------------------------------------------------------
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=true ;;
    *) echo "Unknown option: $arg"; exit 1 ;;
  esac
done

# -----------------------------------------------------------------------------
# ログ関数
# -----------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

log_section() { echo -e "\n${BOLD}${BLUE}=== $1 ===${RESET}"; }
log_ok()      { echo -e "  ${GREEN}[OK]${RESET}   $1"; }
log_skip()    { echo -e "  ${YELLOW}[SKIP]${RESET} $1"; }
log_info()    { echo -e "  ${CYAN}[INFO]${RESET} $1"; }
log_error()   { echo -e "  ${RED}[ERROR]${RESET} $1" >&2; }

run_cmd() {
  echo -e "  ${BOLD}[RUN]${RESET}  $*"
  $DRY_RUN || "$@"
}

# シンボリックリンク作成（冪等）
symlink() {
  local src="$1" dst="$2"
  [ -e "$src" ] || { log_info "スキップ（存在しない）: $src"; return; }
  [ -L "$dst" ] && { log_skip "$dst"; return; }
  if [ -e "$dst" ]; then
    $DRY_RUN || mv "$dst" "${dst}.bak.$(date +%Y%m%d%H%M%S)"
    log_info "既存ファイルをバックアップ: $dst"
  fi
  run_cmd ln -sfn "$src" "$dst"
  $DRY_RUN || log_ok "$dst -> $src"
}

# -----------------------------------------------------------------------------
# dry run バナー
# -----------------------------------------------------------------------------
if $DRY_RUN; then
  echo -e "\n${BOLD}${YELLOW}[DRY RUN] 実際のインストールは行いません${RESET}"
fi

# -----------------------------------------------------------------------------
# 0. Prerequisites (apt)
# -----------------------------------------------------------------------------
log_section "0. 前提パッケージ (apt)"

if ! $DRY_RUN; then
  sudo apt-get update
  sudo apt-get install -y build-essential curl git python3-pip
fi
log_ok "前提パッケージの確認完了"

# -----------------------------------------------------------------------------
# 1. Homebrew
# -----------------------------------------------------------------------------
log_section "1. Homebrew"

if command -v brew &>/dev/null; then
  log_skip "Homebrew"
else
  run_cmd /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Linux Homebrew の PATH を通す
if [ -d /home/linuxbrew/.linuxbrew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -d "$HOME/.linuxbrew" ]; then
  eval "$($HOME/.linuxbrew/bin/brew shellenv)"
fi

if ! $DRY_RUN; then
  log_info "Homebrew $(brew --version | head -1)"
fi

# -----------------------------------------------------------------------------
# 2. Homebrew パッケージ（Brewfile）
# -----------------------------------------------------------------------------
log_section "2. Homebrew パッケージ（Brewfile）"

BREWFILE="${DOTFILES_DIR}/shell/Brewfile"
if [ -f "$BREWFILE" ]; then
  run_cmd brew bundle --file="$BREWFILE"
  $DRY_RUN || log_ok "Brewfile 適用完了"
else
  log_error "Brewfile が見つかりません: $BREWFILE"
fi

# -----------------------------------------------------------------------------
# 3. ディレクトリ作成
# -----------------------------------------------------------------------------
log_section "3. 作業ディレクトリ"

run_cmd mkdir -p ~/.config
run_cmd mkdir -p ~/work/{individual,prototype}
$DRY_RUN || log_ok "ディレクトリ作成完了"

# -----------------------------------------------------------------------------
# 4. シンボリックリンク（zsh / bash）
# -----------------------------------------------------------------------------
log_section "4. シェル設定"

for f in .zshrc .zshenv .zprofile; do
  symlink "${DOTFILES_DIR}/zsh/${f}" "${HOME}/${f}"
done

# -----------------------------------------------------------------------------
# 5. シンボリックリンク（各種ツール）
# -----------------------------------------------------------------------------
log_section "5. ツール設定"

symlink "${DOTFILES_DIR}/mise"              "${HOME}/.config/mise"
symlink "${DOTFILES_DIR}/shell/sheldon"     "${HOME}/.config/sheldon"
symlink "${DOTFILES_DIR}/shell/starship.toml" "${HOME}/.config/starship.toml"
symlink "${DOTFILES_DIR}/nvim"              "${HOME}/.config/nvim"

# WezTerm の設定 (WSLの場合、Windows側の設定ファイルと共有することが多いですが、ここでは一旦Linux側にリンクします)
WEZTERM_SRC="${DOTFILES_DIR}/shell/.wezterm.lua"
if [ -f "$WEZTERM_SRC" ]; then
  symlink "$WEZTERM_SRC" "${HOME}/.wezterm.lua"
fi

# -----------------------------------------------------------------------------
# 6. mise ランタイム
# -----------------------------------------------------------------------------
log_section "6. mise ランタイム"

export PATH="${HOME}/.local/bin:$PATH"

if ! command -v mise &>/dev/null; then
  # brew で入っていない場合は直接インストールを試みる
  log_info "mise を直接インストールします"
  run_cmd curl https://mise.jdx.dev/install.sh | sh
fi

if ! $DRY_RUN; then
  if command -v mise &>/dev/null; then
    log_info "mise $(mise --version)"
    run_cmd mise install
    log_ok "mise ランタイムインストール完了"
  else
    log_error "mise が見つかりません"
  fi
fi

# -----------------------------------------------------------------------------
# 7. starship
# -----------------------------------------------------------------------------
log_section "7. starship"

if command -v starship &>/dev/null; then
  log_skip "starship"
else
  run_cmd curl -sS https://starship.rs/install.sh | sh -s -- --yes
  $DRY_RUN || log_ok "starship インストール完了"
fi

# -----------------------------------------------------------------------------
# 8. sheldon プラグイン
# -----------------------------------------------------------------------------
log_section "8. sheldon"

if command -v sheldon &>/dev/null; then
  run_cmd sheldon lock --update
  $DRY_RUN || log_ok "sheldon プラグイン更新完了"
else
  log_error "sheldon が見つかりません"
fi

# -----------------------------------------------------------------------------
# 9. gemini-cli / Claude Code
# -----------------------------------------------------------------------------
log_section "9. CLI ツール"

if command -v mise &>/dev/null; then
  eval "$(mise activate bash)" 2>/dev/null || true
fi

if command -v npm &>/dev/null; then
  if command -v gemini &>/dev/null; then
    log_skip "gemini-cli"
  else
    run_cmd npm install -g @google/gemini-cli
    $DRY_RUN || log_ok "gemini-cli インストール完了"
  fi
else
  log_error "npm が見つかりません（mise で node をインストール後に再実行）"
fi

if command -v claude &>/dev/null; then
  log_skip "Claude Code"
else
  # Claude Code のインストールは環境によって異なる可能性があります
  run_cmd curl -fsSL https://claude.ai/install.sh | bash
  $DRY_RUN || log_ok "Claude Code インストール完了"
fi

# -----------------------------------------------------------------------------
# 完了
# -----------------------------------------------------------------------------
log_section "完了"

if $DRY_RUN; then
  echo -e "  ${YELLOW}dry run 完了。実行するには --dry-run なしで再実行してください。${RESET}"
else
  echo -e "  ${GREEN}${BOLD}セットアップ完了！${RESET}\n"
  echo -e "  次のステップ:"
  echo -e "  ${CYAN}1.${RESET} source ~/.zshrc  (または新しいターミナルを開く)"
  echo -e "  ${CYAN}2.${RESET} mise use --global node@latest  (デフォルトランタイム設定)"
  echo -e "  ${CYAN}3.${RESET} WSL の場合は、Windows 側にフォント（JetBrainsMono Nerd Font 等）のインストールを確認"
fi
echo ""
