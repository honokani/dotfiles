: "UNIQUE_SETTING" && {
    : "UNIQUE_SETTING" && {
        zet() {
            vim -O ~/.zshrc_for_common ~/.zshrc \
                -c "wincmd l" \
                -c "args ~/.zshrc_for_linux" \
                -c "split ~/.zshrc"
        }
        : "uv" && {
            if type uv > /dev/null 2>&1; then
                _activate_uvenv () {
                    if [ -n "$VIRTUAL_ENV" ]; then
                        echo "already in venv: $VIRTUAL_ENV"
                        echo "run 'uvd' to deactivate first"
                        return 1
                    fi
                    if [ -f "./.venv/bin/activate" ]; then
                        . ./.venv/bin/activate
                    else
                        echo "no .venv/bin/activate in $(pwd)"
                        echo "run 'uvm [python_version]' to create one"
                        return 1
                    fi
                }
            fi
        }
    }
}

