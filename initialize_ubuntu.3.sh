# install neovim
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install -y neovim

eval "$(pyenv init -)"

# make envs python2 and 3 for neovim
pyenv install 2.7.15
pyenv virtualenv 2.7.15 neovim2
pyenv activate neovim2
pip install --upgrade pip
pip install neovim

pyenv install 3.9.5
pyenv virtualenv 3.9.5 neovim3
pyenv activate neovim3
pip install --upgrade pip
pip install neovim

# install python3
pip install --upgrade pip
pyenv global 3.9.5
