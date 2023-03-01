#!/bin/bash
# Symlink all config files to home directory

# Set these values so the installer can still run in color
COL_NC='\033[0m' # No Color
COL_LIGHT_GREEN='\033[1;32m'
COL_LIGHT_RED='\033[1;31m'
COL_BLUE='\033[0;34m'
COL_CYAN='\033[0;36m'
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
        echo -e "${TICK} Symlink already exists, skipping..."
        return 1
    else
        mv "$2" "$2.bak"
        echo -e "${TICK} Backup created..."
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
create_symlink "$DOTFILES/.zprofile" "$HOME/.zprofile"
echo -e "\n"

# Add a prompt if user wants to install additional apps
read -r -p "Do you want to install additional apps? [y/N] " response
case "$response" in 
  ([yY][eE][sS]|[yY])
    ;;
  *) 
    exit 0
    ;;
esac

# --- NVM -----------------------------------------------
read -r -p "Do you want to install NVM? [y/N] " response
case "$response" in 
  ([yY][eE][sS]|[yY])
    if test -f "$HOME/.nvm/nvm.sh"; then
      echo -e "${TICK} NVM already installed, skipping..."
    else
      echo -e "${INFO} Installing NVM..."
      export NVM_DIR="$HOME/.nvm" && (
      git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
      cd "$NVM_DIR"
      git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
      ) && \. "$NVM_DIR/nvm.sh"    
      echo -e "${TICK} NVM installed!"
    fi
    ;;
  *) 
    ;;
esac

# --- LUNARVIM -------------------------------------------
# Ask the user if we should install lunarvim
read -r -p "Do you want to install lunarvim? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo -e "${INFO} Installing lunarvim..."
        source "$DOTFILES/lvim/install.zsh"
        create_symlink "$DOTFILES/lvim/config.lua" "$HOME/.config/lvim/config.lua"
        ;;
    *)
        echo -e "${INFO} Skipping lunarvim..."
        ;;
esac
