: "UNIQUE_SETTING" && {
    : "UNIQUE_SETTING" && {
        zet() {
            vim -O ~/.zshrc_for_common ~/.zshrc \
                -c "wincmd l" \
                -c "args ~/.zshrc_for_wsl" \
                -c "split ~/.zshrc"
        }
    }
}

