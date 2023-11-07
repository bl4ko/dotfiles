#!/bin/bash
#
# Source common colors, and symbols
source ./utils.sh

function create_symlink {
    echo -e "$INFO Creating symlink for ${COL_CYAN}$1${COL_NC}..."

    # Check if a file exists and it is not a symlink
    if [ -L "$2" ]; then
        echo -e "${TICK} Symlink already exists, skipping"
        return 1
    elif [ -f "$2" ]; then
        echo -e "${TICK} Created backup of ${COL_LIGHT_CYAN}$2${COL_NC}: $(mv -v "$2" "$2.bak")"
    fi

    # Create symlink and check if it was successful
    if output=$( ln -sv "$1" "$2" 2>&1); then
        echo -e "${TICK} Created symlink: ${output}"
    else
        echo -e "${CROSS} Failed creating symlink: ${output}"
    fi
}

# Symlink all files in config directory
echo -e "${INFO}Starting symlink process..."
echo "----------------------------------"
create_symlink "$DOTFILES/bash/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"
create_symlink "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES/bash/.profile" "$HOME/.profile"
create_symlink "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"
echo -e "\n"


# Locales are required by many programes to work properly
echo -e "${INFO} Checking ${COL_CYAN}locale${COL_NC}..."
# shellcheck disable=SC1091
source ./zsh/init-scripts/locales.sh
setup_locales


echo -e "${INFO} Checking if ${COL_CYAN}curl${COL_NC} is installed..."
# shellcheck disable=SC1091
source ./zsh/init-scripts/curl.sh 
check_curl


echo -e "${INFO} Checking if ${COL_CYAN}zsh${COL_NC} is installed..."
# shellcheck disable=SC1091
source ./zsh/init-scripts/zsh.sh
ensure_zsh_is_installed


# Ensure chsh is installed
echo -e "${INFO} Checking if ${COL_CYAN}chsh${COL_NC} is installed..."
if ! command -v chsh &> /dev/null; then
    echo -e "${INFO} chsh command not found, will try to install it..."
    if [ "$(uname -s)" = "Linux" ]; then
        if command -v apt &> /dev/null; then
          apt install -y passwd
        elif command -v dnf &> /dev/null; then
          dnf install -y util-linux-user
        else
          echo -e "${CROSS} Unsupported package manager"
          exit 1
        fi
    elif [ "$(uname -s)" = "Darwin" ]; then
        brew install -y util-linux
    else 
        echo -e "${CROSS} Unsupported OS: $(uname s)"
        exit 1
    fi
else 
    echo -e "${TICK} chsh already installed, skipping..."
fi

# Change default shell to zsh
echo -e "${INFO} Setting zsh as ${COL_CYAN}default shell${COL_NC}..."
source ./zsh/init-scripts/default_shell.sh
set_default_shell

# Ensure tmux is installed
echo -e "${INFO} Checking if ${COL_CYAN}tmux${COL_NC} is installed..."
if ! command -v tmux &> /dev/null; then
    echo -e "${INFO} Installing tmux..."
    if [ "$(uname -s)" = "Linux" ]; then
        if command -v apt &> /dev/null; then
          apt install -y tmux
        elif command -v dnf &> /dev/null; then
          dnf install -y tmux
        else
          echo -e "${CROSS} Unsupported package manager"
          exit 1
        fi
    elif [ "$(uname -s)" = "Darwin" ]; then
        brew install -y tmux
    else 
        echo -e "${CROSS} Unsupported OS: $(uname s)"
       exit 1
    fi
    echo -e "${TICK} tmux installed!"
else
    echo -e "${TICK} tmux already installed, skipping..."
fi

# Check if $HOME/.local/bin exists, if not create it
echo -e "${INFO} Checking if ${COL_CYAN}$HOME/.local/bin${COL_NC} exists..."
if [ ! -d "$HOME/.local/bin" ]; then
    echo -e "${INFO} ${HOME}/.local/bin doesn't exist. Creating it..."
    if output=$(mkdir -vp "$HOME/.local/bin"); then
      echo "${output}"
      echo -e "${TICK} Successfuly created"
    else
      echo -e "${CROSS} Failed creating: ${output}"
      exit 1
    fi
fi
export PATH="$HOME/.local/bin:$PATH"

# Add a prompt if user wants to install additional apps
read -r -p "Do you want to install additional apps? [y/N] " response
case "$response" in 
  ([yY][eE][sS]|[yY])
    ;;
  *) 
    exit 0
    ;;
esac

# NVM installation
echo -en "Do you want to install ${COL_CYAN}NVM${COL_NC}? [y/N] "
read -r response
case "$response" in 
  ([yY][eE][sS]|[yY])
      source ./zsh/init-scripts/nvm.sh
      install_nvm
      ;;
  *) 
      echo -e "${INFO} Skipping NVM..."
      ;;
esac

# Neovim installation
echo -en "Do you want to install ${COL_CYAN}nvchad${COL_NC}? [y/N] "
read -r response
case "$response" in
  ([yY][eE][sS]|[yY])
      source ./zsh/init-scripts/neovim.sh
      source ./zsh/init-scripts/nvchad.sh
      install_neovim
      echo -e "${INFO} Installing ${COL_CYAN}nvchad${COL_NC}..."
      install_nvchad
    ;;
  *)
    echo -e "${INFO} Skipping neovim..."
    ;;
esac
