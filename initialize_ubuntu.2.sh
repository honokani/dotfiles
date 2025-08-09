#!/usr/bin/zsh
# git must be installed, because this file must be got from github.



# make git clone directory
GC_NAME=$(pwd|awk -F/ '{print $(NF-1)}')
GC=$HOME/$GC_NAME
DF_NAME=$(pwd|awk -F/ '{print $(NF)}')
[[ ! -d "$GC" ]] && mkdir -p "$GC"
# link dotfiles
$GC/$DF_NAME/link_dotfiles.sh



# prepare to install python3, to use visual libraries.
echo "Installing Python build dependencies..."
sudo apt update
sudo apt install -y \
    build-essential \
    openssl \
    language-pack-ja \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libffi-dev \
    libncurses5-dev \
    libncursesw5-dev \
    liblzma-dev \
    libxml2-dev \
    libxmlsec1-dev \
    python3-tk \
    tk-dev \
    libfreetype6-dev \
    zlib1g-dev



# pyenv, install pyenv-virtualenv
if [[ ! -d "$GC/pyenv" ]]; then
    echo "Installing pyenv..."
    git clone https://github.com/pyenv/pyenv "$GC/pyenv"
else
    echo "Updating pyenv..."
    cd "$GC/pyenv" && git pull && cd -
fi
[[ ! -L "$HOME/.pyenv" ]] && ln -s "$GC/pyenv" "$HOME/.pyenv"

# pyenv-virtualenv
PLUGIN_DIR="$GC/pyenv-virtualenv"
PLUGIN_LINK="$HOME/.pyenv/plugins/pyenv-virtualenv"
if [[ ! -d "$PLUGIN_DIR" ]]; then
    echo "Installing pyenv-virtualenv..."
    git clone https://github.com/pyenv/pyenv-virtualenv "$PLUGIN_DIR"
else
    echo "Updating pyenv-virtualenv..."
    cd "$PLUGIN_DIR" && git pull && cd -
fi
[[ ! -d "$HOME/.pyenv/plugins" ]] && mkdir -p "$HOME/.pyenv/plugins"
[[ ! -L "$PLUGIN_LINK" ]] && ln -s "$PLUGIN_DIR" "$PLUGIN_LINK"



source ~/.zshrc
