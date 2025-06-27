: "PRESETTING" && {
    if [ -z "$MY_WORK_DIR" ]; then
        if [ -z "$1" ]; then
            MY_WORK_DIR="$HOME/ws"
        fi
    fi
    if [ -z "$MY_GITCLONE_DIR" ]; then
        if [ -z "$2" ]; then
            MY_GITCLONE_DIR="$HOME/git_clone"
        fi
    fi
}

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

# for c in {0..255}; do print -P "%F{$c}Color $c%f"; done

: "COMMON_SETTING" && {
    : "Language" && {
        export LANGUAGE=ja_JP.UTF-8
        export LC_ALL=ja_JP.UTF-8
        export LC_CTYPE=ja_JP.UTF-8
        export LANG=ja_JP.UTF-8
    }
    : "Zsh" && {
        setopt no_beep
        alias zrc="source ~/.zshrc"
        : "History" && {
            export HISTFILE=${HOME}/.zsh_history
            touch "$HISTFILE"
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

    }
    : "Vim setting" && {
        alias vi=vim
        alias nv=vim
        alias vet="vim ~/.vimrc"
    }
    : "Basic Controll" && {
        alias ..="cd .."
        if [ -v MY_FLG_EXA ]; then
            _lsl () {
                if [ $# -eq 0 ]; then exa -l; else exa -l $1; fi
            }
            _lsla() {
                if [ $# -eq 0 ]; then exa -la; else exa -la $1; fi
            }
        else
            _lsl () {
                if [ $# -eq 0 ]; then ls -l; else ls -l $1; fi
            }
            _lsla () {
                if [ $# -eq 0 ]; then ls -la|grep -v '\.$'; else ls -la $1|grep -v '\.$'; fi
            }
            _lsld () {
                if [ $# -eq 0 ]; then
                    print -rl -- .[^.]* .??* | sort -u | xargs ls -ld;
                else 
                    print -rl -- $1/.[^.]* $1/.??* | sort -u | xargs ls -ld;
                fi
            }
        fi
        alias ll=_lsl
        alias lll=_lsla
        alias lld=_lsld
        if [ -v MY_FLG_FZF ]; then
            _find_old_cd () {
                pname=$(find ~ -name "*" | fzf +m)
                [ -f $pname ] && {
                    cd ${pname%/*}
                } || {
                    cd $pname
                }
            }
        else
            _find_old_cd () {
                echo no_fzf
            }
        fi
        _cd_my_workdir() {
            mkdir -p "$MY_WORK_DIR"
            cd "$MY_WORK_DIR"
        }
        _cd_my_gitclone() {
            mkdir -p "$MY_GITCLONE_DIR"
            cd "$MY_GITCLONE_DIR"
        }
        _cd_my_dotfiles() {
            _cd_my_gitclone
            mkdir -p "dotfiles"
            cd "dotfiles"
        }
        alias cdd=_find_old_cd
        alias cdw=_cd_my_workdir
        alias cdg=_cd_my_gitclone
        alias cdgd=_cd_my_dotfiles

        alias mkbdnv="nv $HOME/mtk/qmk_firmware/keyboards/mtk/mtk64e/keymaps/via_mykey"
        alias mkbdcd="cd $HOME/qmk/"
        alias mkbdmk="make -j8 SKIP_GIT=yes mtk/mtk64e:via_mykey"
    }
    : "Hook" && {
        MY_PRECMD_C_CYAN=$'\e[36m'
        MY_PRECMD_C_RESET=$'\e[0m'
        precmd() {
            print "[ `date +%H:%M` | ${MY_PRECMD_C_CYAN}`pwd`${MY_PRECMD_C_RESET} `_git_b_check` ]"
        }
        chpwd() {
            _lsl
        }
    }
}

: "GIT_SETTING" && {
    if [ -v MY_FLG_GIT ]; then
        _git_b_check () {
            if [[ "%PWD" =~ '/\.git(/.*)?$' ]]; then
                return
            fi
            local bname pref suff
            bname=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
            if [[ -z $bname ]]; then
                pref=$'( \e[90;49m'
                bname="NotGit"
            else
                pref='( '`_git_b_status`
            fi
            suff=$'\e[m )'
            echo "${pref}${bname}${suff}"
        }

        _git_b_status () {
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

        _git_b_switch () {
            # gitリポジトリかどうかを事前チェック
            local git_status=$(_git_b_check)
            if [[ "$git_status" =~ "NotGit" ]]; then
                print "gitリポジトリではありません。" >&2
                return 1
            fi

            # git fetch origin (オフライン時など失敗しても継続)
            git fetch origin 2>/dev/null

            # ローカルとリモートブランチのリストを取得
            local -a branches=()
            local -a branches_with_explains=()
            local branch_list=$(git branch -a --format='%(refname:short)' | grep -v HEAD | sort -u)

            while IFS= read -r line; do
                if [[ -n "$line" ]]; then
                    # origin/で始まるリモートブランチの場合の処理
                    if [[ "$line" =~ ^origin/(.+)$ ]]; then
                        local branch_name="${line#origin/}"
                        # ローカルブランチに同名のものがない場合のみ追加
                        if ! git show-ref --verify --quiet refs/heads/"$branch_name"; then
                            branches+=("$branch_name")
                            branches_with_explains+=("$branch_name:リモート")
                        fi
                    else
                        # ローカルブランチを追加
                        branches+=("$line")
                        branches_with_explains+=("$line:ローカル")
                    fi
                fi
            done <<< "$branch_list"

            # ソート（説明付きも同じ順序でソート）
            local -a sorted_indices=($(for i in {1..${#branches}}; do echo "$i:${branches[$i]}"; done | sort -t: -k2 | cut -d: -f1))
            local -a sorted_branches=()
            local -a sorted_explains=()
            for idx in "${sorted_indices[@]}"; do
                sorted_branches+=("${branches[$idx]}")
                sorted_explains+=("${branches_with_explains[$idx]}")
            done
            branches=("${sorted_branches[@]}")
            branches_with_explains=("${sorted_explains[@]}")

            if [[ ${#branches} -eq 0 ]]; then
                print "ブランチが見つかりませんでした。" >&2
                return 1
            fi

            # ブランチを選択
            local selected_branch=$(select_1_item branches branches_with_explains)

            if [[ -n "$selected_branch" ]]; then
                git switch "$selected_branch"

                if [[ $? -ne 0 ]]; then
                    print "ブランチの切り替えに失敗しました。" >&2
                    return 1
                fi
            else
                print "ブランチが選択されませんでした。" >&2
                return 1
            fi
        }

        _git_commit () {
            # gitリポジトリかどうかを事前チェック
            local git_status=$(_git_b_check)
            if [[ "$git_status" =~ "NotGit" ]]; then
                print "gitリポジトリではありません。" >&2
                return 1
            fi
            
            # 現在のブランチ名を取得
            local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
            if [[ -z "$current_branch" ]]; then
                print "ブランチ名を取得できませんでした。" >&2
                return 1
            fi
            
            # コミット対象があるかチェック
            if ! git diff --cached --quiet; then
                : # ステージされた変更がある
            elif ! git diff --quiet; then
                print "ステージされた変更がありません。git add を実行してください。" >&2
                git status
                return 1
            else
                print "コミットする変更がありません。" >&2
                return 1
            fi
            
            print "commiting -> $current_branch"
            
            # コミットメッセージを入力
            print -n "コミットメッセージを入力してください: "
            local commit_message
            read "commit_message"
            
            if [[ -z "$commit_message" ]]; then
                print "コミットメッセージが入力されませんでした。" >&2
                return 1
            fi
            
            # 接頭辞チェック（10文字以下の単語+コロン+スペース）
            if [[ ! "$commit_message" =~ ^[a-zA-Z]{1,10}:[[:space:]] ]]; then
                print "接頭辞が付いていません。"
                
                # 接頭辞リスト
                local -a prefixes=("feat:" "fix:" "doc:" "refactor:")
                
                print "どれか付与しますか？"
                local selected_prefix=$(select_1_item prefixes)
                
                if [[ -n "$selected_prefix" ]]; then
                    # 接頭辞を付与
                    commit_message="${selected_prefix} ${commit_message}"
                else
                    # キャンセル確認
                    print -n "キャンセルしますか？ (y/n): "
                    local cancel_choice
                    read "cancel_choice"
                    
                    if [[ "$cancel_choice" == "y" || "$cancel_choice" == "Y" ]]; then
                        print "コミットをキャンセルしました。"
                        return 1
                    elif [[ "$cancel_choice" == "n" || "$cancel_choice" == "N" ]]; then
                        # 接頭辞なしで続行
                        :
                    else
                        print "無効な選択です。コミットをキャンセルします。"
                        return 1
                    fi
                fi
            fi
            
            # コミット実行
            git commit -m "$commit_message"
            
            if [[ $? -eq 0 ]]; then
                print "コミットが完了しました。"
            else
                print "コミットに失敗しました。" >&2
                return 1
            fi
        }       

        _git_add () {
            # gitリポジトリかどうかを事前チェック
            local git_status=$(_git_b_check)
            if [[ "$git_status" =~ "NotGit" ]]; then
                print "gitリポジトリではありません。" >&2
                return 1
            fi
            
            # git statusの結果を取得
            local status_output=$(git status --porcelain)
            
            if [[ -z "$status_output" ]]; then
                print "追加可能なファイルがありません。" >&2
                return 0
            fi
            
            # notStaged・Untrackedファイルのリストを作成
            local -a target_files=()
            local -a files_with_explains=()
            
            while IFS= read -r line; do
                if [[ -n "$line" ]]; then
                    local status_code="${line:0:2}"
                    local filename="${line:3}"
                    
                    # notStaged (修正済み未ステージ) または Untracked をチェック
                    if [[ "$status_code" == " M" ]] || [[ "$status_code" == " D" ]] || [[ "$status_code" == " T" ]]; then
                        # 2文字目がM/D/T = notStaged
                        target_files+=("$filename")
                        files_with_explains+=("$filename:notStaged")
                    elif [[ "$status_code" == "??" ]]; then
                        # Untracked
                        target_files+=("$filename")
                        files_with_explains+=("$filename:Untracked")
                    fi
                fi
            done <<< "$status_output"
            
            if [[ ${#target_files} -eq 0 ]]; then
                print "追加可能なファイルがありません。" >&2
                return 0
            fi
            
            local -a selected_files=($(select_items_at_once ${#target_files} target_files files_with_explains))
            
            if [[ ${#selected_files} -gt 0 ]]; then
                for file in "${selected_files[@]}"; do
                    print "  $file" >&2
                done
                
                # git add実行
                git add "${selected_files[@]}"
                
                if [[ $? -eq 0 ]]; then
                    print "git add: done."
                    git status
                else
                    print "git add: failed." >&2
                    return 1
                fi
            else
                print "ファイルが選択されませんでした。"
            fi
        }

        alias gisw=_git_b_switch
        alias gicm=_git_commit
        alias giad=_git_add
        alias gist="git status"

    fi
}

: "PG_SETTING" && {
    : "Python" && {
        : "pyenv" && {
            # this function was called in each setting if necessary.
            _activate_pyenv () {
                if [ -d "$HOME/.pyenv" ]; then
                    export PYENV_ROOT="$HOME/.pyenv"
                    export PATH="$PYENV_ROOT/bin:$PATH"
                    if command -v pyenv 1>/dev/null 2>&1; then
                        eval "$(pyenv init --path)"
                        eval "$(pyenv init -)"
                    fi
                    eval "$(pyenv virtualenv-init -)"
                    alias pyem="pyenv virtualenv " # arg: version, env_name
                    alias pyel="pyenv virtualenvs"
                    alias pyea="pyenv activate "
                    alias pyed="pyenv deactivate "
                fi
            }
            _run_env_win () {
                if [ $# -eq 0 ]; then
                    echo "need env name"
                else
                    source "./""$1""/Scripts/activate"
                fi
            }
            _activate_pyenv_win () {
                if [ -d "$HOME/.pyenv" ]; then
                    alias pyem=create_python_venv
                    alias pyea=_run_env_win
                    alias pyed="deactivate "
                    
                fi
            }
        }
    }
    : "cuda" && {
        export PATH="/usr/local/cuda/bin:$PATH"
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
