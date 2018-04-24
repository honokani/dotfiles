# install japanese
sudo apt-get install language-pack-ja

# install zsh
sudo apt-get install zsh
which zsh
# chsh
# restart pc

# install zplug
# see https://github.com/zplug/zplug
# $ curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh



# make git clone directory
GC=$HOME/gitclones
mkdir $GC

# git must be installed.
# because, this file must be got from github.
# $ sudo apt-get git
# $ git clone https://github.com/honokani/dotfiles $GC/dotfiles
# apply dotfiles
# $ $GC/dotfiles/apply_dotfiles.sh


# get pyenv, virtualenv.
git clone pyenv $GC/pyenv
git clone pyenv-virtualenv $GC/pyenv-virtualenv
ln -siv $GC/pyenv $HOME/.pyenv
ln -siv $GC/pyenv-virtualenv $HOME/.pyenv/plugins/pyenv-virtualenv

# prepare to install python3, to use visual libraries.
sudo apt-get install git gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev
sudo apt-get install python3-tk tk-dev python-tk libfreetype6-dev 

# install python3
pyenv install list
pyenv install 3.6.5
pyenv global 3.6.5
source $HOME/.zshrc
python -V

# make envs python2 and 3


