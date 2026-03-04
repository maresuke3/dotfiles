# shellenv
# ## linux
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ## macOS 
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise settings
eval "$(mise activate zsh --shims)"

# pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# z
. `brew --prefix`/etc/profile.d/z.sh

