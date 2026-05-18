# Readme for dotfiles  

### Purpose  
   *  make my life easy  
   *  learn to use github  

### Step

**Ubuntu / WSL**
   1. execute `initialize.1.sh`
   1. execute `initialize.2.sh`
   1. execute `initialize.3.sh`

**Windows (git bash 前提)**
   1. 事前準備: git bash で zsh 起動可
   1. execute `initialize.2.sh` (OS判定で Windows 用処理が走る: scoop installer + PowerShell uv installer + scoop vim + fzf git clone)

## Expected Error
   *  neovim  
      *  If you use Vim 7.4, use dein.vim ver.1.5 instead.  
         ```bash
         cd ~/.cache/nvim/dein/repos/github.com/Shougo/dein.vim/
         git checkout 1.5
         ```
   * zplug
     *  If logmessage say unknown error occored, install gawk.  

