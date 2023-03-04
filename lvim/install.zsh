source $DOTFILES/utils.sh

echo -e "${INFO} Installing lunarvim dependencies"
# ---------------------------- LVIM --------------------------------------------------------------
# Preequisities: https://www.lunarvim.org/docs/installation
# 1. Neovim v0.8.0+
if ! command -v nvim &> /dev/null; then
  echo -e "${CROSS} neovim is not installed"
  echo -e "${INFO} Recommending building from source on linux, and using brew install neovim on mac"
  exit 1
else 
  echo -e "${TICK} neovim is installed"
fi

# 2. Lunarvim dependencies: Have git, make, pip, npm, node and cargo installed on your system
# Also EACESS problem node
# Check if rustup is installed (uninstall with: rustup self uninstall)
echo -e "${INFO} Checking ${COL_BLUE}cargo${COL_NC} dependency..."
if ! command -v rustup &> /dev/null; then
  echo -e "${INFO} Installing ${COL_BLUE}cargo${COL_NC}..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y # https://stackoverflow.com/a/57251636
  if [ $? -eq 0 ]; then
    echo -e "${TICK} ${COL_BLUE}cargo${COL_NC} installed"
    echo -e "${INFO} Reloading shell..."
    source "$HOME/.cargo/env"
  else
    echo -e "${CROSS} Failed to install ${COL_BLUE}cargo${COL_NC}"
    exit 1
  fi
else
  echo -e "${TICK} ${COL_BLUE}cargo${COL_NC} is already installed"
fi

echo -e "${INFO} Checking ${COL_BLUE}make${COL_NC} dependency..."
if ! command -v make &> /dev/null; then
  echo -e "${INFO} make dependency is missing..."
  echo -e "${INFO} Installing make dependency..."
  if [ $(uname) = "Linux" ]; then 
    if sudo apt install make; then
      echo -e "${TICK} make dependency installed"
    else
      echo -e "${CROSS} Failed to install make dependency"
      exit 1
    fi
  elif [ $(uname) = "Darwin" ]; then 
    brew install make
  fi
else
  echo -e "${TICK} ${COL_BLUE}make${COL_NC} is already installed"
fi

# Setup npm and nodejs (linux with nvm)
echo -e "${INFO} Checking ${COL_BLUE}nvm (npm, node)${COL_NC} dependency..."
if [ $(uname) = "Linux" ]; then
  if [ ! -f $HOME/.nvm/nvm.sh ]; then
    echo -e "${INFO} Installing nvm..."
    export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"    
    echo -e "${TICK} NVM installed!"
  else
    echo -e "${TICK} nvm is already installed"
  fi
fi

echo -e "${INFO} Checking ${COL_BLUE}python${COL_NC} dependency..."
if ! command -v python3 &> /dev/null; then
    echo -e "${CROSS} python3 is not installed"
    exit 1
else
  echo -e "${TICK} ${COL_BLUE}python${COL_NC} is already installed"
fi

echo -e "${INFO} Checking ${COL_BLUE}pip${COL_NC} dependency..."
if ! command -v pip3 &> /dev/null; then
    echo -e "${CROSS} pip3 is not installed"
    exit 1
else
  echo -e "${TICK} ${COL_BLUE}pip3${COL_NC} is already installed"
fi


echo -e "${INFO} Now trying to install ${COL_BLUE}neovim${COL_NC}..."
if ! command -v lvim &> /dev/null; then
    if [ $(uname) = "Darwin" ] || [ $(uname) = "Linux" ]; then
    	if bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh); then
        echo -e "${TICK} Lunarvim installed"
      else
        echo -e "${CROSS} Failed to install lunarvim"
        exit 1
      fi
      if mv $HOME/.config/lvim/config.lua $HOME/.config/lvim/config.lua.default; then
        echo -e "${TICK} Default config moved"
      else
        echo -e "${CROSS} Failed to move default config"
        exit 1
      fi
      if ln -s $HOME/dotfiles/lvim/config.lua $HOME/.config/lvim/config.lua; then 
        echo -e "${TICK} Lunarvim config linked"
      else
        echo -e "${CROSS} Failed to link lunarvim config"
        exit 1
      fi
  else
    echo -e "${TICK} LunarVim is already installed"
  fi
fi

