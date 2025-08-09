select_items_stepwise() {
    local max_select=$1
    local -a choices=("${(@P)2}")
    local choices_with_explains_name=$3
    local -a choices_with_explains=("${(@P)3}")
    local -a selected=()
    local -a selected_indices=()
    local choice
    
    if [[ ${#choices} -eq 0 ]]; then
        print -l "${selected[@]}"
        return 0
    fi

    if [[ $max_select -le 0 ]]; then
        print -l "${selected[@]}"
        return 0
    fi

    if [[ $max_select -gt ${#choices} ]]; then
        print -l "${choices[@]}"
        return 0
    fi

    # 選択肢と説明のマッピングを作成
    local -A explains
    local i=0
    local item explain
    for item in "${choices_with_explains[@]}"; do
        if [[ "$item" =~ ":" ]]; then
            local key="${item%%:*}"
            local value="${item#*:}"
            explains[$key]="$value"
        fi
    done

    # インタラクティブ選択ループ
    while [[ ${#selected} -lt $max_select ]]; do
        # q,c：終了・キャンセルオプションを表示
        print -r -- "   q) 終了" >&2
        print -r -- "   c) キャンセル" >&2
        
        # 選択肢の表示 - すべて標準エラー出力に送る
        for ((i=1; i<=${#choices}; i++)); do
            # 既に選択済みの項目はスキップ
            if (( ${selected_indices[(I)$i]} )); then
                continue
            fi
            
            local item="${choices[$i]}"
            local myval=""
            if [[ $i -lt 10 ]]; then
                myval=" "
            fi
            
            if [[ -n "${explains[$item]}" ]]; then
                print -r -- "  $myval$i) $item - ${explains[$item]}" >&2
            else
                print -r -- "  $myval$i) $item" >&2
            fi
        done

        # 選択プロンプト表示
        print -n "選択数(${#selected}/${max_select}) | 選択(q:終了/c:キャンセル)：" >&2
        read "choice"

        # q/cが選択された場合の処理
        if [[ "$choice" == "q" ]]; then
            print -r -- "選択を終了しました" >&2
            break
        elif [[ "$choice" == "c" ]]; then
            print -r -- "選択をキャンセルしました" >&2
            selected=()
            break
        fi

        # 有効な選択かチェック（数字の場合）
        if [[ "$choice" =~ ^[0-9]+$ && $choice -ge 1 && $choice -le ${#choices} ]]; then
            # 既に選択済みでないかチェック
            if (( ! ${selected_indices[(I)$choice]} )); then
                selected+=("${choices[$choice]}")
                selected_indices+=($choice)
            else
                print -r -- "既に選択済みです。別の選択肢を選んでください。" >&2
            fi
        else
            print -r -- "無効な選択です。1から${#choices}の間の数字、またはq/cを入力してください。" >&2
        fi
    done

    # 最終的な選択結果を標準出力に返す
    for item in "${selected[@]}"; do
        print "$item"
    done
}

select_1_item() {
    local choices_name=$1
    local explains_name=${2:-""}
    local -a selected=($(select_items_stepwise 1 "$choices_name" "$explains_name"))
    if [[ ${#selected} -gt 0 ]]; then
        print "${selected[1]}"
    fi
}

select_items_at_once() {
    local max_select=$1
    local -a choices=("${(@P)2}")
    local choices_with_explains_name=$3
    local -a choices_with_explains=("${(@P)3}")
    local -A selected_map=()
    local choice
    
    [[ ${#choices} -eq 0 || $max_select -le 0 ]] && return 0
    [[ $max_select -gt ${#choices} ]] && { print -l "${choices[@]}"; return 0; }

    # 選択肢と説明のマッピング
    local -A explains
    for item in "${choices_with_explains[@]}"; do
        [[ "$item" =~ ":" ]] && explains[${item%%:*}]="${item#*:}"
    done

    # 文字列切り詰めと固定幅化
    format_fixed_width() {
        local str="$1" width=80
        if [[ ${#str} -gt $width ]]; then
            printf "%-${width}s" "${str:0:$((width-3))}..."
        else
            printf "%-${width}s" "$str"
        fi
    }
   
    local ESC=$'\033' # ANSI エスケープ
    print -n "${ESC}[?25l" >&2 # カーソル非表示

    print -r -- "event) q: 選択完了 / c: キャンセル" >&2 # ヘッダー表示
    local i
    for ((i=1; i<=${#choices}; i++)); do # 選択肢表示
        local num_pad=$([[ $i -lt 10 ]] && echo " " || echo "")
        local item_formatted=$(format_fixed_width "${choices[$i]}")
        if [[ -n "${explains[${choices[$i]}]}" ]]; then
            print -r -- "   $num_pad$i) $item_formatted - ${explains[${choices[$i]}]}" >&2
        else
            print -r -- "   $num_pad$i) $item_formatted" >&2
        fi
    done
    print "" >&2
    
    while [[ ${#selected_map} -lt $max_select ]]; do # フッター表示と選択
        local count_str=$(printf "%03d" ${#selected_map})
        local max_str=$(printf "%03d" $max_select)
        print -n "\r選択数($count_str/$max_str)：" >&2
        
        read choice
        print -n "${ESC}[1A${ESC}[2K" >&2 # read後の改行を処理（1行上に戻って行をクリア）
        
        if [[ "$choice" == "q" ]]; then
            print -n "\r${ESC}[2K選択を完了しました" >&2
            break
        elif [[ "$choice" == "c" ]]; then
            print -n "\r${ESC}[2Kキャンセルしました" >&2
            selected_map=()
            break
        elif [[ "$choice" =~ ^[0-9]+$ && $choice -ge 1 && $choice -le ${#choices} ]]; then
            local up=$((${#choices} - $choice + 2)) # 対象行へ移動（現在位置から上へ、空行考慮）
            print -n "${ESC}[${up}A" >&2
            
            if [[ -n "${selected_map[$choice]}" ]]; then # 選択マークを除去
                unset "selected_map[$choice]"
                print -n "\r   " >&2
            else # 選択マークを付与
                selected_map[$choice]="${choices[$choice]}"
                print -n "\r o " >&2
            fi
           
            print -n "${ESC}[${up}B" >&2 # 元の位置に戻る
        fi
    done
   
    print -n "${ESC}[?25h" >&2 # カーソル表示して改行
    print "" >&2
    
    for ((i=1; i<=${#choices}; i++)); do # 選択項目を順番に出力
        [[ -n "${selected_map[$i]}" ]] && print "${selected_map[$i]}"
    done
}



parse_pyenv_versions() {
    local pyenv_output=$1
    local -a versions=()
    local -a versions_with_explains=()
    
    # 各行を処理
    while IFS= read -r line; do
        # 行を整形（先頭の空白を削除）
        local trimmed_line="${line#"${line%%[! ]*}"}"
        
        # バージョン番号を抽出
        if [[ "$trimmed_line" =~ ^[\*]?[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+) ]]; then
            local version="${match[1]}"
            versions+=("$version")
            
            # 説明を抽出（バージョン番号の部分を取り除く）
            local explain="${trimmed_line/${version}/}"
            
            # 説明が存在する場合のみ追加
            if [[ -n "${explain// /}" ]]; then
                versions_with_explains+=("${version}:${explain}")
            fi
        fi
    done <<< "$pyenv_output"
    
    # グローバル変数に結果を格納
    PYENV_ALLVERSIONS=("${versions[@]}")
    PYENV_ALLVERSIONS_WITH_EXPLAINS=("${versions_with_explains[@]}")
}

pyenv_select_version() {
    # pyenv versionsの実行結果を取得
    local pyenv_output=$(pyenv versions)
    
    # バージョンと説明を解析
    parse_pyenv_versions "$pyenv_output"
    
    # ユーザーに選択を促す
    print -r -- "以下のPythonバージョンから選択:" >&2
    local selected_version=$(select_1_item PYENV_ALLVERSIONS PYENV_ALLVERSIONS_WITH_EXPLAINS)
    
    # 選択結果を返す
    if [[ -n "$selected_version" ]]; then
        print "$selected_version"
    else
        print -r -- "バージョンが選択されませんでした" >&2
    fi
}

create_python_venv() {
    # 使用するPythonバージョンを選択
    print -r -- "使用するPythonバージョンを選択してください:" 
    local python_version=$(pyenv_select_version)
    
    if [[ -z "$python_version" ]]; then
        print -r -- "Python バージョンが選択されませんでした。処理を中止します。"
        return 1
    fi
    
    # 仮想環境の名前を入力
    print -r -- "仮想環境の名前を入力してください（例: myenv）:"
    local env_name=""
    read "env_name"
    
    if [[ -z "$env_name" ]]; then
        print -r -- "環境名が入力されませんでした。処理を中止します。"
        return 1
    fi
    
    # pyenvでPythonバージョンを切り替え
    pyenv local $python_version
    
    # 仮想環境を作成
    python -m venv "$env_name"
    
    # 結果確認
    if [[ $? -eq 0 ]]; then
        print -r -- "仮想環境「$env_name」が正常に作成されました。"
        return 0
    else
        print -r -- "仮想環境の作成に失敗しました。"
        return 1
    fi
}
