if [ ! -f $DOTFILES/zsh/plugins/loaded/git-prompt/git-prompt.zsh ]; then
  echo "${INFO} ${COL_BLUE}Zsh-git-prompt is not installed${COL_NC}. Trying to install it..."
  git clone -v https://github.com/woefe/git-prompt.zsh $DOTFILES/zsh/plugins/loaded/git-prompt
  echo "${TICK} zsh-git-prompt installed!"
fi
source $DOTFILES/zsh/plugins/loaded/git-prompt/git-prompt.zsh
autoload -Uz vcs_info # autoload marks the name as being a function rather than external program
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR="%F{cyan}|%f"
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[magenta]%}:%{$fg[magenta]%}"
# ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[magenta]%})"
ZSH_GIT_PROMPT_SHOW_UPSTREAM="full"
