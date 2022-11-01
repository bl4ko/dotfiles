#!/bin/bash
# Symlink all config files to home directory

# Set these values so the installer can still run in color
COL_NC='\033[0m' # No Color
COL_LIGHT_GREEN='\033[1;32m'
COL_LIGHT_RED='\033[1;31m'
COL_BLUE='\033[0;34m'
COL_CYAN='\033[0;36m'
COL_PURPLE='\033[0;35m'
TICK="[${COL_LIGHT_GREEN}✓${COL_NC}]"
CROSS="[${COL_LIGHT_RED}✗${COL_NC}]"
INFO="[${COL_BLUE}i${COL_NC}]"
# shellcheck disable=SC2034
DONE="${COL_LIGHT_GREEN} done!${COL_NC}"
OVER="\\r\\033[K"
DOTFILES="$HOME/dotfiles"

echo "$INFOStarting symlink process..."
echo "---------------------------"

function create_symlink {
    echo -e "$INFO$COL_CYAN Creating Creating symlink for$NC $COL_PURPLE$1$COL_NC"
    # Check if a file exists and it is not a symlink
    if [ -f "$2" ] && [ -L "$2" ]; then
        echo -e "BACKUP $CROSS symlink already exists, skipping..."
    else
        mv "$2" "$2.bak"
        echo -e "BACKUP $TICK Backup created..."
    fi
    output=$( ln -s "$1" "$2" 2>&1)
    # Check if command run without errors
    if [ $? -eq 0 ]; then
        echo -e "SYMLINK${TICK} Created symlink..."
    else
        echo -e "SYMLINK${CROSS} $output..."
    fi
}

# Symlink all files in config directory
create_symlink $DOTFILES/bash/.bashrc $HOME/.bashrc
create_symlink $DOTFILES/zsh/.zshrc $HOME/.zshrc
create_symlink $DOTFILES/zsh/.zshenv $HOME/.zshenv
create_symlink $DOTFILES/tmux/.tmux.conf $HOME/.tmux.conf
create_symlink $DOTFILES/git/.gitconfig $HOME/.gitconfig
create_symlink $DOTFILES/lvim/config.lua $HOME/.config/lvim/config.lua

# Visual studio code: https://stackoverflow.com/a/53841945
if [ $(uname) = "Darwin" ]; then
    create_symlink $DOTFILES/Code/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
    create_symlink $DOTFILES/Code/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings
elif [ $(uname) = "Linux" ]; then
    create_symlink $DOTFILES/Code/settings.json $HOME/.config/Code/User/settings.json
    create_symlink $DOTFILES/Code/keybindings.json $HOME/.config/Code/User/keybindings.json
fi
