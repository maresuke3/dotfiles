#!/bin/sh
echo "Start setting file import"

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
ln -s ~/dotfiles/shell/Brewfile ~/Brewfile
brew bundle --file=./Brewfile

# config of shell
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/dotfiles/zsh/.zprofile ~/.zprofile
ln -s ~/dotfiles/bash/.bashrc ~/.bashrc
ln -s ~/dotfiles/shell/sheldon ~/.config/sheldon
ln -s ~/dotfiles/shell/starship.toml ~/.config/starship.toml

# vim
ln -s ~/dotfiles/nvim/ ~/.config/nvim

# git
ln -s ~/dotfiles/git/.gitignore_global ~/.gitconfig_global

echo "finished setting"
