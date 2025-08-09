: "UNIQUE_SETTING" && {
    : "UNIQUE_SETTING" && {
        _activate_pyenv
        zet() {
            vim -O ~/.zshrc_for_common ~/.zshrc \
                -c "wincmd l" \
                -c "args ~/.zshrc_for_mac" \
                -c "split ~/.zshrc"
        }
    }
}

