#!/usr/bin/zsh
# make git clone directory
GC=$HOME/git_clones
dir $GC

# git must be installed.
# because, this file must be got from github.
# apply dotfiles
$GC/dotfiles/apply_dots.sh


# prepare to install python3, to use visual libraries.
sudo apt-get install -y gcc make openssl language-pack-ja
sudo apt-get install -y libssl-dev libbz2-dev libreadline-dev libsqlite3-dev
sudo apt-get install -y python3-tk tk-dev python-tk libfreetype6-dev 


# get pyenv, install pyenv-virtualenv
git clone https://github.com/pyenv/pyenv $GC/pyenv
ln -siv $GC/pyenv $HOME/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv $GC/pyenv-virtualenv
ln -siv $GC/pyenv-virtualenv $HOME/.pyenv/plugins/pyenv-virtualenv
# install python3
pyenv install 3.6.5
pyenv global 3.6.5
pip install --upgrade pip

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

pyenv virtualenv 3.6.5 neovim3
pyenv activate neovim3
pip install --upgrade pip
pip install neovim

