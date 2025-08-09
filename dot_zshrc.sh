: "Call_zsh_core_for_each_OS" ; {
    . "$HOME/.zshrc_util"

    CURR_OS=""
    case "$(uname)" in
        Darwin)
            CURR_OS="Mac"
            . "$HOME/.zshrc_for_common"
            . "$HOME/.zshrc_for_mac"
            ;;
        Linux)
            if [[ -n "$WSL_DISTRO_NAME" ]] || \
               [[ -n "$WSL_INTEROP" ]] || \
               grep -qi microsoft /proc/version 2>/dev/null; then
                CURR_OS='WSL on Windows'
                . "$HOME/.zshrc_for_common"
                . "$HOME/.zshrc_for_wsl"
            else
                CURR_OS="Linux not WSL"
                . "$HOME/.zshrc_for_common"
            fi
            ;;
        MINGW32_NT*)
            CURR_OS="Windows 32bit"
            . "$HOME/.zshrc_for_windows"
            ;;
        MINGW64_NT*)
            CURR_OS="Windows 64bit"
            . "$HOME/.zshrc_for_windows"
            ;;
        *)
            . "$HOME/.zshrc_for_common"
            unique=""
            ;;
    esac

    if [ -z "$CURR_OS" ]; then
        echo "Platform is : ($(uname -a))"
    else
        echo "Platform is ""$CURR_OS"". "
    fi
    echo "Here is on ""$SHELL"". And zshrc has loaded. "
}

