# https://stackoverflow.com/a/22779469, https://stackoverflow.com/a/29471921
# https://stackoverflow.com/questions/11916064/zsh-tab-completion-duplicating-command-name: duplicate
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

. "$HOME/.cargo/env"

# Tmux problem (with locales texts gets multiplied when autocompletition feature is used)
# link: https://unix.stackexchange.com/a/541352
if [ -n "$ZSH_VERSION" -a -n "$PS1" ]; then
  # include .zshrc if it exsits
  if [ -f "$HOME/.zshrc" ]; then
    . "$HOME/.zshrc"
  fi
fi
