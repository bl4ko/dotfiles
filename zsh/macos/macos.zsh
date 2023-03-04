# ---------------------------- MAC SPECIFIC --------------------------------------------------------------
# Brew also provides command completitions, for all downloaded packages.
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# PROBLEM: 23.2.2023, takes to much time to load in (startup)
#   current solution is lazy loading autocompletions manually
# if type brew &>/dev/null; then
#   FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
# fi


# https://github.com/Homebrew/homebrew-command-not-found
# Tap command adds another repository to brew (homebrew/command-not-found) https://stackoverflow.com/a/37973017
# List of taps: brew tap (brew untap = remove tap)
# if [ -z $(brew tap | grep command-not-found) ]; then
#   echo "Installing brew command-not-found"
#   brew tap -v homebrew/command-not-found
# fi
# HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
# if [ -f "$HB_CNF_HANDLER" ]; then
# source "$HB_CNF_HANDLER";
# else
#   echo "Failed tapping homebrew/command-not-found"
# fi
#

# if [ ! -d /opt/homebrew/opt/grep/libexec/gnubin ]; then
#     brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep
# fi

# PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
# PATH="/opt/homebrew/gnu-getopt/libexec/gnubin:$PATH"
# PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
# PATH="/opt/homebrew/opt/gnu-indent/libexec/gnubin:$PATH"
# PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
# PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
# PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH" # https://stackoverflow.com/questions/69574792/gnu-find-cant-find-root-directory-find-failed-to-read-file-names-from-file
# export PATH

# Also acces their man pages with normal names
# MANPATH="/opt/homebrew/Cellar/libtool/2.4.7/libexec/gnuman:$MANPATH"
# MANPATH="/opt/homebrew/Cellar/coreutils/9.1/libexec/gnuman:$MANPATH"
# MANPATH="/opt/homebrew/Cellar/gnu-indent/2.2.12_1/libexec/gnuman:$MANPATH"
# MANPATH="/opt/homebrew/Cellar/gnu-tar/1.34_1/libexec/gnuman:$MANPATH"
# MANPATH="/opt/homebrew/Cellar/grep/3.7/libexec/gnuman:$MANPATH"
# MANPATH="/opt/homebrew/Cellar/gnu-sed/4.8/libexec/gnuman:$MANPATH"
# MANPATH="/opt/homebrew/Cellar/gawk/5.1.1/libexec/gnuman:$MANPATH"
# MANPATH="/opt/homebrew/Cellar/findutils/4.9.0/libexec/gnuman:$MANPATH" # https://stackoverflow.com/questions/69574792/gnu-find-cant-find-root-directory-find-failed-to-read-file-names-from-file
# export MANPATH

