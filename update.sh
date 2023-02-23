#!/bin/bash

COL_LIGHT_GREEN='\033[1;32m'
COL_LIGHT_RED='\033[1;31m'
COL_NC='\033[0m' # No Color
COL_BLUE='\033[0;34m'
TICK="[${COL_LIGHT_GREEN}✓${COL_NC}]"
CROSS="[${COL_LIGHT_RED}✗${COL_NC}]"
# INFO="[${COL_BLUE}i${COL_NC}]"

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
pull_remote "$HOME/dotfiles/zsh/plugins/zsh-autosuggestions"
pull_remote "$HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting" 
pull_remote "$HOME/dotfiles/zsh/plugins/git-prompt"
pull_remote "$HOME/dotfiles/zsh/plugins/kube-ps1"

function upgrade_nvm {
  output=$(cd "$NVM_DIR" && git fetch --tags origin && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` 2>&1)
  echo -e "${TICK} Check ${COL_BLUE}nvm${COL_NC}: ${output}"
  \. "$NVM_DIR/nvm.sh"
}
if test -f "$NVM_DIR/nvm.sh"; then
  upgrade_nvm 
fi
