# When logged in, if default shell set to zsh, only 
# ".zprofile" will be sourced but not the ".profile"
# https://unix.stackexchange.com/a/699524
source $HOME/.profile

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

