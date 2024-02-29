# zmodload zsh/zprof # Uncomment **this** and **last line** to measure performances: https://stevenvanbael.com/profiling-zsh-startup 

# README: https://htr3n.github.io/2018/07/faster-zsh/
# Possible improvements: https://github.com/zdharma-continuum/zinit,

# --------------------------- Custom utils ------------------------------------------------------
export DOTFILES="$HOME/dotfiles"
source $DOTFILES/utils.sh

# ---------------------------- ZSH-OPTIONS -------------------------------------------------------
setopt autocd                # change directory just by typing its name
setopt correct               # auto correct mistakes
setopt interactivecomments   # allow comments in interactive mode
setopt magicequalsubst       # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch             # hide error message if there is no match for the pattern
setopt notify                # report the status of background jobs immediately
setopt numericglobsort       # sort filenames numerically when it makes sense
setopt promptsubst           # enable command substitution in prompt (check precmd() funciton required!!!)

WORDCHARS=${WORDCHARS//\/} # remove / from wordchars (ask chatgpt why)
PROMPT_EOL_MARK="" # hide EOL sign ('%')

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
# zstyle ':completion:*' use-compctl false
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
alias history="history 0"     # force zsh to show the complete history

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# ---------------------------- ALIASES --------------------------------------------------------
alias python=python3
alias pip=pip3


# Check if nvim is instaleld
if command -v nvim &> /dev/null; then
   alias vim="nvim"
fi
if command -v kubecm &> /dev/null; then
  alias kc="kubecm"
fi

# --------------------------- EXPORTS ---------------------------------------------------------
export EDITOR=vim
export SYSTEMD_EDITOR=vim # for systemctl edit: https://unix.stackexchange.com/a/408419
if command -v gpg &> /dev/null; then
  export GPG_TTY=$(tty) # For gpg to work properly
fi

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=$PATH:$HOME/.local/bin

if test -d "$HOME/.kubescape/bin" &> /dev/null; then
 export PATH=$PATH:$HOME/.kubescape/bin
fi
if command -v snap &> /dev/null; then
 export PATH=$PATH:/snap/bin
fi

export PATH=$PATH:/usr/local/go/bin
export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin

# ---------------------------- OS-specific ---------------------------------------------------
if [ "$(uname)" = "Darwin" ]; then
    source $DOTFILES/zsh/macos/macos.zsh 
elif [ "$(uname)" = "Linux" ]; then
    source $DOTFILES/zsh/linux/linux.zsh
fi

autoload -U +X bashcompinit && bashcompinit

complete -o nospace -C /opt/homebrew/bin/terraform terraform

# -------------------------- PROMPT -----------------------------------------------
source "$DOTFILES/zsh/plugins/git-prompt.zsh"
source "$DOTFILES/zsh/plugins/kube-ps1.zsh"


# Check if we are in python venv
function venv_prompt_info() {
  [ $VIRTUAL_ENV ] && echo "(%F{green}$(basename $VIRTUAL_ENV)%F{cyan})-"
}

PROMPT_SYMBOL=㉿
[ "$EUID" -eq 0 ] && PROMPT_SYMBOL=💀
[ $(uname) = "Darwin" ] && PROMPT_SYMBOL='㊅' # ㊀ '㉺㉰㉭㊅㊀

# Zsh prompt special characters: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# %m ... machine hostname up to the first '.'
# %n ... username
# --------- Visual Effects --------------
# %F{color}<text>%f        start/end color mode
# %B<text>%b               start/end bold mode
PROMPT_USER_MACHINE='%F{cyan}┌──$(venv_prompt_info)(%f%B%F{blue}%n${PROMPT_SYMBOL}%m%b%f%F{cyan})%f'
PROMPT_PATH='%F{cyan}-[%f%B%(6~.%-1~/…/%4~.%5~)%b%f%F{cyan}]%f' # %B  -> Start (stop) boldface mode
PROMPT_GIT='%F{cyan}-[%f%B%F{magenta}$(gitprompt)%b%F{cyan}]%f' # TODO manually
PROMPT_KUBE="$(command -v kubectl &> /dev/null && echo '$(kube_ps1)' || echo '')"
PROMPT_LINE2=$'\n%F{cyan}└─%B%f%F{blue}$%b%f '
PROMPT="$PROMPT_USER_MACHINE"'$PROMPT_PATH'"$PROMPT_GIT""$PROMPT_KUBE"'$PROMPT_LINE2'

# -------------------------- precmd() ---------------------------------------------
# precmd function runs before each prompt
precmd() {
    # Print a new line before the prompt, but only if it is not the first line
    if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
      _NEW_LINE_BEFORE_PROMPT=1
    else
      print ""
    fi

    vcs_info # Required for checking if we are in a git repo [[ -z ${vcs_info_msg_0_} ]]

     # Check if we are located in git repository, and if so, add git info to prompt
     if [[ -z ${vcs_info_msg_0_} ]]; then
       PROMPT="$PROMPT_USER_MACHINE"'$PROMPT_PATH'"$PROMPT_KUBE"'$PROMPT_LINE2'
     else
       PROMPT="$PROMPT_USER_MACHINE"'$PROMPT_PATH'"$PROMPT_GIT""$PROMPT_KUBE"'$PROMPT_LINE2'
     fi
 }

# ---------------------------- PLUGINS --------------------------------------------------------
source "$DOTFILES/zsh/plugins/zsh-autosuggestions.zsh"
source "$DOTFILES/zsh/plugins/zsh-syntax-highlighting.zsh"
source "$DOTFILES/zsh/plugins/helm.zsh"
source "$DOTFILES/zsh/plugins/nvm.zsh"
source "$DOTFILES/zsh/plugins/kubectl.zsh"
source "$DOTFILES/zsh/plugins/kubecm.zsh"
source "$DOTFILES/zsh/plugins/ng.zsh"



# zprof # Uncomment **this** and **first line** to measure performance...
