#!/usr/bin/zsh
# make git clone directory
GC_NAME=$(pwd|awk -F/ '{print $(NF-1)}')
GC=$HOME/$GC_NAME
DF_NAME=$(pwd|awk -F/ '{print $(NF)}')
dir $GC

# git must be installed.
# because, this file must be got from github.
# apply dotfiles
$GC/$DF_NAME/apply_dots.sh


# prepare to install python3, to use visual libraries.
sudo apt install -y build-essential openssl language-pack-ja
sudo apt install -y libssl-dev libbz2-dev libreadline-dev libsqlite3-dev
sudo apt install -y python3-tk tk-dev python-tk
sudo apt install -y libfreetype6-dev zlib1g-dev


# get pyenv, install pyenv-virtualenv
git clone https://github.com/pyenv/pyenv $GC/pyenv
ln -siv $GC/pyenv $HOME/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv $GC/pyenv-virtualenv
ln -siv $GC/pyenv-virtualenv $HOME/.pyenv/plugins/pyenv-virtualenv

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
source ~/.zshrc

