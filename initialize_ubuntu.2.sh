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
sudo apt install -y python3-tk tk-dev python-tk libfreetype6-dev 


# get pyenv, install pyenv-virtualenv
git clone https://github.com/pyenv/pyenv $GC/pyenv
ln -siv $GC/pyenv $HOME/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv $GC/pyenv-virtualenv
ln -siv $GC/pyenv-virtualenv $HOME/.pyenv/plugins/pyenv-virtualenv

source $HOME/.zshrc

# install neovim
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install -y neovim

# make envs python2 and 3 for neovim
pyenv install 2.7.13
pyenv virtualenv 2.7.13 neovim2
pyenv activate neovim2
pip install --upgrade pip
pip install neovim

pyenv install 3.6.5
pyenv virtualenv 3.6.5 neovim3
pyenv activate neovim3
pip install --upgrade pip
pip install neovim

# install python3
pip install --upgrade pip
pyenv global 3.6.5
