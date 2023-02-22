# https://stackoverflow.om/a/22779469
# https://stackoverflow.com/a/29471921
# https://stackoverflow.com/questions/11916064/zsh-tab-completion-duplicating-command-name: duplicate
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

. "$HOME/.cargo/env"

# Tmux problem (with locales texts gets multiplied when autocompletition feature is used)
# https://unix.stackexchange.com/a/541352
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi
