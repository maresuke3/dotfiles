#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# dotfiles bootstrap script
# =============================================================================
# This script is the single entry point for a new machine.
# It installs the absolute minimum requirements (Homebrew and mise),
# and then delegates the rest of the setup to `mise tasks`.
# =============================================================================

DRY_RUN=false
MISE_ARGS=""

for arg in "$@"; do
  case "$arg" in
    --dry-run|-n)
      DRY_RUN=true
      MISE_ARGS="--dry-run"
      ;;
    *) echo "Unknown option: $arg"; exit 1 ;;
  esac
done

echo -e "\033[1;34m=== Starting bootstrap ===\033[0m"
if $DRY_RUN; then
  echo -e "\n\033[1;33m[DRY RUN] No actual installations will be performed.\033[0m"
fi

run_cmd() {
  echo -e "  \033[1;33m[RUN]\033[0m  $*"
  if ! $DRY_RUN; then
    "$@"
  fi
}

# 1. OS-specific prerequisites
if [[ "$(uname)" == "Linux" ]]; then
    echo -e "\n\033[1;36m[INFO]\033[0m Checking Linux prerequisites (apt)..."
    if command -v apt-get &>/dev/null; then
        run_cmd sudo apt-get update
        run_cmd sudo apt-get install -y build-essential curl git python3-pip
    fi
fi

# 2. Install Homebrew
echo -e "\n\033[1;36m[INFO]\033[0m Checking Homebrew..."
if ! command -v brew &>/dev/null; then
    if ! $DRY_RUN; then /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; else echo -e "  \033[1;33m[RUN]\033[0m  /bin/bash -c \"$(curl -fsSL ...)\""; fi
else
    echo -e "  \033[1;32m[OK]\033[0m   Homebrew is already installed."
fi

# Configure Homebrew PATH in the current session
if [[ "$(uname)" == "Darwin" ]]; then
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    if [ -d /home/linuxbrew/.linuxbrew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "$HOME/.linuxbrew" ]; then
        eval "$($HOME/.linuxbrew/bin/brew shellenv)"
    fi
fi

# 3. Install mise (The task runner & tool manager)
echo -e "\n\033[1;36m[INFO]\033[0m Checking mise..."
export PATH="$HOME/.local/bin:$PATH"
if ! command -v mise &>/dev/null; then
    if ! $DRY_RUN; then curl https://mise.run | sh; else echo -e "  \033[1;33m[RUN]\033[0m  curl https://mise.run | sh"; fi
else
    echo -e "  \033[1;32m[OK]\033[0m   mise is already installed."
fi

# 4. Delegate to mise tasks
echo -e "\n\033[1;34m=== Delegating setup to mise tasks ===\033[0m"
cd "$(dirname "$0")"

# Execute the master setup task
# Using eval to properly expand MISE_ARGS
if $DRY_RUN; then echo -e "  \033[1;33m[RUN]\033[0m  mise run --dry-run setup"; mise run --dry-run setup || true; else echo -e "  \033[1;33m[RUN]\033[0m  mise run setup"; mise run setup; fi
