#!/bin/bash

# Windows環境でのシンボリックリンク設定
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    export MSYS="${MSYS:+$MSYS:}winsymlinks:nativestrict"
    echo "INFO: Set MSYS=winsymlinks:nativestrict for proper symlink support"
fi

: "SET_BASE_PATH" && {
    # cd の stdout を捨てる (zsh から source された場合の chpwd hook 出力混入を防ぐ)
    PTH_D_BASE=$(cd "$(dirname "$0")" >/dev/null && pwd)
}

# 共通関数：安全にシンボリックリンクを張る (ファイル / ディレクトリ両対応)
link_dotfile() {
    local target_path="$1"
    local source_path="$2"

    if [ -L "$target_path" ]; then
        rm "$target_path"
    elif [ -e "$target_path" ]; then
        echo "WARN: real $target_path exists already. backuped."
        mv "$target_path" "${target_path}_bk"
    fi

    ln -s "$source_path" "$target_path"

    # シンボリックリンクが正しく作成されたかチェック
    if [[ -L "$target_path" ]]; then
        echo "INFO: Created symlink: $target_path -> $source_path"
    else
        echo "WARN: Symlink creation may have failed for: $target_path"
    fi
}

: "LINK_OS_BASE_DIRS_FOR_WINDOWS" && {
    # Windows では HOME 外 (/c 直下) を作業領域として使うが、スクリプト/zshrc 側は $HOME ベースで統一するため
    # $HOME/git_clone -> /c/git_clone, $HOME/ws -> /c/ws の symlink を張って吸収する
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        [[ ! -d "/c/git_clone" ]] && mkdir -p "/c/git_clone"
        [[ ! -d "/c/ws" ]] && mkdir -p "/c/ws"
        link_dotfile "$HOME/git_clone" "/c/git_clone"
        link_dotfile "$HOME/ws" "/c/ws"
    fi
}

: "LINK_DOTS_OF_VIM" && {
    link_dotfile "$HOME/.vimrc" "$PTH_D_BASE/dot_vimrc.vim"
}

: "LINK_DOTS_OF_TMUX" && {
    link_dotfile "$HOME/.tmux.conf" "$PTH_D_BASE/dot_tmux.conf"
}

: "LINK_DOTS_OF_ZSH" && {
    # OS ごとにリンクする for_* ファイル群。dot_zshrc.sh の Unix継承ロード構造と一致させる:
    #   Mac=common→linux→mac, Linux=common→linux, WSL=common→linux→wsl, Windows=common→windows
    # (Mac/WSL は for_linux を継承するので linux も必ずリンクする)
    case "$(uname)" in
        Darwin)
            uniques=(linux mac)
            ;;
        Linux)
            if [[ -n "$WSL_DISTRO_NAME" ]] || \
               [[ -n "$WSL_INTEROP" ]] || \
               grep -qi microsoft /proc/version 2>/dev/null; then
                uniques=(linux wsl)
            else
                uniques=(linux)
            fi
            ;;
        MINGW32_NT*|MINGW64_NT*)
            uniques=(windows)
            ;;
        *)
            uniques=()
            ;;
    esac

    link_dotfile "$HOME/.zshrc" "$PTH_D_BASE/dot_zshrc.sh"
    link_dotfile "$HOME/.zshrc_for_common" "$PTH_D_BASE/dot_zshrc_for_common.sh"
    link_dotfile "$HOME/.zshrc_util" "$PTH_D_BASE/dot_zshrc_util.sh"
    if [ ${#uniques[@]} -gt 0 ]; then
        for unique in "${uniques[@]}"; do
            echo "link for $unique"
            link_dotfile "$HOME/.zshrc_for_$unique" "$PTH_D_BASE/dot_zshrc_for_${unique}.sh"
        done
    else
        echo "no_uniq_file"
    fi
}
