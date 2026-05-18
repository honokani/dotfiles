#!/usr/bin/zsh
# git must be installed, because this file must be got from github.



# link dotfiles (call from script's directory)
# Windows では link_dotfiles.sh が $HOME/git_clone -> /c/git_clone, $HOME/ws -> /c/ws の symlink も作成する
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
"$SCRIPT_DIR/link_dotfiles.sh"

# ensure git_clone directory exists (Linux/Mac/WSL のみ。Windows は link_dotfiles.sh で symlink 済み)
[[ ! -d "$HOME/git_clone" ]] && mkdir -p "$HOME/git_clone"



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



echo ""
echo "Setup complete. Please run 'zrc' or restart your shell to reload zshrc."
