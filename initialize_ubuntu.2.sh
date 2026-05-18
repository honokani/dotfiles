#!/usr/bin/zsh
# git must be installed, because this file must be got from github.



# make git clone directory
GC_NAME=$(pwd|awk -F/ '{print $(NF-1)}')
GC=$HOME/$GC_NAME
DF_NAME=$(pwd|awk -F/ '{print $(NF)}')
[[ ! -d "$GC" ]] && mkdir -p "$GC"
# link dotfiles
$GC/$DF_NAME/link_dotfiles.sh



# install apt dependencies for C-extension Python packages (matplotlib, pillow, etc.)
echo "Installing apt dependencies..."
sudo apt update
sudo apt install -y \
    build-essential \
    language-pack-ja \
    python3-tk \
    libfreetype6-dev \
    zlib1g-dev



# install uv (official standalone installer)
if ! command -v uv > /dev/null 2>&1; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "Updating uv..."
    uv self update
fi



source ~/.zshrc
