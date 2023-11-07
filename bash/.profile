# This file gets loaded only on the first login
# If default shell is set to bash

# Required for tmux and other programs to work properly
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi