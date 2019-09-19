#!/usr/bin/zsh

: "COMMON_DIRS" && {
    mkdir ~/ws
    mkdir ~/sandbox
}

: "USEFUL_APPS" && { 
    sudo apt install -y gawk tree w3m zip
}

: "TMUX" && { 
    sudo apt install -y tmux
    which tmux && { 
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

echo "done."
echo ""
echo "-- -- -- -- --"
echo "To install exa, see 'https://the.exa.website/'"
echo "To install stack, see 'https://docs.haskellstack.org/en/stable/README/'"
echo "-- -- -- -- --"

