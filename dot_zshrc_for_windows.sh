#!/bin/zsh

: "UNIQUE_SETTING" && {
    : "PRE_CALLING_COMMON" && {
        MY_WORK_DIR="/c/ws"
        MY_GITCLONE_DIR="/c/git_clone"
    }
    : "CALLING_COMMON_SETTIG" && {
        . "$HOME/.zshrc_for_common"
    }
    : "UNIQUE_SETTING" && {
        if [ -e "$HOME/scoop/shims/vim.exe" ]; then
            alias vim="$HOME/scoop/shims/vim.exe"
        fi

        zet() {
            vim -O ~/.zshrc_for_common ~/.zshrc \
                -c "wincmd l" \
                -c "args ~/.zshrc_for_windows" \
                -c "split ~/.zshrc"
        }

        _activate_pyenv_win

        : "wsl2 setting" && {
            # CSVファイルパス
            WSL_BACKUP_DIR="$HOME/wsl_backups"
            WSL_BACKUP_CSV="$WSL_BACKUP_DIR/backup_records.csv"
        }

        : "wsl2 distro control" && {
            _parse_wsl_distributions_clean() {
                local wsl_output=$1
                local -a distributions=()
                local -a distributions_with_explains=()
                
                # echo "=== 制御文字除去版デバッグ ===" >&2
                
                # 制御文字を除去して処理
                local cleaned_output=$(echo "$wsl_output" | tr -d '\r' | sed 's/[[:cntrl:]]//g' | sed 's/▒[0-9]*//g')
                
                # echo "クリーンアップ後:" >&2
                # echo "$cleaned_output" >&2
                # echo "==================" >&2
                
                while IFS= read -r line; do
                    # 空行スキップ
                    if [[ -z "${line// /}" ]]; then
                        continue
                    fi
                    
                    # NAMEヘッダーをスキップ
                    if [[ "$line" =~ NAME.*FRIENDLY ]]; then
                        continue
                    fi
                    
                    # wsl.exeを含む行をスキップ
                    if [[ "$line" =~ wsl\.exe ]]; then
                        continue
                    fi
                    
                    # 先頭が英字の行のみ処理
                    local trimmed="${line#"${line%%[! ]*}"}"  # 先頭空白削除
                    local first_char="${trimmed:0:1}"
                    
                    # echo "処理中: [$trimmed] 先頭文字: [$first_char]" >&2
                    
                    if [[ "$first_char" =~ [A-Za-z] ]]; then
                        local distro=$(echo "$trimmed" | awk '{print $1}')
                        local description=$(echo "$trimmed" | awk '{$1=""; print substr($0,2)}')
                        
                        # echo "  -> 追加: distro=[$distro] desc=[$description]" >&2
                        
                        distributions+=("$distro")
                        distributions_with_explains+=("${distro}:${description}")
                    fi
                done <<< "$cleaned_output"
                
                # echo "=== 最終結果 ===" >&2
                # echo "distributions数: ${#distributions}" >&2
                # echo "distributions: ${distributions[@]}" >&2
                
                WSL_ALLDISTRIBUTIONS=("${distributions[@]}")
                WSL_ALLDISTRIBUTIONS_WITH_EXPLAINS=("${distributions_with_explains[@]}")
            }

            test_wsl_parse_clean() {
                local wsl_output=$(wsl --list --online)
                _parse_wsl_distributions_clean "$wsl_output"
            }

            _wsl_select_distribution() {
                # wsl --list --online の実行結果を取得
                local wsl_output=$(wsl --list --online)
                
                # ディストリビューションと説明を解析（修正版を使用）
                _parse_wsl_distributions_clean "$wsl_output"
                
                # echo "解析結果確認:" >&2
                # echo "WSL_ALLDISTRIBUTIONS数: ${#WSL_ALLDISTRIBUTIONS}" >&2
                # echo "WSL_ALLDISTRIBUTIONS: ${WSL_ALLDISTRIBUTIONS[@]}" >&2
                # echo "WSL_ALLDISTRIBUTIONS_WITH_EXPLAINS: ${WSL_ALLDISTRIBUTIONS_WITH_EXPLAINS[@]}" >&2
                
                # ユーザーに選択を促す
                if [[ ${#WSL_ALLDISTRIBUTIONS} -eq 0 ]]; then
                    print -r -- "利用可能なディストリビューションが見つかりませんでした" >&2
                    return 1
                fi
                
                local selected_distro=$(select_1_item WSL_ALLDISTRIBUTIONS WSL_ALLDISTRIBUTIONS_WITH_EXPLAINS)
                
                # 選択結果を返す
                if [[ -n "$selected_distro" ]]; then
                    print "$selected_distro"
                else
                    print -r -- "ディストリビューションが選択されませんでした" >&2
                fi
            }

            # 最終的な関数も修正
            _wsl_create_environment() {
                # 利用可能なディストリビューションを確認
                local wsl_output=$(wsl --list --online)
                _parse_wsl_distributions_clean "$wsl_output"
                
                if [[ ${#WSL_ALLDISTRIBUTIONS} -eq 0 ]]; then
                    print -r -- "利用可能なディストリビューションが見つかりませんでした"
                    return 1
                fi
                
                # バックアップディレクトリの初期化
                _init_wsl_backup
                
                # 既存のinitファイルを確認
                local -a init_available=()
                local -a no_init_available=()
                local -a init_available_with_explains=()
                local -a no_init_available_with_explains=()
                
                for i in {1..${#WSL_ALLDISTRIBUTIONS}}; do
                    local distro="${WSL_ALLDISTRIBUTIONS[$i]}"
                    local explain="${WSL_ALLDISTRIBUTIONS_WITH_EXPLAINS[$i]}"
                    
                    # 空のエントリはスキップ
                    if [[ -z "$distro" ]]; then
                        continue
                    fi
                    
                    local init_file="${WSL_BACKUP_DIR}/${distro}-init.tar"
                    
                    if [[ -f "$init_file" ]]; then
                        local size=$(du -h "$init_file" | cut -f1)
                        init_available+=("$distro")
                        init_available_with_explains+=("${explain} [init: ${size}]")
                    else
                        no_init_available+=("$distro")
                        no_init_available_with_explains+=("${explain}")
                    fi
                done
                
                # すべてのディストリビューションを統合
                local -a all_distros=()
                local -a all_distros_with_explains=()
                
                for distro in "${init_available[@]}"; do
                    if [[ -n "$distro" ]]; then
                        all_distros+=("$distro")
                    fi
                done
                
                for explain in "${init_available_with_explains[@]}"; do
                    if [[ -n "$explain" ]]; then
                        all_distros_with_explains+=("$explain")
                    fi
                done
                
                for distro in "${no_init_available[@]}"; do
                    if [[ -n "$distro" ]]; then
                        all_distros+=("$distro")
                    fi
                done
                
                for explain in "${no_init_available_with_explains[@]}"; do
                    if [[ -n "$explain" ]]; then
                        all_distros_with_explains+=("$explain")
                    fi
                done
                
                # ディストリビューション選択
                print -r -- "ディストリビューションを選択してください:"
                local selected_distro=$(select_1_item all_distros all_distros_with_explains)
                
                if [[ -z "$selected_distro" ]]; then
                    return 1
                fi
                
                # 選択したディストリビューションのinitファイルの存在確認
                local init_file="${WSL_BACKUP_DIR}/${selected_distro}-init.tar"
                
                if [[ -f "$init_file" ]]; then
                    # initファイルがある場合 → 複製処理
                    _wsl_create_from_init "$selected_distro" "$init_file"
                else
                    # initファイルがない場合 → 新規インストール
                    _wsl_install_and_save_init "$selected_distro"
                fi
            }
            
            # initファイルから環境作成
            _wsl_create_from_init() {
                local distro_name=$1
                local init_file=$2
                
                print -r -- "新しい環境名を入力してください:"
                local new_env_name
                read "new_env_name"
                
                if [[ -z "$new_env_name" ]]; then
                    local timestamp=$(date "+%Y%m%d-%H%M%S")
                    new_env_name="${distro_name}-${timestamp}"
                fi
                
                # 名前の重複チェック
                if wsl --list --quiet 2>/dev/null | grep -q "^${new_env_name}$"; then
                    print -r -- "環境名「${new_env_name}」は既に存在します"
                    return 1
                fi
                
                # デフォルトのインストール先を使用
                local install_path="$HOME/AppData/Local/WSL/${new_env_name}"
                mkdir -p "$install_path"
                
                wsl --import "$new_env_name" "$install_path" "$init_file"
                
                if [[ $? -eq 0 ]]; then
                    print -r -- "環境作成完了: ${new_env_name}"
                else
                    print -r -- "インポートに失敗しました"
                    return 1
                fi
            }
            
            # 新規インストールしてinitとして保存
            _wsl_install_and_save_init() {
                local selected_distro=$1
                
                # 既にインストールされているかチェック（実際のWSL環境リストから）
                local installed_distros_before=$(wsl --list --quiet 2>/dev/null | tr -d '\r' | sed 's/[[:cntrl:]]//g')
                
                # インストール実行
                print -r -- ""
                print -r -- "=========================================="
                print -r -- "重要: 初期設定画面での手順"
                print -r -- "=========================================="
                print -r -- "1. 一度ベース環境を作成"
                print -r -- "2.  | ユーザー名とパスワードを設定"
                print -r -- "3.  | sudo apt update, sudo apt upgrade"
                print -r -- "4.  | ***** 必ず exit でWSLから抜ける *****"
                print -r -- "5.  | WSLから抜けた後、自動的に処理が続行されます"
                print -r -- "6. ベース環境を保存し削除"
                print -r -- "7. 保存したベース環境をクローンし、新環境を作成"
                print -r -- "=========================================="
                print -r -- ""
                print -r -- "「${selected_distro}」をインストールしています..."
                
                # インストール（自動的に初期設定画面に入る）
                wsl --install -d "$selected_distro"
                
                if [[ $? -eq 0 ]]; then
                    # インストール後の環境リストを取得
                    local installed_distros_after=$(wsl --list --quiet 2>/dev/null | tr -d '\r' | sed 's/[[:cntrl:]]//g')
                    local actual_name=""
                    
                    # 新しく追加された環境名を探す
                    while IFS= read -r distro; do
                        # 空行とdocker-desktopをスキップ
                        [[ -z "$distro" ]] && continue
                        [[ "$distro" == "docker-desktop" ]] && continue
                        
                        if ! echo "$installed_distros_before" | grep -q "^${distro}$"; then
                            actual_name="$distro"
                            break
                        fi
                    done <<< "$installed_distros_after"
                    
                    # 見つからない場合は選択した名前を使用
                    if [[ -z "$actual_name" ]]; then
                        actual_name="$selected_distro"
                    fi
                    
                    print -r -- ""
                    print -r -- "インストール完了: ${actual_name} : 処理が続行されます"
                    print -r -- "ベースをテンプレートとして保存しています..."
                    _save_as_init "$actual_name"
                    
                    if [[ $? -eq 0 ]]; then
                        # 元の環境を削除
                        print -r -- "ベース環境「${actual_name}」を削除しています..."
                        wsl --unregister "$actual_name" 2>/dev/null
                        
                        # 環境名を入力してインポート
                        print -r -- ""
                        print -r -- "新しい環境名を入力してください:"
                        local env_name
                        read "env_name"
                        
                        if [[ -z "$env_name" ]]; then
                            env_name="${actual_name}-$(date +%Y%m%d-%H%M%S)"
                        fi
                        
                        # initファイルから新しい環境を作成
                        local init_file="${WSL_BACKUP_DIR}/${actual_name}-init.tar"
                        local install_path="$HOME/AppData/Local/WSL/${env_name}"
                        mkdir -p "$install_path"
                        
                        print -r -- "「${env_name}」として環境を作成しています..."
                        wsl --import "$env_name" "$install_path" "$init_file"
                        
                        if [[ $? -eq 0 ]]; then
                            print -r -- "環境作成完了: ${env_name}"
                        else
                            print -r -- "環境の作成に失敗しました"
                            return 1
                        fi
                    else
                        print -r -- "初期テンプレートの保存に失敗しました"
                        return 1
                    fi
                else
                    print -r -- "インストールに失敗しました"
                    return 1
                fi
            }
            
            # 初期テンプレートとして保存
            _save_as_init() {
                local source_env=$1
                
                if [[ -z "$source_env" ]]; then
                    print -r -- "保存するWSL環境を選択してください:"
                    source_env=$(_wsl_select_one_distribution)
                    
                    if [[ -z "$source_env" ]]; then
                        return 1
                    fi
                fi
                
                _init_wsl_backup
                
                local init_file="${WSL_BACKUP_DIR}/${source_env}-init.tar"
                
                wsl --export "$source_env" "$init_file"
                
                if [[ $? -eq 0 ]]; then
                    _add_backup_record "${source_env}-init.tar" "[INIT] ${source_env}の初期テンプレート"
                    print -r -- "初期テンプレート保存完了: ${source_env}-init.tar"
                else
                    print -r -- "初期テンプレートの保存に失敗しました"
                    return 1
                fi
            }

            # 起動中WSL環境の解析関数
            _parse_running_wsl() {
                local wsl_output=$1
                local -a running_distributions=()
                local -a running_distributions_with_explains=()

                while IFS= read -r line; do
                    # 制御文字を除去
                    local cleaned_line=$(echo "$line" | tr -d '\r' | sed 's/[[:cntrl:]]//g' | sed 's/▒[0-9]*//g')

                    # 先頭空白除去
                    local trimmed="${cleaned_line#"${cleaned_line%%[! ]*}"}"
                    trimmed="${trimmed#\*}"  # 先頭の*を除去
                    trimmed="${trimmed#"${trimmed%%[! ]*}"}"  # 再度空白除去

                    # Running状態の行のみ処理
                    if [[ "$trimmed" =~ Running ]]; then
                        # ディストリビューション名を抽出（最初の単語）
                        local distro=$(echo "$trimmed" | awk '{print $1}')
                        if [[ -n "$distro" && "$distro" != "NAME" ]]; then
                            running_distributions+=("$distro")
                            running_distributions_with_explains+=("${distro}:Running")
                        fi
                    fi
                done <<< "$wsl_output"

                # グローバル変数に結果を格納
                WSL_RUNNING_DISTRIBUTIONS=("${running_distributions[@]}")
                WSL_RUNNING_DISTRIBUTIONS_WITH_EXPLAINS=("${running_distributions_with_explains[@]}")
            }

            # 起動中WSL環境選択関数
            _wsl_select_running_distributions() {
                local wsl_output=$(wsl --list --verbose)

                # 起動中ディストリビューションを解析
                _parse_running_wsl "$wsl_output"

                if [[ ${#WSL_RUNNING_DISTRIBUTIONS} -eq 0 ]]; then
                    print -r -- "起動中のWSL環境が見つかりませんでした" >&2
                    return 1
                fi

                print -r -- "停止するWSL環境を選択してください（複数選択可能）:" >&2

                # 複数選択（最大で起動中の全部まで選択可能）
                local -a selected_distros=($(select_items_stepwise ${#WSL_RUNNING_DISTRIBUTIONS} WSL_RUNNING_DISTRIBUTIONS WSL_RUNNING_DISTRIBUTIONS_WITH_EXPLAINS))

                # 選択結果を返す
                if [[ ${#selected_distros} -gt 0 ]]; then
                    print -l "${selected_distros[@]}"
                else
                    print -r -- "WSL環境が選択されませんでした" >&2
                    return 1
                fi
            }

            # WSL環境停止関数（複数対応）
            _wsl_stop() {
                # 停止対象を選択
                local -a selected_distros=($(_wsl_select_running_distributions))

                if [[ ${#selected_distros} -eq 0 ]]; then
                    print -r -- "停止する環境が選択されませんでした。処理を中止します。"
                    return 1
                fi

                # 選択された環境を順次停止
                for distro in "${selected_distros[@]}"; do
                    print -r -- "WSL環境「$distro」を停止しています..."
                    wsl --terminate "$distro"

                    if [[ $? -eq 0 ]]; then
                        print -r -- "「$distro」を正常に停止しました。"
                    else
                        print -r -- "「$distro」の停止に失敗しました。"
                    fi
                done

                print -r -- "停止処理が完了しました。"
            }

            _parse_all_wsl() {
                local wsl_output=$1
                local -a all_distributions=()
                local -a all_distributions_with_explains=()
                
                while IFS= read -r line; do
                    # 制御文字を除去
                    local cleaned_line=$(echo "$line" | tr -d '\r' | sed 's/[[:cntrl:]]//g' | sed 's/▒[0-9]*//g')
                    
                    # 先頭空白除去と*除去
                    local trimmed="${cleaned_line#"${cleaned_line%%[! ]*}"}"
                    trimmed="${trimmed#\*}"  # 先頭の*を除去
                    trimmed="${trimmed#"${trimmed%%[! ]*}"}"  # 再度空白除去
                    
                    # NAMEヘッダーをスキップ
                    if [[ "$trimmed" =~ ^NAME ]] || [[ -z "$trimmed" ]]; then
                        continue
                    fi
                    
                    # ディストリビューション名と状態を抽出
                    local distro=$(echo "$trimmed" | awk '{print $1}')
                    local state=$(echo "$trimmed" | awk '{print $2}')
                    
                    if [[ -n "$distro" && -n "$state" ]]; then
                        all_distributions+=("$distro")
                        all_distributions_with_explains+=("${distro}:${state}")
                    fi
                done <<< "$wsl_output"
                
                # グローバル変数に結果を格納
                WSL_ALL_DISTRIBUTIONS=("${all_distributions[@]}")
                WSL_ALL_DISTRIBUTIONS_WITH_EXPLAINS=("${all_distributions_with_explains[@]}")
            }

            # WSL環境選択関数（1つだけ選択）
            _wsl_select_one_distribution() {
                local wsl_output=$(wsl --list --verbose)
                _parse_all_wsl "$wsl_output"

                if [[ ${#WSL_ALL_DISTRIBUTIONS} -eq 0 ]]; then
                    print -r -- "WSL環境が見つかりませんでした" >&2
                    return 1
                fi

                print -r -- "接続するWSL環境を選択してください:" >&2

                # 1つだけ選択
                local selected_distro=$(select_1_item WSL_ALL_DISTRIBUTIONS WSL_ALL_DISTRIBUTIONS_WITH_EXPLAINS)

                if [[ -n "$selected_distro" ]]; then
                    print "$selected_distro"
                else
                    print -r -- "WSL環境が選択されませんでした" >&2
                    return 1
                fi
            }

            # 修正版：WSL環境に入る
            _wsl_activate() {
                if [ $# -eq 0 ]; then
                    # 引数なしの場合は選択式
                    local selected_distro=$(_wsl_select_one_distribution)

                    if [[ -z "$selected_distro" ]]; then
                        print -r -- "WSL環境が選択されませんでした。処理を中止します。"
                        return 1
                    fi

                    print -r -- "WSL環境「$selected_distro」に接続しています..."
                    wsl -d "$selected_distro"
                else
                    # 引数ありの場合は従来通り
                    wsl -d "$1"
                fi
            }

            

            # バックアップディレクトリとCSVの初期化
            _init_wsl_backup() {
                if [[ ! -d "$WSL_BACKUP_DIR" ]]; then
                    mkdir -p "$WSL_BACKUP_DIR"
                    print -r -- "バックアップディレクトリを作成しました: $WSL_BACKUP_DIR"
                fi

                if [[ ! -f "$WSL_BACKUP_CSV" ]]; then
                    echo "filename,message" > "$WSL_BACKUP_CSV"
                    print -r -- "バックアップ記録ファイルを作成しました: $WSL_BACKUP_CSV"
                fi
            }

            # CSVに記録を追加
            _add_backup_record() {
                local filename=$1
                local message=$2

                # CSVエスケープ（メッセージ内のカンマ対応）
                local escaped_message=$(echo "$message" | sed 's/"/\\"/g')
                if [[ "$escaped_message" =~ , ]]; then
                    escaped_message="\"$escaped_message\""
                fi

                echo "$filename,$escaped_message" >> "$WSL_BACKUP_CSV"
            }

            # CSVからバックアップファイル一覧を読み込み
            _load_backup_files() {
                local -a backup_files=()
                local -a backup_files_with_explains=()

                if [[ ! -f "$WSL_BACKUP_CSV" ]]; then
                    WSL_BACKUP_FILES=()
                    WSL_BACKUP_FILES_WITH_EXPLAINS=()
                    return 1
                fi

                # CSVを読み込み（ヘッダー行をスキップ）
                local line_num=0
                while IFS=',' read -r filename message; do
                    ((line_num++))

                    # ヘッダー行をスキップ
                    if [[ $line_num -eq 1 ]]; then
                        continue
                    fi

                    # ファイルが実際に存在するかチェック
                    if [[ -f "$WSL_BACKUP_DIR/$filename" ]]; then
                        backup_files+=("$filename")
                        # クォートを除去
                        local clean_message=$(echo "$message" | sed 's/^"//; s/"$//')
                        backup_files_with_explains+=("${filename}:${clean_message}")
                    fi
                done < "$WSL_BACKUP_CSV"

                WSL_BACKUP_FILES=("${backup_files[@]}")
                WSL_BACKUP_FILES_WITH_EXPLAINS=("${backup_files_with_explains[@]}")
            }

            # バックアップファイル選択
            _select_backup_file() {
                _load_backup_files

                if [[ ${#WSL_BACKUP_FILES} -eq 0 ]]; then
                    print -r -- "バックアップファイルが見つかりませんでした" >&2
                    return 1
                fi

                print -r -- "インポートするバックアップファイルを選択してください:" >&2
                local selected_file=$(select_1_item WSL_BACKUP_FILES WSL_BACKUP_FILES_WITH_EXPLAINS)

                if [[ -n "$selected_file" ]]; then
                    print "$selected_file"
                else
                    print -r -- "バックアップファイルが選択されませんでした" >&2
                    return 1
                fi
            }

            # WSL Export
            _wsl_export() {
                _init_wsl_backup

                # WSL環境を選択
                print -r -- "エクスポートするWSL環境を選択してください:"
                local selected_env=$(_wsl_select_one_distribution)

                if [[ -z "$selected_env" ]]; then
                    print -r -- "WSL環境が選択されませんでした。処理を中止します。"
                    return 1
                fi

                # タイムスタンプ生成
                local timestamp=$(date "+%Y%m%d_%H%M")

                # ファイル名生成
                local filename="${selected_env}_${timestamp}.tar"
                local filepath="$WSL_BACKUP_DIR/$filename"

                # メッセージ入力
                print -r -- "このバックアップの説明を入力してください:"
                local message
                read "message"

                if [[ -z "$message" ]]; then
                    message="バックアップ作成"
                fi

                # エクスポート実行
                print -r -- "WSL環境「$selected_env」をエクスポートしています..."
                print -r -- "保存先: $filepath"

                wsl --export "$selected_env" "$filepath"

                if [[ $? -eq 0 ]]; then
                    # CSV記録
                    _add_backup_record "$filename" "$message"
                    print -r -- "エクスポートが完了しました。"
                    print -r -- "ファイル: $filename"
                    print -r -- "説明: $message"
                else
                    print -r -- "エクスポートに失敗しました。"
                    return 1
                fi
            }

            # WSL Import
            _wsl_import() {
                _init_wsl_backup

                # バックアップファイルを選択
                local selected_file=$(_select_backup_file)

                if [[ -z "$selected_file" ]]; then
                    print -r -- "バックアップファイルが選択されませんでした。処理を中止します。"
                    return 1
                fi

                # 新しい環境名を入力
                print -r -- "新しいWSL環境名を入力してください:"
                local new_env_name
                read "new_env_name"

                if [[ -z "$new_env_name" ]]; then
                    print -r -- "環境名が入力されませんでした。処理を中止します。"
                    return 1
                fi

                # デフォルトのインストール先を使用
                local install_path="$HOME/AppData/Local/WSL/$new_env_name"
                mkdir -p "$install_path"

                # インポート実行
                local backup_filepath="$WSL_BACKUP_DIR/$selected_file"
                print -r -- "WSL環境「$new_env_name」をインポートしています..."
                print -r -- "ソース: $selected_file"

                wsl --import "$new_env_name" "$install_path" "$backup_filepath"

                if [[ $? -eq 0 ]]; then
                    print -r -- "インポートが完了しました。"
                    print -r -- "新しいWSL環境「$new_env_name」が利用可能です。"
                else
                    print -r -- "インポートに失敗しました。"
                    return 1
                fi
            }


            # 停止中WSL環境の解析関数
            parse_stopped_wsl() {
                local wsl_output=$1
                local -a stopped_distributions=()
                local -a stopped_distributions_with_explains=()
                
                while IFS= read -r line; do
                    # 制御文字を除去
                    local cleaned_line=$(echo "$line" | tr -d '\r' | sed 's/[[:cntrl:]]//g' | sed 's/▒[0-9]*//g')
                    
                    # 先頭空白除去と*除去
                    local trimmed="${cleaned_line#"${cleaned_line%%[! ]*}"}"
                    trimmed="${trimmed#\*}"  # 先頭の*を除去
                    trimmed="${trimmed#"${trimmed%%[! ]*}"}"  # 再度空白除去
                    
                    # NAMEヘッダーをスキップ
                    if [[ "$trimmed" =~ ^NAME ]] || [[ -z "$trimmed" ]]; then
                        continue
                    fi
                    
                    # Stopped状態の行のみ処理
                    if [[ "$trimmed" =~ Stopped ]]; then
                        local distro=$(echo "$trimmed" | awk '{print $1}')
                        local state=$(echo "$trimmed" | awk '{print $2}')
                        
                        if [[ -n "$distro" && "$state" == "Stopped" ]]; then
                            stopped_distributions+=("$distro")
                            stopped_distributions_with_explains+=("${distro}:${state}")
                        fi
                    fi
                done <<< "$wsl_output"
                
                # グローバル変数に結果を格納
                WSL_STOPPED_DISTRIBUTIONS=("${stopped_distributions[@]}")
                WSL_STOPPED_DISTRIBUTIONS_WITH_EXPLAINS=("${stopped_distributions_with_explains[@]}")
            }

            # 停止中WSL環境選択関数
            wsl_select_stopped_distributions() {
                local wsl_output=$(wsl --list --verbose)
                parse_stopped_wsl "$wsl_output"
                
                if [[ ${#WSL_STOPPED_DISTRIBUTIONS} -eq 0 ]]; then
                    print -r -- "停止中のWSL環境が見つかりませんでした" >&2
                    return 1
                fi
                
                print -r -- "削除するWSL環境を選択してください（複数選択可能）:" >&2
                print -r -- "削除すると環境は完全に消去され、復元できません" >&2
                
                # 複数選択
                local -a selected_distros=($(select_items_stepwise ${#WSL_STOPPED_DISTRIBUTIONS} WSL_STOPPED_DISTRIBUTIONS WSL_STOPPED_DISTRIBUTIONS_WITH_EXPLAINS))
                
                # 選択結果を返す
                if [[ ${#selected_distros} -gt 0 ]]; then
                    print -l "${selected_distros[@]}"
                else
                    print -r -- "WSL環境が選択されませんでした" >&2
                    return 1
                fi
            }

            # WSL環境削除関数（複数対応）
            _wsl_remove() {
                # 削除対象を選択
                local -a selected_distros=($(wsl_select_stopped_distributions))
                
                if [[ ${#selected_distros} -eq 0 ]]; then
                    print -r -- "削除する環境が選択されませんでした。処理を中止します。"
                    return 1
                fi
                
                # 最終確認
                print -r -- "以下のWSL環境を削除します:"
                for distro in "${selected_distros[@]}"; do
                    print -r -- "  - $distro"
                done
                print -r -- ""
                print -r -- "この操作は取り消しできません"
                print -n "本当に削除しますか？ (yes/No): "
                
                local confirm
                read "confirm"
                
                if [[ "$confirm" != "yes" ]]; then
                    print -r -- "削除をキャンセルしました。"
                    return 0
                fi
                
                # 選択された環境を順次削除
                for distro in "${selected_distros[@]}"; do
                    print -r -- "WSL環境「$distro」を削除しています..."
                    wsl --unregister "$distro"
                    
                    if [[ $? -eq 0 ]]; then
                        print -r -- "「$distro」を正常に削除しました。"
                    else
                        print -r -- "「$distro」の削除に失敗しました。"
                    fi
                done
                
                print -r -- "削除処理が完了しました。"
            }

            # vhdxパス取得
            _get_wsl_vhdx_path() {
                local distro=$1
                # PowerShellを使ってレジストリから直接パスを取得
                local vhdx_path=$(powershell.exe -Command "
                    \$distroGuid = (Get-ItemProperty 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Lxss' -Name '*' | 
                        Where-Object { \$_.DistributionName -eq '$distro' }).PSChildName
                    if (\$distroGuid) {
                        (Get-ItemProperty \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Lxss\\\$distroGuid\").BasePath + '\\ext4.vhdx'
                    }
                " 2>/dev/null | tr -d '\r\n')
                
                if [[ -n "$vhdx_path" ]]; then
                    echo "$vhdx_path"
                fi
            }

            # WSL vhdxクリーンアップコマンド
            _wsl_clean() {
                # クリーン対象を選択
                print -r -- "クリーンアップするWSL環境を選択してください:"
                local selected_env=$(_wsl_select_one_distribution)
                
                if [[ -z "$selected_env" ]]; then
                    print -r -- "WSL環境が選択されませんでした。処理を中止します。"
                    return 1
                fi
                
                # vhdxパスを取得
                local raw_vhdx_path=$(_get_wsl_vhdx_path "$selected_env")
                
                if [[ -z "$raw_vhdx_path" ]]; then
                    print -r -- "vhdxファイルパスの取得に失敗しました。"
                    return 1
                fi
                
                # 表示用にプレフィックスを除去
                local clean_vhdx_path="${raw_vhdx_path#\\\\?\\}"
                
                print -r -- ""
                print -r -- "=== WSL vhdx クリーンアップ手順 ==="
                print -r -- "WSL環境: $selected_env"
                print -r -- "vhdxパス: $clean_vhdx_path"
                print -r -- ""
                print -r -- "以下のコマンドを PowerShell（管理者権限）で実行してください:"
                print -r -- ""
                print -r -- "wsl --shutdown"
                print -r -- "diskpart"
                print -r -- ""
                print -r -- "# Diskpart内で以下を実行:"
                print -r -- "select vdisk file=\"$clean_vhdx_path\""
                print -r -- "attach vdisk readonly"
                print -r -- "compact vdisk"
                print -r -- "detach vdisk"
                print -r -- "exit"
                print -r -- ""
                print -r -- "=== 注意事項 ==="
                print -r -- "・必ずWSLを停止してから実行してください"
                print -r -- "・PowerShellを管理者権限で起動してください"
                print -r -- "・作業前にバックアップを推奨します"
                print -r -- ""
                
                # クリップボードにコピーするオプション（クリーンパス使用）
                local copy_commands="wsl --shutdown
            diskpart

            select vdisk file=\"$clean_vhdx_path\"
            attach vdisk readonly
            compact vdisk
            detach vdisk
            exit"
                
                print -n "コマンドをクリップボードにコピーしますか？ (y/N): "
                local copy_choice
                read "copy_choice"
                
                if [[ "$copy_choice" =~ ^[Yy]$ ]]; then
                    echo "$copy_commands" | clip.exe
                    print -r -- "コマンドをクリップボードにコピーしました。"
                fi
            }
            # WLS2 環境構築と破壊とメンテ
            alias wslm=_wsl_create_environment
            alias wslrmv=_wsl_remove
            alias wslclean=_wsl_clean
            # WLS2 環境確認
            alias wsll="wsl --list --verbose"
            # WLS2 環境開始と終了
            alias wsla=_wsl_activate
            alias wsls=_wsl_stop
            # WLS2 環境抽出と導入
            alias wslex=_wsl_export
            alias wslin=_wsl_import
            # 初期テンプレート管理
            alias wslinit="_save_as_init"
            alias wslinitrm="rm -i $WSL_BACKUP_DIR/*-init.tar"
            alias wslinitls="ls -lh $WSL_BACKUP_DIR/*-init.tar 2>/dev/null || echo '初期テンプレートがありません'"
        }

    }
}
