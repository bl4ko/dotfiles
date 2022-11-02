#!/bin/bash

COL_LIGHT_GREEN='\033[1;32m'
COL_LIGHT_RED='\033[1;31m'
COL_NC='\033[0m' # No Color
COL_BLUE='\033[0;34m'
TICK="[${COL_LIGHT_GREEN}✓${COL_NC}]"
CROSS="[${COL_LIGHT_RED}✗${COL_NC}]"

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
# Check if git pull is successful
pull_remote "$HOME/dotfiles/zsh/plugins/zsh-autosuggestions"
pull_remote "$HOME/dotfiles/zsh/plugins/git-prompt"
pull_remote "$HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting" 
