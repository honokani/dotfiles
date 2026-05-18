#!/usr/bin/zsh
# git must be installed, because this file must be got from github.



# make git clone directory
GC_NAME=$(pwd|awk -F/ '{print $(NF-1)}')
GC=$HOME/$GC_NAME
DF_NAME=$(pwd|awk -F/ '{print $(NF)}')
[[ ! -d "$GC" ]] && mkdir -p "$GC"
# link dotfiles
$GC/$DF_NAME/link_dotfiles.sh



case "$(uname)" in
    Linux*)
        # install apt dependencies for C-extension Python packages (matplotlib, pillow, etc.)
        echo "Installing apt dependencies..."
        sudo apt update
        sudo apt install -y \
            build-essential \
            language-pack-ja \
            python3-tk \
            libfreetype6-dev \
            zlib1g-dev \
            vim

        # install uv (official standalone installer)
        if ! command -v uv > /dev/null 2>&1; then
            echo "Installing uv..."
            curl -LsSf https://astral.sh/uv/install.sh | sh
        else
            echo "Updating uv..."
            uv self update
        fi
        ;;
    MINGW*|MSYS*)
        # Windows (git bash / msys2) - 事前に zsh 済み前提
        # install scoop (公式 PowerShell installer)
        if ! command -v scoop > /dev/null 2>&1; then
            echo "Installing scoop..."
            powershell -ExecutionPolicy ByPass -c "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression"
            export PATH="$HOME/scoop/shims:$PATH"
        fi

        # install uv (official PowerShell installer)
        if ! command -v uv > /dev/null 2>&1; then
            echo "Installing uv (official PowerShell installer)..."
            powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
        else
            echo "Updating uv..."
            uv self update
        fi

        # install vim (via scoop)
        if ! command -v vim > /dev/null 2>&1; then
            echo "Installing vim (via scoop)..."
            scoop install vim
        fi
        ;;
esac



# install fzf (OS共通: git clone + install)
if [ ! -d "$HOME/.fzf" ]; then
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-update-rc
else
    echo "Updating fzf..."
    (cd "$HOME/.fzf" && git pull && ./install --all --no-update-rc)
fi



source ~/.zshrc
