echo $SHELL
: "Call_zsh_core_for_each_OS" && {
    . "$HOME/.zshrc_util"
    . "$HOME/.zshrc_sandbox"
    if [[ "$(uname)" =~ 'Darwin' ]]; then
        CURR_OS='Mac'
        printf "Platform is ""$CURR_OS"". "
        . "$HOME/.zshrc_for_common"
        . "$HOME/.zshrc_for_mac"
        echo " zshrc has loaded. "
    elif [[ "$(uname)" =~ 'Linux' ]]; then
        if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
            CURR_OS='WindowsSubsystemLinux'
            printf "Platform is ""$CURR_OS"". "
            . "$HOME/.zshrc_for_common"
            . "$HOME/.zshrc_for_wsl"
            echo " zshrc has loaded. "
        else
            CURR_OS='Linux not WSL'
            printf "Platform is ""$CURR_OS"". "
            echo " zshrc has loaded. "
        fi
    elif [[ "$(uname)" =~ 'MINGW32_NT' ]]; then
        CURR_OS='Windows 32bit'
        printf "Platform is ""$CURR_OS"". "
        . "$HOME/.zshrc_for_common"
        . "$HOME/.zshrc_for_windows"
        echo " zshrc has loaded. "
    elif [[ "$(uname)" =~ 'MINGW64_NT' ]]; then
        CURR_OS='Windows 64bit'
        printf "Platform is ""$CURR_OS"". "
        . "$HOME/.zshrc_for_common"
        . "$HOME/.zshrc_for_windows"
        echo " zshrc has loaded. "
    else
        echo "Platform is : ($(uname -a))"
    fi
}

