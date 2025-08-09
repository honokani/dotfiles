#!/usr/bin/bash
# install zsh (冪等性対応)
if ! command -v zsh &> /dev/null; then
    sudo apt update
    sudo apt install -y zsh curl
else
    echo "zsh is already installed"
fi

# change shell (現在のシェルがzshでない場合のみ)
if [[ "$SHELL" != "$(which zsh)" ]]; then
    sudo chsh -s $(which zsh) $USER
    echo "Shell changed to zsh. Please reboot and run initialize_ubuntu.2.sh"
else
    echo "Already using zsh"
fi

echo do_reboot!!
