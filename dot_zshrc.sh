: "Call_zsh_core_for_each_OS" ; {
    source "$HOME/.zshrc_util"
    judge_os
    
    # Load OS-specific settings
    case "$OS_TYPE" in
        mac)
            CURR_OS="Mac"
            source "$HOME/.zshrc_for_mac"
            ;;
        wsl)
            CURR_OS='WSL on Windows'
            source "$HOME/.zshrc_for_wsl"
            ;;
        linux)
            CURR_OS="Linux"
            source "$HOME/.zshrc_for_linux"
            ;;
        windows)
            CURR_OS="Windows (Git Bash)"
            source "$HOME/.zshrc_for_windows"
            ;;
        *)
            CURR_OS="Unknown ($(uname))"
            ;;
    esac

    echo "Platform is ""$CURR_OS"". "
    echo "Here is on ""$SHELL"". And zshrc has loaded. "
}
