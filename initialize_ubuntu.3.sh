#!/usr/bin/zsh
# initialize_ubuntu_optional.sh
# =============================
# 必要に応じて実行するオプション設定

# 色付き出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }

# =============================
# Neovim環境構築
# =============================
setup_neovim() {
    log_info "Neovim環境を構築します..."
    
    # Neovimインストール
    if ! command -v nvim &> /dev/null; then
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:neovim-ppa/stable
        sudo apt-get update
        sudo apt-get install -y neovim
    else
        log_info "Neovimは既にインストールされています"
    fi
    
    # Python環境（Python3のみ、Python2は廃止）
    eval "$(pyenv init -)"
    
    # 最新のPython3をインストール
    local PYTHON_VERSION="3.12.2"
    if ! pyenv versions | grep -q "$PYTHON_VERSION"; then
        log_info "Python $PYTHON_VERSION をインストール中..."
        pyenv install "$PYTHON_VERSION"
    fi
    
    # Neovim用仮想環境（Python3のみ）
    if ! pyenv versions | grep -q "neovim3"; then
        pyenv virtualenv "$PYTHON_VERSION" neovim3
        pyenv activate neovim3
        pip install --upgrade pip
        pip install pynvim  # neovimパッケージは非推奨、pynvimを使用
        pyenv deactivate
    fi
    
    # グローバルPython設定
    pyenv global "$PYTHON_VERSION"
    
    # Git設定
    git config --global core.editor nvim
    
    log_info "Neovim環境構築完了"
}

# =============================
# 開発ツール
# =============================
setup_dev_tools() {
    log_info "開発ツールをインストール中..."
    
    # 基本ディレクトリ作成
    [[ ! -d "$HOME/ws" ]] && mkdir "$HOME/ws"
    [[ ! -d "$HOME/sandbox" ]] && mkdir "$HOME/sandbox"
    
    # 便利なツール
    sudo apt install -y \
        gawk \
        tree \
        w3m \
        zip \
        ripgrep \
        fzf \
        bat \
        fd-find \
        jq
    
    # ctags (universal-ctagsの方が推奨)
    if ! command -v ctags &> /dev/null; then
        sudo apt install -y universal-ctags || sudo apt install -y exuberant-ctags
    fi
    
    # Node.js環境（nvmを推奨）
    if ! command -v node &> /dev/null; then
        # nvmインストール
        if [[ ! -d "$HOME/.nvm" ]]; then
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/latest/install.sh | PROFILE=/dev/null bash
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            
            # 最新LTSをインストール
            nvm install --lts
            nvm use --lts
            
            # 必要なパッケージ
            npm install -g yarn neovim
        fi
    else
        log_info "Node.jsは既にインストールされています"
    fi
    
    # exa (lsの代替) - 新しい方法でインストール
    if ! command -v exa &> /dev/null; then
        # cargo経由でインストール（Rustが必要）
        if command -v cargo &> /dev/null; then
            cargo install exa
        else
            log_warn "exaのインストールにはRustが必要です: https://www.rust-lang.org/tools/install"
        fi
    fi
    
    log_info "開発ツールのインストール完了"
}

# =============================
# tmux設定
# =============================
setup_tmux() {
    log_info "tmux環境を構築中..."
    
    # tmuxインストール
    if ! command -v tmux &> /dev/null; then
        sudo apt install -y tmux
    fi
    
    # tmux設定ファイル作成（dotfilesに含めるべき）
    local TMUX_CONF="$HOME/.tmux.conf"
    if [[ ! -f "$TMUX_CONF" ]]; then
        cat > "$TMUX_CONF" << 'EOF'
# 基本設定
set-option -g default-shell $SHELL
set-option -g default-terminal "screen-256color"
set -g terminal-overrides 'xterm:colors=256'

# プレフィックスキー
set -g prefix C-q
unbind C-b

# ペイン分割
bind | split-window -h
bind - split-window -v

# インデックス
set-option -g base-index 1
set-window-option -g pane-base-index 1

# ステータスバー
set-option -g status-justify centre
set-option -g status-bg "colour238"
set-option -g status-fg "colour255"

# ペイン操作
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# マウス
set-option -g mouse on

# コピーモード
setw -g mode-keys vi
EOF
        log_info "tmux設定ファイルを作成しました: $TMUX_CONF"
    else
        log_info "tmux設定ファイルは既に存在します"
    fi
}

# =============================
# Xmonad環境（GUI環境用）
# =============================
setup_xmonad() {
    log_info "Xmonad環境を構築中..."
    
    sudo apt install -y \
        xmonad \
        xmobar \
        dmenu \
        rxvt-unicode-256color \
        feh \
        xcompmgr
    
    log_info "Xmonad環境構築完了"
}

# =============================
# メニュー
# =============================
main() {
    echo "================================"
    echo "Ubuntu オプション設定"
    echo "================================"
    echo "1) Neovim環境構築"
    echo "2) 開発ツールインストール"
    echo "3) tmux設定"
    echo "4) Xmonad環境構築（GUI用）"
    echo "5) すべて実行"
    echo "q) 終了"
    echo ""
    
    read "choice?選択してください (1-5/q): "
    
    case $choice in
        1) setup_neovim ;;
        2) setup_dev_tools ;;
        3) setup_tmux ;;
        4) setup_xmonad ;;
        5) 
            setup_neovim
            setup_dev_tools
            setup_tmux
            # Xmonadは必要な場合のみ
            read "xmonad_choice?Xmonad環境も構築しますか？ (y/N): "
            [[ "$xmonad_choice" =~ ^[Yy]$ ]] && setup_xmonad
            ;;
        q) echo "終了します" ;;
        *) echo "無効な選択です" ;;
    esac
}

# 実行
main
