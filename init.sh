#!/bin/bash

# Source common colors, and symbols
source ./utils.sh

function create_symlink {
    echo -e "$INFO Creating symlink for ${COL_CYAN}$1${COL_NC}..."

    # Check if a file exists and it is not a symlink
    if [ -L "$2" ]; then
        echo -e "${INFO} Symlink to the target file already exists"
        # Ensure that the symlink is correct
        if [ "$(readlink -- "$2")" = "$1" ]; then
            echo -e "${TICK} Symlink is correct"
            return 0
        else
            echo -e "${INFO} Symlink is incorrect"
            echo -e "${INFO} Removing incorrect symlink"
            rm -v "$2"
        fi
    elif [ -f "$2" ]; then
        echo -e "${TICK} Created backup of ${COL_LIGHT_CYAN}$2${COL_NC}: $(mv -v "$2" "$2.bak")"
    fi

    # Create symlink and check if it was successful
    if output=$( ln -sv "$1" "$2" 2>&1); then
        echo -e "${TICK} Created symlink: ${output}"
    else
        echo -e "${CROSS} Failed creating symlink: ${output}"
        exit 1
    fi
}

function prompt_user {
  local message=$1
  local default_response="y"

  if [ "${SKIP_PROMPTS}" = "y" ]; then
    response="${default_response}"
  else
    echo -en "${message}"
    read -r response
  fi
}

# Enable user to input -y flag to skip all prompts
while getopts ":y" opt; do
  case $opt in
    y)
      echo -e "${INFO} Skipping all prompts..."
      SKIP_PROMPTS="y"
      ;;
    \?)
      echo -e "${CROSS} Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Check if script is run by root user, this will be important for installing packages
# via package manager
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
    echo -e "${INFO} Script is run by ${COL_CYAN}root${COL_NC} user"
else
    echo -e "${INFO} Script is run by ${COL_CYAN}uid=$(id -u)${COL_NC} user"
    # If we are not root, we will need to use sudo
    if command -v sudo &> /dev/null; then
      SUDO="sudo"
    else 
      echo -e "${CROSS} This script requires root privileges or sudo."
      exit 1
    fi
fi

# Symlink all files in config directory
echo -e "${INFO} Starting symlink process..."
echo "----------------------------------"
create_symlink "$DOTFILES/bash/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES/bash/.profile" "$HOME/.profile"
create_symlink "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"
echo -e "\n"

# Locales are required by many programes to work properly
echo -e "${INFO} Checking if ${COL_CYAN}locale${COL_NC} are installed..."
# shellcheck disable=SC1091
source ./zsh/init-scripts/locales.sh

echo -e "${INFO} Checking if ${COL_CYAN}curl${COL_NC} is installed..."
# shellcheck disable=SC1091
source ./zsh/init-scripts/curl.sh 

echo -e "${INFO} Checking if ${COL_CYAN}tar${COL_NC} is installed..."
# shellcheck disable=SC1091
source ./zsh/init-scripts/tar.sh

echo -e "${INFO} Checking if ${COL_CYAN}zsh${COL_NC} is installed..."
# shellcheck disable=SC1091
source ./zsh/init-scripts/zsh.sh


# Ensure chsh is installed
echo -e "${INFO} Checking if ${COL_CYAN}chsh${COL_NC} is installed..."
if ! command -v chsh &> /dev/null; then
    echo -e "${INFO} chsh command not found, will try to install it..."
    if [ "$(uname -s)" = "Linux" ]; then
        if command -v apt &> /dev/null; then
          if ! ${SUDO} apt install -y passwd; then echo -e "${CROSS} Failed installing passwd"; exit 1; fi
        elif command -v dnf &> /dev/null; then
          if ! ${SUDO} dnf install -y util-linux-user; then echo -e "${CROSS} Failed installing util-linux-user"; exit 1; fi
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

echo -e "${INFO} Ensuring that ${COL_CYAN}which${COL_NC} is installed..."
# shellcheck disable=SC1091
source ./zsh/init-scripts/which.sh

# Change default shell to zsh
echo -e "${INFO} Checking ${COL_CYAN}default shell${COL_NC}..."
# shellcheck disable=SC1091
source ./zsh/init-scripts/default_shell.sh

# Ensure tmux is installed
echo -e "${INFO} Checking if ${COL_CYAN}tmux${COL_NC} is installed..."
if ! command -v tmux &> /dev/null; then
    echo -e "${INFO} Installing tmux..."
    if [ "$(uname -s)" = "Linux" ]; then
        if command -v apt &> /dev/null; then
          if ! ${SUDO} apt install -y tmux; then echo -e "${CROSS} Failed installing tmux"; exit 1; fi
        elif command -v dnf &> /dev/null; then
          if ! ${SUDO} dnf install -y tmux; then echo -e "${CROSS} Failed installing tmux"; exit 1; fi
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
else
  echo -e "${TICK} ${HOME}/.local/bin already exists, skipping..."
fi
export PATH="$HOME/.local/bin:$PATH"

prompt_user "Do you want to install additional apps? [y/N]"
case "$response" in 
  ([yY][eE][sS]|[yY])
    ;;
  *) 
    exit 0
    ;;
esac

prompt_user "Do you want to install ${COL_CYAN}NVM${COL_NC}? [y/N]"
case "$response" in 
  ([yY][eE][sS]|[yY])
      source ./zsh/init-scripts/nvm.sh
      install_nvm
      ;;
  *) 
      echo -e "${INFO} Skipping NVM..."
      ;;
esac

prompt_user "Do you want to install ${COL_CYAN}nvchad${COL_NC}? [y/N] "
case "$response" in
  ([yY][eE][sS]|[yY])
      # Install clipboard support from neovim
      echo -e "${INFO} setting up clipboard for neovim"
      source ./zsh/init-scripts/clipboard.sh
      echo -e "${INFO} Installing ${COL_CYAN}neovim${COL_NC}..."
      source ./zsh/init-scripts/neovim.sh
      echo -e "${INFO} Installing ${COL_CYAN}nvchad${COL_NC}..."
      source ./zsh/init-scripts/nvchad.sh
    ;;
  *)
    echo -e "${INFO} Skipping neovim..."
    ;;
esac

prompt_user "Do you want to install ${COL_CYAN}kubernetes tools${COL_NC}? [y/N]"
case "$response" in
  ([yY][eE][sS]|[yY])
      echo -e "${INFO} Installing ${COL_CYAN}kubectl${COL_NC}..."
      source $DOTFILES/zsh/init-scripts/kubectl.sh
      echo -e "${INFO} Installing ${COL_CYAN}helm${COL_NC}..."
      source $DOTFILES/zsh/init-scripts/helm.sh
      echo -e "${INFO} installing ${COL_CYAN}kubecm${COL_NC}..."
      source $DOTFILES/zsh/init-scripts/kubecm.sh
      echo -e "${INFO} installing ${COL_CYAN}kubectl krew${COL_NC}"
      source $DOTFILES/zsh/init-scripts/krew.sh
    ;;
  *)
    echo -e "${INFO} Skipping kubectl..."
    ;;
esac
