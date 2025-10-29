#!/usr/bin/zsh

: "GET_BASE_PATHS" && {
    # make git clone directory
    GC_NAME=$(pwd|awk -F/ '{print $(NF-1)}')
    GC=$HOME/$GC_NAME
    DF_NAME=$(pwd|awk -F/ '{print $(NF)}')
    [[ ! -d "$GC" ]] && mkdir -p "$GC"
    
    # Set dotfiles path for loading judge_os function
    DF_PATH="$GC/$DF_NAME"
    
    source "$DF_PATH/dot_zshrc_util.sh"
    judge_os

}

: "COMMON_SETUP" && {
    echo ""
    echo "Git clone directory: $GC"
    echo "Dotfiles directory: $DF_PATH"
    
    # link dotfiles
    echo ""
    echo "Linking dotfiles..."
    $DF_PATH/link_dotfiles.sh
}


# prepare to install python3, to use visual libraries.
: "INSTALL_PYTHON_DEPENDENCIES" && {
    echo ""
    echo "=========================================="
    echo "Installing Python build dependencies..."
    echo "=========================================="
    
    case "$OS_TYPE" in
        linux|wsl)
            # Linux/WSL: apt packages
            echo "Installing packages via apt..."
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
            ;;
            
        mac)
            # Mac: Homebrew packages
            echo "Installing packages via Homebrew..."
            
            # Check if Homebrew is installed
            if ! command -v brew &> /dev/null; then
                echo "⚠️  Homebrew is not installed."
                echo "Install Homebrew first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                echo "Skipping dependency installation..."
            else
                # Install required packages
                brew install \
                    openssl \
                    readline \
                    sqlite3 \
                    xz \
                    zlib \
                    tcl-tk
                
                echo "✓ Homebrew packages installed"
            fi
            ;;
            
        windows)
            # Windows Git Bash: minimal dependencies (most are provided by Python installer)
            echo "Windows detected. Python dependencies are usually provided by the official Python installer."
            echo "If you need to build Python from source, install Visual Studio Build Tools."
            ;;
            
        *)
            echo "Unknown OS. Skipping dependency installation."
            ;;
    esac
    
    echo "Python dependencies setup completed"
}



# install pyenv, pyenv-virtualenv
: "INSTALL_PYENV" && {
    # pyenv
    if [[ ! -d "$GC/pyenv" ]]; then
        echo "Installing pyenv..."
        git clone https://github.com/pyenv/pyenv "$GC/pyenv"
    else
        echo "Updating pyenv..."
        cd "$GC/pyenv" && git pull && cd -
    fi
    [[ ! -L "$HOME/.pyenv" ]] && ln -s "$GC/pyenv" "$HOME/.pyenv"# 
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
    # connect
    [[ ! -d "$HOME/.pyenv/plugins" ]] && mkdir -p "$HOME/.pyenv/plugins"
    [[ ! -L "$PLUGIN_LINK" ]] && ln -s "$PLUGIN_DIR" "$PLUGIN_LINK"
    echo "pyenv & pyenv-virtualenv installed"
}


source ~/.zshrc 2>/dev/null || echo "WARNING: Please manually run: source ~/.zshrc"
