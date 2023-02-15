: "FLAGS_FOR_SETTING" && {
    if type fzf > /dev/null 2>&1; then
        MY_FLG_FZF=1
    fi
    if type git > /dev/null 2>&1; then
        MY_FLG_GIT=1
    fi
    if type exa > /dev/null 2>&1; then
        MY_FLG_EXA=1
    fi
}

: "COMMON_SETTING" && {
    : "Language" && {
        export LANGUAGE=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
        export LC_CTYPE=en_US.UTF-8
        export LANG=en_US.UTF-8
    }
    : "Zsh" && {
        setopt no_beep
        alias zrc="source ~/.zshrc"
        alias zet="vim -p ~/.zshrc_for_wsl ~/.zshrc"
        : "History" && {
            HISTCONTROL=erasedups
            export HISTSIZE=100000
            export SAVEHIST=100000
            setopt hist_ignore_dups
            setopt hist_ignore_all_dups
            setopt extended_history
            setopt hist_reduce_blanks
            setopt share_history
            if [ -v MY_FLG_FZF ]; then
                alias his="cat ~/.zsh_history| fzf "
            else
                alias his=history
            fi
        }
        : "Prompt" && {
            PROMPT='%F{cyan}%(!.#.$)%f '
        }
        : "Hook" && {
            precmd() {
                print "[ `date +%H:%M` | `pwd` `git_b_check` ]"
            }
            chpwd() {
                ll
            }
        }

    }
    : "Vim setting" && {
        alias vi=vim
        alias nv=vim
        alias vet="vim ~/.vimrc"
    }
    : "Basic Controll" && {
        alias ..="cd .."
        if [ -v MY_FLG_EXA ]; then
            ll () {
                if [ $# -eq 0 ]; then exa -l; else exa -l $1; fi
            }
            lll () {
                if [ $# -eq 0 ]; then exa -al; else exa -al $1; fi
            }
        else
            ll () {
                if [ $# -eq 0 ]; then ls -l; else ls -l $1; fi
            }
            lll () {
                if [ $# -eq 0 ]; then ls -al; else ls -al $1; fi
            }
        fi
        if [ -v MY_FLG_FZF ]; then
            cdd () {
                pname=$(find ~ -name "*" | fzf +m)
                [ -f $pname ] && {
                    cd ${pname%/*}
                } || {
                    cd $pname
                }
            }
        else
            cdd () {
                echo no_fzf_cdd
            }
        fi
        #alias cdd="cd -"
    }
}

: "GIT_SETTING" && {
    if [ -v MY_FLG_GIT ]; then
        git_b_check () {
            if [[ "%PWD" =~ '/\.git(/.*)?$' ]]; then
                return
            fi
            local bname pref suff
            bname=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
            if [[ -z $bname ]]; then
                pref=$'(\e[90;49m'
                bname="NotGit"
            else
                pref='( '`get_b_status`
            fi
            suff=$'\e[m )'
            echo "${pref}${bname}${suff}"
        }
        get_b_status () {
            local color bstate
            bstate=`git status --short 2> /dev/null`
            if [ -z "$bstate" ]; then
                color=$'\e[32;49m'
            elif [[ "$bstate" =~ "[\n]?\?\?" ]]; then
                color=$'\e[35;49m'
            elif [[ "$bstate" =~ "[\n]?\ M\ " ]]; then
                color=$'\e[31;49m'
            else
                color=$'\e[36;49m'
            fi
            echo ${color}
        }
    fi
}

: "PG_SETTING" && {
    : "Python" && {
        : "pyenv" && {
            if [ -d "$HOME/.pyenv" ]; then
                export PYENV_ROOT="$HOME/.pyenv"
                export PATH="$PYENV_ROOT/bin:$PATH"
                if command -v pyenv 1>/dev/null 2>&1; then
                    eval "$(pyenv init --path)"
                    eval "$(pyenv init -)"
                fi
                eval "$(pyenv virtualenv-init -)"
                alias pyel="pyenv virtualenvs"
                alias pyea="pyenv activate "
                alias pyed="pyenv deactivate "
            fi
        }
    }
    : "Haskell" && {
        [ -f "/Users/shoto.miki/.ghcup/env" ] && {
            source "/Users/shoto.miki/.ghcup/env" # ghcup-env
            alias -s hs="stack runghc "
        }
    }
}

: "APPLICATION_SETTING" && {
    : "fzf" && {
        if [ -v MY_FLG_FZF ]; then
            [ -f ~/.fzf.bash ] && source ~/.fzf.bash
            export ENHANCD_FILTER=fzf
            export ENHANCD_HOOK_AFTER_CD=chpwd
        fi
    }
}
