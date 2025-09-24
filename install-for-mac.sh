#!/bin/sh
set -e # errorのときにスクリプトが動き続けてしまうので停止させる
echo "Start setting file import"

# ディレクトリがないときディレクトリを作成する
mkdir -p ~/.config
mkdir -p ~/work/{individual,prototype}

# install brew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # M1/M2 Macの場合のPATH設定
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed"
fi

if [ -f ~/dotfiles/shell/Brewfile ]; then
	ln -sf ~/dotfiles/shell/Brewfile ~/Brewfile
	brew bundle --file=~/Brewfile
else
	echo "Warning: Brewfile not found at ~/dotfiles/shell/Brewfile"
fi

# config of shell
echo "Setting up shell configurations..."
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/.zprofile ~/.zprofile
ln -sf ~/dotfiles/bash/.bashrc ~/.bashrc
ln -sf ~/dotfiles/shell/sheldon ~/.config/sheldon
ln -sf ~/dotfiles/shell/starship.toml ~/.config/starship.toml

# prompt
echo "Setting prompt"
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/.wezterm.lua ~/.wezterm.lua

# vim
echo "Setting up NeoVim..."
ln -sf ~/dotfiles/nvim/ ~/.config/nvim

# git
echo "Setting up git configurations..."
GIT_CONFG_DIR="$HOME/dotfiles/git"
if [ -d "$GIT_CONFIG_DIR" ]; then
	find "$GIT_CONFIG_DIR" -type -f -name ".*" | while read -r file; do
		filename=$(basename "$file")
		target="$HOME/$filename"

		echo "Creating git symlink: $filename"

		if [ -e "$target" ] && [ ! -L "$target" ]; then
			mv "$target" "${target}.backup"
            echo "    Backed up existing: ${filename}.backup"
        elif [ -L "$target" ]; then
            rm "$target"
        fi

        # シンボリックリンク作成
        ln -sf "$file" "$target"
    done
else
    echo "Warning: Git config directory not found: $GIT_CONFIG_DIR"
fi

#ln -sf ~/dotfiles/git/.gitignore_global ~/.gitignore_global
#ln -sf ~/dotfiles/git

# pokemon-colorpicker
~/dotfiles/pokemon-colorpicker/install.sh

echo "finished setting"
