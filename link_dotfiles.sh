#!/bin/bash

: "INITIALIZE" && {
    PTH_D_BASE=$(cd "$(dirname "$0")" && pwd)
    source "$PTH_D_BASE/dot_zshrc_util.sh"
    judge_os
    # Windows environment symlink settings
    if [[ "$OS_TYPE" == "windows" ]]; then
        export MSYS="${MSYS:+$MSYS:}winsymlinks:nativestrict"
        echo "INFO: Set MSYS=winsymlinks:nativestrict for proper symlink support"
    fi
}


# Common function: Safely create symbolic links
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
    
    # Check if symlink was created successfully
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
    # Link common files
    link_dotfile "$HOME/.zshrc" "$PTH_D_BASE/dot_zshrc.sh"
    link_dotfile "$HOME/.zshrc_for_common" "$PTH_D_BASE/dot_zshrc_for_common.sh"
    link_dotfile "$HOME/.zshrc_util" "$PTH_D_BASE/dot_zshrc_util.sh"
    
    # Link OS-specific file if exists
    case "$OS_TYPE" in
        mac|linux|wsl|windows)
            echo "Linking OS-specific config for: $OS_TYPE"
            link_dotfile "$HOME/.zshrc_for_$OS_TYPE" "$PTH_D_BASE/dot_zshrc_for_${OS_TYPE}.sh"
            ;;
        *)
            echo "No OS-specific config file (OS_TYPE: $OS_TYPE)"
            ;;
    esac
}
