: "Call_zsh_core_for_each_OS" && {
    CURR_OS=""
    . "$HOME/.zshrc_util"
    # . "$HOME/.zshrc_sandbox"
    if [[ "$(uname)" =~ 'Darwin' ]]; then
        CURR_OS="Mac"
        . "$HOME/.zshrc_for_common"
        . "$HOME/.zshrc_for_mac"
    elif [[ "$(uname)" =~ 'Linux' ]]; then
        if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
            CURR_OS='WindowsSubsystemLinux'
            . "$HOME/.zshrc_for_common"
            . "$HOME/.zshrc_for_wsl"
        else
            CURR_OS="Linux not WSL"
            . "$HOME/.zshrc_for_common"
        fi
    elif [[ "$(uname)" =~ 'MINGW32_NT' ]]; then
        CURR_OS="Windows 32bit"
        . "$HOME/.zshrc_for_windows"
    elif [[ "$(uname)" =~ 'MINGW64_NT' ]]; then
        CURR_OS="Windows 64bit"
        . "$HOME/.zshrc_for_windows"
    fi

    if [ -z "$CURR_OS" ]; then
        echo "Platform is : ($(uname -a))"
    else
        echo "Platform is ""$CURR_OS"". "
        echo "Here is on ""$SHELL"". And zshrc has loaded. "
    fi
}

