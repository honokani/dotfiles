# install zsh
# install zplug
# # see https://github.com/zplug/zplug
sudo apt install -y zsh
sudo apt install -y curl
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# change shell
# $ chsh
which zsh
sudo chsh -s $(which zsh) $USER

echo do_reboot!!

