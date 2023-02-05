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
DOTFILES="$HOME/dotfiles"

echo -e "${INFO}Starting symlink process..."
echo "----------------------------------"

function create_symlink {
    echo -e "$INFO Creating symlink for $COL_CYAN$1$COL_NC"
    # Check if a file exists and it is not a symlink
    if [ -f "$2" ] && [ -L "$2" ]; then
        echo -e "BACKUP${CROSS} Symlink already exists, skipping..."
        return 1
    else
        mv "$2" "$2.bak"
        echo -e "BACKUP${TICK} Backup created..."
    fi
    # Create symlink and check if it was successful
    if output=$( ln -s "$1" "$2" 2>&1); then
        echo -e "SYMLINK${TICK} Created symlink..."
    else
        echo -e "SYMLINK${CROSS} $output..."
    fi
}

# Symlink all files in config directory
create_symlink "$DOTFILES/bash/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"
create_symlink "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES/.profile" "$HOME/.profile"
echo -e "\n"

# --- LUNARVIM -------------------------------------------
# Ask the user if we should install lunarvim
read -r -p "Do you want to install lunarvim? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo -e "${INFO}Installing lunarvim..."
        source "$DOTFILES/lvim/install.zsh"
        create_symlink "$DOTFILES/lvim/config.lua" "$HOME/.config/lvim/config.lua"
        ;;
    *)
        echo -e "${INFO}Skipping lunarvim..."
        ;;
esac

# --- VSCODE ---------------------------------------------
# Visual studio code: https://stackoverflow.com/a/53841945
# Ask the user if we should install vscode extensions
read -r -p "Do you want to install vscode extensions? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo -e "${INFO}Installing vscode extensions..."
        if [ "$(uname)" = "Darwin" ]; then
            create_symlink "$DOTFILES/Code/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
            create_symlink "$DOTFILES/Code/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
        elif [ "$(uname)" = "Linux" ]; then
            create_symlink "$DOTFILES/Code/settings.json" "$HOME/.config/Code/User/settings.json"
            create_symlink "$DOTFILES/Code/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
        fi
        ;;
    *)
        echo -e "${INFO}Skipping vscode extensions..."
        ;;
esac

# Change default shell to zsh
read -r -p "Do you want to change your default shell to zsh? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo -e "${INFO}Changing default shell to zsh..."
        chsh -s "$(which zsh)"
        ;;
    *)
        echo -e "${INFO}Skipping default shell change..."
        ;;
esac
