: "UNIQUE_SETTING" && {
    : "PRE_CALLING_COMMON" && {
        MY_WORK_DIR="$HOME/ws"
        MY_GITCLONE_DIR="$HOME/git_clone"
    }
    : "CALLING_COMMON_SETTIG" && {
        . "$HOME/.zshrc_for_common"
    }
    : "UNIQUE_SETTING" && {
        _activate_pyenv
        zet() {
            vim -O ~/.zshrc_for_common ~/.zshrc \
                -c "wincmd l" \
                -c "args ~/.zshrc_for_linux" \
                -c "split ~/.zshrc"
        }
    }
}

