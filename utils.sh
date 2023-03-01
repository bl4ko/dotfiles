#!/bin/bash
# Set these values so the installer can still run in color
COL_NC='\033[0m' # No Color
COL_LIGHT_GREEN='\033[1;32m'
COL_LIGHT_RED='\033[1;31m'
COL_BLUE='\033[0;34m'
COL_CYAN='\033[0;36m'
TICK="[${COL_LIGHT_GREEN}✓${COL_NC}]"
CROSS="[${COL_LIGHT_RED}✗${COL_NC}]"
INFO="[${COL_BLUE}i${COL_NC}]"
DONE="${COL_LIGHT_GREEN} done!${COL_NC}"
DOTFILES="$HOME/dotfiles"
