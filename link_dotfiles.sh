#!/bin/bash

: "SET_BASE_PATH" && {
    PTH_D_BASE=$(cd $(dirname $0);pwd)
}

: "LINK_DOTS_OF_VIM" && {
    PTH_L_VIMRC="$HOME/.vimrc"
    PTH_F_RAW_VIMRC="$PTH_D_BASE/dot_vimrc.vim"
    if [ -L "$PTH_L_VIMRC" ]; then
        rm "$PTH_L_VIMRC"
    else
        if [ -f "$PTH_L_VIMRC" ]; then
            echo "WARN: real ""$PTH_L_VIMRC"" file exists already."
            mv "$PTH_L_VIMRC" "$PTH_L_VIMRC""_bk"
        fi
    fi
    ln -s "$PTH_F_RAW_VIMRC" "$PTH_L_VIMRC"
}

: "LINK_DOTS_OF_ZSH" && {
    PTH_L_ZSHRC_BASE="$HOME/.zshrc"
    PTH_F_RAW_ZSHRC_BASE="$PTH_D_BASE/dot_zshrc.sh"
    if [ -L "$PTH_L_ZSHRC_BASE" ]; then
        rm "$PTH_L_ZSHRC_BASE"
    else
        if [ -f "$PTH_L_ZSHRC_BASE" ]; then
            echo "WARN: real ""$PTH_L_ZSHRC_BASE"" file exists already."
            mv "$PTH_L_ZSHRC_BASE" "$PTH_L_ZSHRC_BASE""_bk"
        fi
    fi
    ln -s "$PTH_F_RAW_ZSHRC_BASE" "$PTH_L_ZSHRC_BASE"

    PTH_L_ZSHRC_COMMON="$HOME/.zshrc_for_common"
    PTH_F_RAW_ZSHRC_COMMON="$PTH_D_BASE/dot_zshrc_for_common.sh"
    if [ -L "$PTH_L_ZSHRC_COMMON" ]; then
        rm "$PTH_L_ZSHRC_COMMON"
    else
        if [ -f "$PTH_L_ZSHRC_COMMON" ]; then
            echo "WARN: real ""$PTH_L_ZSHRC_COMMON"" file exists already. backuped."
            mv "$PTH_L_ZSHRC_COMMON" "$PTH_L_ZSHRC_COMMON""_bk"
        fi
    fi
    ln -s "$PTH_F_RAW_ZSHRC_COMMON" "$PTH_L_ZSHRC_COMMON"

    PTH_L_ZSHRC_UTIL="$HOME/.zshrc_util"
    PTH_F_RAW_ZSHRC_UTIL="$PTH_D_BASE/dot_zshrc_util.sh"
    if [ -L "$PTH_L_ZSHRC_UTIL" ]; then
        rm "$PTH_L_ZSHRC_UTIL"
    else
        if [ -f "$PTH_L_ZSHRC_UTIL" ]; then
            echo "WARN: real ""$PTH_L_ZSHRC_UTIL"" file exists already. backuped."
            mv "$PTH_L_ZSHRC_UTIL" "$PTH_L_ZSHRC_UTIL""_bk"
        fi
    fi
    ln -s "$PTH_F_RAW_ZSHRC_UTIL" "$PTH_L_ZSHRC_UTIL"

    if [[ "$(uname)" =~ 'Darwin' ]]; then
        echo mac
        PTH_L_ZSHRC_UNIQUE="$HOME/.zshrc_for_mac"
        PTH_F_RAW_ZSHRC_UNIQUE="$PTH_D_BASE/dot_zshrc_for_mac.sh"
    elif [[ "$(uname)" =~ 'Linux' ]]; then
        if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
            echo wsl
            PTH_L_ZSHRC_UNIQUE="$HOME/.zshrc_for_wsl"
            PTH_F_RAW_ZSHRC_UNIQUE="$PTH_D_BASE/dot_zshrc_for_wsl.sh"
        else
            echo "no_uniq_file"
        fi
    elif [[ "$(uname)" =~ 'MINGW32_NT' ]]; then
        echo "windows 32bit"
        PTH_L_ZSHRC_UNIQUE="$HOME/.zshrc_for_windows"
        PTH_F_RAW_ZSHRC_UNIQUE="$PTH_D_BASE/dot_zshrc_for_windows.sh"
    elif [[ "$(uname)" =~ 'MINGW64_NT' ]]; then
        echo "windows 64bit"
        PTH_L_ZSHRC_UNIQUE="$HOME/.zshrc_for_windows"
        PTH_F_RAW_ZSHRC_UNIQUE="$PTH_D_BASE/dot_zshrc_for_windows.sh"
    else
        echo "no_uniq_file"
    fi

    if [ -z "$PTH_L_ZSHRC_UNIQUE" ]; then
        echo "no_uniq_file"
    else
        if [ -L "$PTH_L_ZSHRC_UNIQUE" ]; then
            rm "$PTH_L_ZSHRC_UNIQUE"
        else
            if [ -f "$PTH_L_ZSHRC_UNIQUE" ]; then
                echo "WARN: real ""$PTH_L_ZSHRC_UNIQUE"" file exists already."
                mv "$PTH_L_ZSHRC_UNIQUE" "$PTH_L_ZSHRC_UNIQUE""_bk"
            fi
        fi
        ln -s "$PTH_F_RAW_ZSHRC_UNIQUE" "$PTH_L_ZSHRC_UNIQUE"
    fi
}
