#!/bin/bash

# Windows環境でのシンボリックリンク設定
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    export MSYS="${MSYS:+$MSYS:}winsymlinks:nativestrict"
    echo "INFO: Set MSYS=winsymlinks:nativestrict for proper symlink support"
fi

: "SET_BASE_PATH" && {
    PTH_D_BASE=$(cd "$(dirname "$0")" && pwd)
}

# 共通関数：安全にシンボリックリンクを張る
link_dotfile() {
    local target_path="$1"
    local source_path="$2"

    if [ -L "$target_path" ]; then
        rm "$target_path"
    elif [ -f "$target_path" ]; then
        echo "WARN: real $target_path file exists already. backuped."
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

: "LINK_DOTS_OF_VIM" && {
    link_dotfile "$HOME/.vimrc" "$PTH_D_BASE/dot_vimrc.vim"
}

: "LINK_DOTS_OF_ZSH" && {
    case "$(uname)" in
        Darwin)
            unique="mac"
            ;;
        Linux)
            if [[ -n "$WSL_DISTRO_NAME" ]] || \
               [[ -n "$WSL_INTEROP" ]] || \
               grep -qi microsoft /proc/version 2>/dev/null; then
                unique="wsl"
            else
                unique="linux"
            fi
            ;;
        MINGW32_NT*|MINGW64_NT*)
            unique="windows"
            ;;
        *)
            unique=""
            ;;
    esac

    link_dotfile "$HOME/.zshrc" "$PTH_D_BASE/dot_zshrc.sh"
    link_dotfile "$HOME/.zshrc_for_common" "$PTH_D_BASE/dot_zshrc_for_common.sh"
    link_dotfile "$HOME/.zshrc_util" "$PTH_D_BASE/dot_zshrc_util.sh"
    if [ -n "$unique" ]; then
        echo "link for $unique"
        link_dotfile "$HOME/.zshrc_for_$unique" "$PTH_D_BASE/dot_zshrc_for_${unique}.sh"
    else
        echo "no_uniq_file"
    fi
}
