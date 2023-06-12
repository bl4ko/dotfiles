#!/bin/bash

source ./utils.sh

function pull_remote {
    plugin_name="$COL_BLUE$(basename "$1")$COL_NC"
    output=$(git -C "$1" pull)
    if test $?; then
      echo -e "${TICK} Check ${plugin_name}: ${output}"
    else
      echo -e "${CROSS} Check ${plugin_name}: ${output}"
    fi
}

# Update zsh plugins
pull_remote "$HOME/dotfiles/zsh/plugins/loaded/zsh-autosuggestions"
pull_remote "$HOME/dotfiles/zsh/plugins/loaded/zsh-syntax-highlighting" 
pull_remote "$HOME/dotfiles/zsh/plugins/loaded/git-prompt"
pull_remote "$HOME/dotfiles/zsh/plugins/loaded/kube-ps1"

function upgrade_nvm {
  NVM_DIR="$HOME/.nvm"
  output=$(cd "$NVM_DIR" && git fetch --tags origin && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` 2>&1)
  echo -e "${TICK} Check ${COL_BLUE}nvm${COL_NC}: ${output}"
  \. "$NVM_DIR/nvm.sh"
}
if test -f "$HOME/.nvm/nvm.sh"; then
  upgrade_nvm 
fi
