# When logged in, if default shell set to zsh, only 
# ".zprofile" will be sourced but not the ".profile"

# Required for tmux and other programs to work properly
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Required by brew: export env variables needed for brew to work
if command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Tmux problem (with locales texts gets multiplied
# when autocompletition feature is used)
# https://unix.stackexchange.com/a/541352
if [ -n "$ZSH_VERSION" ] && [ -n "$PS1" ]; then
  # include .zshrc if it exsits
  if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc"
  fi
fi

# Check if we are using RHEL distro
if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [[ $ID_LIKE == *"rhel"* ]]; then
    source $DOTFILES/zsh/motd/rhel.sh
  fi
fi

