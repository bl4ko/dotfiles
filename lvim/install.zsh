# ---------------------------- LVIM --------------------------------------------------------------
# Preequisities: https://www.lunarvim.org/docs/installation
# 1. Neovim v0.8.0+
if ! command -v nvim &> /dev/null
then
	echo "Installing neovim..."
	if [ $(uname) = "Darwin" ]; then
		brew install neovim
	elif [ $(uname) = "Linux" ]; then
		# TODO: use package manager (snap not working)
		# Get the checksum
		wget -P /tmp https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb.sha256sum
		# Get the debian package
		wget -P /tmp https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
		# Test the checksum
		cd /tmp
		if sha256sum -c /tmp/nvim-linux64.deb.sha256sum; then
		    echo "Checksum is correct"
	         else
		    echo "Checksum is incorrect"
		    exit 1
		fi    
		cd - && sudo apt install /tmp/nvim-linux64.deb
	fi
fi

# 2. Lunarvim dependencies: Have git, make, pip, npm, node and cargo installed on your system
# Also EACESS problem node
# Check if rustup is installed (uninstall with: rustup self uninstall)
if ! command -v rustup &> /dev/null; then
  echo "Installing Rust and Cargo"
  curl https://sh.rustup.rs -sSf | sh -s -- -y # https://stackoverflow.com/a/57251636
  source "$HOME/.cargo/env"
fi

if ! command -v make &> /dev/null; then
  echo "Installing make command..."
  if [ $(uname) = "Linux" ]; then 
    sudo apt install make
  elif [ $(uname) = "Darwin" ]; then 
    brew install make
  fi
fi

# Setup npm and nodejs (linux with nvm)
# - Why nvm?: (EACESS) https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
# - Just OP (apt old and problems)
if [ $(uname) = "Linux" ]; then
  # Check if $HOME/.nvm/nvm.sh exists
  if [ ! -f $HOME/.nvm/nvm.sh ]; then
    echo "Installing nvm..."
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
  fi
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
elif [ $(uname) = "Darwin" ]; then
  if ! command -v node &> /dev/null; then
    echo "Installing node..."
    brew install node
  fi
fi

if ! command -v python3 &> /dev/null; then
  echo "Installing python3 and pip3"
  if [ $(uname) = "Linux" ]; then
    sudo apt install python3
    sudo apt-get install python3-pip
  elif [ $(uname) = "Darwin" ]; then
    echo "Todo install python on Darwin"
    exit 1
  fi
fi

if ! command -v lvim &> /dev/null
then
    echo "LunarVim could not be found..."
    echo "Installing Lunarvim..."

    echo "Installing lunarvim..."
    if [ $(uname) = "Darwin" ] || [ $(uname) = "Linux" ]
    then
    	bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
      # Create symlink for dotfiles config to work
      mv $HOME/.config/lvim/config.lua $HOME/.config/lvim/config.lua.default
      ln -s $HOME/dotfiles/lvim/config.lua $HOME/.config/lvim/config.lua
    fi
fi
