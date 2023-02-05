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
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
if [ $(uname) = 'Linux' ]; then
  alias diff='diff --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias ip='ip --color=auto'
fi

# Add colors to the manpages: https://unix.stackexchange.com/q/108699
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# enable completion features: git, etc ...
autoload -Uz compinit
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
HISTSIZE=5000
SAVEHIST=10000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
alias history="history 0"     # force zsh to show the complete history

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# ---------------------------- GIT plugin for prompt  -------------------------------------------------------
autoload -Uz vcs_info # autoload marks the name as being a function rather than external program
if [ ! -f $HOME/dotfiles/zsh/plugins/git-prompt/git-prompt.zsh ]; then
    echo "Zsh-git-prompt is not installed..."
    echo "Installing git-prompt..."
    git clone -v https://github.com/woefe/git-prompt.zsh $HOME/dotfiles/zsh/plugins/git-prompt
fi
source $HOME/dotfiles/zsh/plugins/git-prompt/git-prompt.zsh
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR="%F{cyan}|%f"
ZSH_THEME_GIT_PROMPT_BRANCH="%B%b%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[magenta]%}(%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[magenta]%})"
ZSH_GIT_PROMPT_SHOW_UPSTREAM="full"

# ---------------------------- Kubernetes prompt -------------------------------------------------------
if [ ! -f $HOME/dotfiles/zsh/plugins/kube-ps1/kube-ps1.sh ]; then
    echo "Zsh-kube-ps1 is not installed..."
    echo "Installing kube-ps1..."
    git clone -v git@github.com:jonmosco/kube-ps1.git $HOME/dotfiles/zsh/plugins/kube-ps1
    if [ ! -f /usr/local/bin/kubectl ]; then echo "kubectl is not installed..."; fi
fi
source $HOME/dotfiles/zsh/plugins/kube-ps1/kube-ps1.sh
KUBE_PS1_PREFIX="%F{cyan}[%f"
KUBE_PS1_SUFFIX="%F{cyan}]%f"
KUBE_PS1_SEPARATOR="%F{cyan}|%f"
KUBE_PS1_SYMBOL_PADDING=true
kube_ps1_autohide() { kube_ps1 | sed 's/^(.*}N\/A%.*:.*}N\/A%.*)$//' }

# -------------------------- PROMPT -----------------------------------------------
# Check if our terminal emulator supports colors
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Check if we are in python venv
function venv_prompt_info() {
  [ $VIRTUAL_ENV ] && echo "(%F{green}$(basename $VIRTUAL_ENV)%F{cyan})-"
}

prompt_symbol=㉿
[ "EUID" = 0 ] && prompt_symbol=💀
[ $(uname) = "Darwin" ] && prompt_symbol=@
# Zsh prompt special characters: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# %m ... machine hostname up to the first '.'
# %n ... username
# --------- Visual Effects --------------
# %F{color}<text>%f        start/end color mode
# %B<text>%b               start/end bold mode
PROMPT_USER_MACHINE='%F{cyan}┌──$(venv_prompt_info)(%f%B%F{blue}%n${prompt_symbol}%m%b%f%F{cyan})%f'
PROMPT_PATH='%F{cyan}-[%f%B%(6~.%-1~/…/%4~.%5~)%b%f%F{cyan}]%f' # %B  -> Start (stop) boldface mode
PROMPT_GIT='%F{cyan}-[%f%B%F{magenta}$(gitprompt)%b%F{cyan}]%f' # TODO manually
PROMPT_KUBE='%F{cyan}-%f$(kube_ps1_autohide)'
PROMPT_LINE2=$'\n%F{cyan}└─%B%f%F{blue}$%b%f '

PROMPT="$PROMPT_USER_MACHINE"'$PROMPT_PATH'"$PROMPT_GIT""$PROMPT_KUBE"'$PROMPT_LINE2'

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
         PROMPT="$PROMPT_USER_MACHINE"'$PROMPT_PATH'"$PROMPT_KUBE"'$PROMPT_LINE2'
     else
         PROMPT="$PROMPT_USER_MACHINE"'$PROMPT_PATH'"$PROMPT_GIT""$PROMPT_KUBE"'$PROMPT_LINE2'
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
# Enable auto-suggestions based on the history: https://github.com/zsh-users/zsh-autosuggestions
if [ ! -f ~/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    echo "Zsh-autosuggestions is missing."
    echo "Downloading (https://github.com/zsh-users/zsh-autosuggestions)..."
    git clone -v https://github.com/zsh-users/zsh-autosuggestions ~/dotfiles/zsh/plugins/zsh-autosuggestions
fi
. ~/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh # Source the plugin
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999' # Change suggestion color to grey
ZSH_AUTOSUGGEST_STRATEGY=(history) # https://github.com/zsh-users/zsh-autosuggestions#suggestion-strategy
# ZSH_AUTOSUGGEST_MANUAL_REBIND=false # https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding
unset ZSH_AUTOSUGGEST_USE_ASYNC # https://github.com/zsh-users/zsh-autosuggestions#asynchronous-mode

# ---------------------------- COMMAND-NOT-FOUND ------------------------------------------------
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
fi

# ---------------------------- ALIASES --------------------------------------------------------
# Check if lvim is instaleld
if command -v lvim &> /dev/null; then
    alias vim="lvim"
fi
export EDITOR=vim

# ---------------------------- Macos-specific ---------------------------------------------------
if [ $(uname) = "Darwin" ]; then
    source ~/dotfiles/macos/macos.zsh 
fi

compinit -d ~/.cache/zcompdump # Enable completition features, must be called after: https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh

# Load Angular CLI autocompletion.
source <(ng completion script)

# Load kubernetes autocomplete
source <(kubectl completion zsh)

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

