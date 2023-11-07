#!/bin/bash

install_nvm () {
  if test -f "$HOME/.nvm/nvm.sh"; then
    echo -e "${TICK} NVM already installed, skipping..."
  else
    echo -e "${INFO} Installing NVM..."
    export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git switch -c `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && source "$NVM_DIR/nvm.sh"    
    echo -e "${TICK} NVM installed!"
    echo -e "${INFO} Installing latest node..."
    if ! nvm install node; then echo -e "${CROSS} Failed installing node"; exit 1; fi
    echo -e "${TICK} Node installed!"
  fi
}