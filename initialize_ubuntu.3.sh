#!/usr/bin/zsh

: "COMMON_DIRS" && {
    mkdir "$HOME/ws"
    mkdir "$HOME/sandbox"
}

: "USEFUL_APPS" && { 
    sudo apt install -y gawk tree w3m zip ripgrep
    sudo apt install -y exuberant-ctags
    sudo apt install -y nodejs npm
    type npm && npm install -g yarn neovim && {
        echo ok
        #sudo apt remove -y npm
        #yarn global add neovim
    } || {
        NPM_G="$HOME/.npm_global"
        mkdir $NPM_G
        npm config set prefix $NPM_G
        export PATH="$NPM_G/bin:$PATH"
        npm install -g yarn neovim
        #yarn global add neovim
        #sudo apt remove -y npm
    }
    git config --global core.editor nvim
}

: "TMUX" && { 
    sudo apt install -y tmux
    type tmux > /dev/null && {
        TM_CONF=$HOME/.tmux.conf
        touch $TM_CONF
        echo "set-option -g default-shell $SHELL" > $TM_CONF
        echo "" >> $TM_CONF
        echo "set -g prefix C-q" >> $TM_CONF
        echo "" >> $TM_CONF
        echo "bind | split-window -h" >> $TM_CONF
        echo "bind - split-window -v" >> $TM_CONF
        echo "set-option -g base-index 1" >> $TM_CONF
        echo "set-option -g status-justify centre" >> $TM_CONF
        echo "" >> $TM_CONF
        echo "set-option -g default-terminal screen-256color" >> $TM_CONF
        echo "set -g terminal-overrides 'xterm:colors=256'" >> $TM_CONF
        echo 'set-option -g status-bg "colour238"' >> $TM_CONF
        echo 'set-option -g status-fg "colour255"' >> $TM_CONF
        echo "" >> $TM_CONF
        echo "bind h select-pane -L" >> $TM_CONF
        echo "bind j select-pane -D" >> $TM_CONF
        echo "bind k select-pane -U" >> $TM_CONF
        echo "bind l select-pane -R" >> $TM_CONF
        echo "bind -r H resize-pane -L 5" >> $TM_CONF
        echo "bind -r J resize-pane -D 5" >> $TM_CONF
        echo "bind -r K resize-pane -U 5" >> $TM_CONF
        echo "bind -r L resize-pane -R 5" >> $TM_CONF
        echo "" >> $TM_CONF
        echo "set-option -g mouse on" >> $TM_CONF
    }
}

: "with handle" && {
echo "-- -- -- -- --"
    type exa > /dev/null || {
        echo "To install exa, see 'https://the.exa.website/'"
    }
    type stack > /dev/null || {
        echo "To install stack, see 'https://docs.haskellstack.org/en/stable/README/'"
    }
    : "FontSetting" && {
        echo "To add font CICA, see 'https://github.com/miiton/Cica' and download file"
        echo "Then copy font to '~/.font/ , and order folloing command'"
        echo 'UUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \'"'"')'
        echo 'gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${UUID}/ font "Cica 15"'
    }
echo "-- -- -- -- --"
}

echo "done."
echo ""

