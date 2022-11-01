# ---------------------------- ZSH-OPTIONS -------------------------------------------------------
setopt autocd                # change directory just by typing its name
setopt correct               # auto correct mistakes
setopt interactivecomments   # allow comments in interactive mode
setopt magicequalsubst       # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch             # hide error message if there is no match for the pattern
setopt notify                # report the status of background jobs immediately
setopt numericglobsort       # sort filenames numerically when it makes sense
setopt promptsubst           # enable command substitution in prompt (check precmd() funciton required!!!)

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# ---------------------------- ADD COLORS TO COMMAND OUTPUTS -----------------------------------
# enable color support of ls, less and man, and also add handy aliases

# https://superuser.com/a/707567
export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

alias ls='ls --color=auto'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
if [ $(uname) = 'Linux' ]; then
  alias diff='diff --color=auto'
fi
if [ $(uname) = 'Linux' ]; then
  alias ip='ip --color=auto'
fi

export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# ---------------------------- GIT -------------------------------------------------------
# https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
# TODO: manually git prompt setup
autoload -Uz vcs_info #  autoload marks the name as being a function rather than external program
# Enable checking for (un)staged changes, enabling use of %u and %c
# zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
# zstyle ':vcs_info:*' unstagedstr '*'
# zstyle ':vcs_info:*' stagedstr '+'
# Set the format of the Git information for vcs_info
# zstyle ':vcs_info:git:*' formats '%b|%u%c' # format vcs_info function
#zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'
# zstyle ':vcs_info:git:*' formats '%b' # format vcs_info function

# check if zsh git prompt is installed
if [ ! -f $HOME/dotfiles/zsh/plugins/zsh-git-prompt/zshrc.sh ]; then
    echo "Zsh-git-prompt is not installed..."
    echo "Installing zsh-git-prompt..."
    git clone -v https://github.com/olivierverdier/zsh-git-prompt.git $HOME/dotfiles/zsh/plugins/zsh-git-prompt
fi
if [ $(uname) == "Darwin" ]; then alias python=python3; fi # Problem on macos, not having python only python3
source ~/dotfiles/zsh/plugins/zsh-git-prompt/zshrc.sh
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# -------------------------- PROMPT -----------------------------------------------
# Check if our terminal emulator supports colors
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
prompt_symbol=㉿
[ "EUID" = 0 ] && prompt_symbol=💀
[ $(uname) = "Darwin" ] && prompt_symbol=@

PROMPT_USER_MACHINE='%F{green}┌──(%B%F{blue}%n${prompt_symbol}%m%b%F{green})'
PROMPT_PATH='-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{green}]' # %B  -> Start (stop) boldface mode (https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html)
# PROMPT_GIT='-[%B%F{magenta}${vcs_info_msg_0_}%b%F{green}]' # TODO manually
PROMPT_GIT='-[%B%F{magenta}$(git_super_status)%b%F{green}]' # TODO manually
PROMPT_LINE2=$'\n%F{green}└─%B%F{blue}$%b%F{reset} '

PROMPT="$PROMPT_USER_MACHINE"'$PROMPT_PATH'"$PROMPT_GIT"'$PROMPT_LINE2'

# -------------------------- precmd() ---------------------------------------------
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    TERM_TITLE='\e]0;%n@%m: %~\a'
    ;;
*)
    ;;
esac


# precmd runs before each prompt
precmd() {

    # Print a new line before the prompt, but only if it is not the first line
    if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
        _NEW_LINE_BEFORE_PROMPT=1
    else
        print ""
    fi

     vcs_info

     # Check if we are located in git repository, and if so, add git info to prompt
     if [[ -z ${vcs_info_msg_0_} ]]; then
         PROMPT="$PROMPT_USER_MACHINE"'$PROMPT_PATH''$PROMPT_LINE2'
     else
         PROMPT="$PROMPT_USER_MACHINE"'$PROMPT_PATH'"$PROMPT_GIT"'$PROMPT_LINE2'
     fi
}


# ---------------------------- ZSH-SYNTAX-HIGHLIGHTING -------------------------------------------------------
# Enable syntax highlighting
if [ "$color_prompt" = yes ]; then
    # Check if installed
    if [ ! -f $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        echo "zsh-syntax-highlighting not found..."
        echo "Installing zsh-syntax-highlighting..."
        mkdir -pv $HOME/.zsh 
        git clone -v https://github.com/zsh-users/zsh-syntax-highlighting.git ~/dotfiles/zsh/plugins/zsh-syntax-highlighting
    fi

    # Source the plugin
    . $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[path]=underline
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[command-substitution]=none
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[process-substitution]=none
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[assign]=none
    ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
    ZSH_HIGHLIGHT_STYLES[named-fd]=none
    ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
    ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
fi

# ---------------------------- AUTO_SUGGESTIONS ------------------------------------------------
# Enable auto-suggestions based on the history
# https://github.com/zsh-users/zsh-autosuggestions
if [ ! -f ~/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    echo "Zsh-autosuggestions is missing."
    echo "Downloading (https://github.com/zsh-users/zsh-autosuggestions)..."
    git clone -v https://github.com/zsh-users/zsh-autosuggestions ~/dotfiles/zsh/plugins/zsh-autosuggestions
fi
# Source the plugin
. ~/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999' # Change suggestion color to grey


# ---------------------------- COMMAND-NOT-FOUND ------------------------------------------------
# Enable command-not-found plugin
if [ $(uname) = "Linux" ]; then
    # https://packages.ubuntu.com/search?keywords=command-not-found
    if [ -f /etc/zsh_command_not_found ]; then
        . /etc/zsh_command_not_found
    else
        echo "command-not-found is missing..."
        echo "installing command-not-found..."
        sudo apt update && sudo apt install command-not-found
        . /etc/zsh_command_not_found
    fi
elif [ $(uname) = "Darwin" ]; then
    # https://github.com/Homebrew/homebrew-command-not-found
    if [ -z $(brew tap | grep command-not-found) ]; then
      brew tap -v homebrew/command-not-found
      HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
      if [ -f "$HB_CNF_HANDLER" ]; then
      source "$HB_CNF_HANDLER";
      fi
    fi
fi

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

# 2. Have git, make, pip, npm, node and cargo installed on your system
# Also EACESS problem node
if ! command -v lvim &> /dev/null
then
    echo "LunarVim could not be found..."
    echo "Installing lunarvim and dependencies..."

    # Check if rustup is installed (uninstall with: rustup self uninstall)
    if ! command -v rustup &> /dev/null
    then
      echo "Installing Rust and Cargo"
      curl https://sh.rustup.rs -sSf | sh -s -- -y # https://stackoverflow.com/a/57251636
      source "$HOME/.cargo/env"
    fi

    if ! command -v make &> /dev/null
    then
      echo "Installing make command..."
      if [ $(uname) = "Linux" ]; then sudo apt install make;
      elif [ $(uname) = "Darwin" ]; then brew install make; fi
    fi

    if ! command -v node &> /dev/null
    then
      echo "Installing nodejs and npm..."
      if [ $(uname) = "Linux" ]; then 
        sudo snap install node
        # Change npm path (EACESS) https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
        # https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
        sudo chown -R "$(whoami)" '/usr/local/lib/node_modules'
        sudo chown -R "$(whoami)" '/usr/local/bin'
      elif [ $(uname) = "Darwin" ]; then
        brew install node
      fi
    fi

    if ! command -v python3 &> /dev/null
    then
      echo "Installing python3 and pip3"
      if [ $(uname) = "Linux" ]; then
        sudo apt install python3 python3-pip
      fi
    fi

    echo "Installing lunarvim..."
    if [ $(uname) = "Darwin" ] || [ $(uname) = "Linux" ]
    then
    	bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
    # Create symlink for dotfiles config to work
      mv $HOME/.config/lvim/config.lua $HOME/.config/lvim/config.lua.old
      ln -s $HOME/dotfiles/lvim/config.lua $HOME/.config/lvim/config.lua
    fi
fi

alias vim=lvim
export EDITOR=vim

# NVCHAD
#if ! command -v nvim &> /dev/null
#then
#    echo "Nvim could not be found..."
#    echo "Installing neovim..."
#    if [ $(uname) = "Darwin" ] || [ $(uname) = "Linux" ]
#    then
#        rm -rf -v ~/.local/share/nvim
#        rm -rf -v ~/.config/nvim
#        rm -rf -v ~/.cache/nvim
#        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
#    fi
#fi


# ---------------------------- MAC SPECIFIC --------------------------------------------------------------
# Replace MACOS commands with GNU commands
# Use GNU utilities: https://apple.stackexchange.com/questions/69223/how-to-replace-mac-os-x-utilities-with-gnu-core-utilities
# (GNU version of basic commands)
if [ $(uname) = "Darwin" ]
then
    # Add brew autocompletitions
     if type brew &>/dev/null
     then
        FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
        autoload -Uz compinit
        compinit
    else
      echo "Brew installer is missing :("
    fi

    if [ ! -d /opt/homebrew/opt/grep/libexec/gnubin ]; then
        brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep
    fi

    PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
    PATH="/opt/homebrew/gnu-getopt/libexec/gnubin:$PATH"
    PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
    PATH="/opt/homebrew/opt/gnu-indent/libexec/gnubin:$PATH"
    PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
    PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
    PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH" # https://stackoverflow.com/questions/69574792/gnu-find-cant-find-root-directory-find-failed-to-read-file-names-from-file
    export PATH

    # Also acces their man pages with normal names
    MANPATH="/opt/homebrew/Cellar/libtool/2.4.7/libexec/gnuman:$MANPATH"
    MANPATH="/opt/homebrew/Cellar/coreutils/9.1/libexec/gnuman:$MANPATH"
    MANPATH="/opt/homebrew/Cellar/gnu-indent/2.2.12_1/libexec/gnuman:$MANPATH"
    MANPATH="/opt/homebrew/Cellar/gnu-tar/1.34_1/libexec/gnuman:$MANPATH"
    MANPATH="/opt/homebrew/Cellar/grep/3.7/libexec/gnuman:$MANPATH"
    MANPATH="/opt/homebrew/Cellar/gnu-sed/4.8/libexec/gnuman:$MANPATH"
    MANPATH="/opt/homebrew/Cellar/gawk/5.1.1/libexec/gnuman:$MANPATH"
    MANPATH="/opt/homebrew/Cellar/findutils/4.9.0/libexec/gnuman:$MANPATH" # https://stackoverflow.com/questions/69574792/gnu-find-cant-find-root-directory-find-failed-to-read-file-names-from-file
    export MANPATH

    # Lunarvim problem with max openfiles: https://github.com/wbthomason/packer.nvim/issues/149
    # Doesn't persist over reboot: https://superuser.com/questions/1634286/how-do-i-increase-the-max-open-files-in-macos-big-sur/1646927#1646927
	
    # Error: unable to get local issuer certificate
    # 1. https://stackoverflow.com/a/42107877
    # 2. https://stackoverflow.com/a/57795811 
    CERT_PATH=$(python -m certifi)
    export SSL_CERT_FILE=${CERT_PATH}
    export REQUESTS_CA_BUNDLE=${CERT_PATH}
fi
