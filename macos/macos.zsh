# ---------------------------- MAC SPECIFIC --------------------------------------------------------------
# Replace MACOS commands with GNU commands
# Use GNU utilities: https://apple.stackexchange.com/questions/69223/how-to-replace-mac-os-x-utilities-with-gnu-core-utilities
# (GNU version of basic commands)
if [ $(uname) = "Darwin" ]
then
    alias python=python3
    alias pip=pip3
    # Add brew autocompletitions
    if type brew &>/dev/null; then
      FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
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

    # Error: unable to get local issuer certificate
    # 1. https://stackoverflow.com/a/42107877
    # 2. https://stackoverflow.com/a/57795811 
    # Also check if we are located in venv, if so, use the system python
    if [ -z "$VIRTUAL_ENV" ]; then
      CERT_PATH=$(python3 -c "import certifi; print(certifi.where())")
      export SSL_CERT_FILE=$CERT_PATH
      export REQUESTS_CA_BUNDLE=$CERT_PATH
    else 
      CERT_PATH=$(python -m certifi)
      export SSL_CERT_FILE=${CERT_PATH}
      export REQUESTS_CA_BUNDLE=${CERT_PATH}
    fi
fi

