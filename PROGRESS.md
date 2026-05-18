# dotfiles — PROGRESS.md

> 更新頻度：高（実装ステップごとに更新）

---

## 現在のフェーズ: **Phase 9.0.0 完了、実環境確認待ち**

テスト累計: **0 Green** （テストなし）

---

## フェーズ一覧

```
Phase 1.0.0: Claude管理開始時点の安定状態              完了 (2026-05-15)
Phase 2.0.0: pyenv → uv 移行                          構文OK / 実環境確認待ち
Phase 3.0.0: ファイル構造再編 (Linux ベース継承)       構文OK / 実環境確認待ち
Phase 4.0.0: uva の OS分岐 (C案=上書き方式)            構文OK / 実環境確認待ち
Phase 4.1.0: ロード順俯瞰 LOAD_ORDER.md 作成           完了 (2026-05-18)
Phase 5.0.0: 俯瞰所見の対処                            構文OK / 実環境確認待ち
Phase 6.0.0: uv alias 群の改善                         構文OK / 実環境確認待ち
Phase 6.1.0: nvim 廃止 (vim 9 に移行)                  構文OK / 実環境確認待ち
Phase 6.2.0: Windows uv 方針確定 + LOAD_ORDER mermaid 化  完了 (2026-05-18)
Phase 6.2.1: LOAD_ORDER mermaid 改善                   完了 (2026-05-18)
Phase 7.0.0: initialize.2.sh OS分岐 + ツール統合       構文OK / 実環境確認待ち
Phase 8.0.0: initialize.{4,5}.sh 削除 + tmux 設定 symlink 化  構文OK / 実環境確認待ち
Phase 8.1.0: scoop 自動化                              構文OK / 実環境確認待ち
Phase 8.1.1: initialize.2.sh 実環境バグ修正            構文OK / 実環境確認待ち
Phase 9.0.0: Windows ディレクトリ抽象化 (symlink で $HOME ベース統一)  構文OK / 実環境確認待ち
```

## Phase 1.0.0: Claude管理開始時点の安定状態
過去の蓄積（詳細は `git log` 参照）。DECISIONS.md の「Claude管理開始」区切り行より上の判断群がこのフェーズで確立した状態。

## Phase 2.0.0: pyenv → uv 移行
- [x] initialize.2.sh: pyenv削除 + uv installer追加 + apt依存縮小
- [x] initialize.3.sh: setup_neovim を uv ベースに書き換え
- [x] dot_zshrc_for_common.sh: pyenv ブロック削除
- [x] dot_zshrc_for_{linux,wsl,mac}.sh: _activate_pyenv 呼び出し削除
- [x] dot_zshrc_for_windows.sh: _activate_pyenv_win 呼び出し削除
- [x] dot_zshrc_util.sh: pyenv 関連関数群削除（select_1_item は他で使用中、残す）
- [x] dot_config/nvim/init.vim: pyenv パスを uv venv パスに変更
- [x] 構文チェック (zsh -n) — 全スクリプトOK (2026-05-18)
- [ ] 実環境動作確認 (Ubuntu/WSL/Mac で initialize.2.sh, 3.sh 実行、neovim Python連携確認)

## Phase 3.0.0: ファイル構造再編 (Linux ベース継承)
- [x] dot_zshrc.sh: ロード順を統一（Mac=common→linux→mac, Linux=common→linux, WSL=common→linux→wsl, Windows=common→windows）
- [x] dot_zshrc_for_linux.sh: CALLING_COMMON_SETTIG ブロックを削除（dot_zshrc.shで読まれるため）
- [x] dot_zshrc_for_wsl.sh: 同上
- [x] dot_zshrc_for_windows.sh: 同上
- [x] 構文チェック (zsh -n) — 全スクリプトOK (2026-05-18)

## Phase 4.0.0: uva の OS分岐 (C案=上書き方式)
- [x] dot_zshrc_for_common.sh: _activate_uvenv 関数を削除し alias のみ残す（_deactivate_uvenv / _create_uvenv は OS共通なので維持）
- [x] dot_zshrc_for_linux.sh: _activate_uvenv (bin/activate版) を定義
- [x] dot_zshrc_for_windows.sh: _activate_uvenv (Scripts/activate版) を定義
- [x] 構文チェック (zsh -n) — 全スクリプトOK (2026-05-18)

## Phase 4.1.0: ロード順俯瞰 LOAD_ORDER.md 作成
- [x] LOAD_ORDER.md 作成 — 各起動ルート (Mac/Linux/WSL/Windows) のロード順と各ファイルの宣言タスクを俯瞰、所見8項目を記載 (2026-05-18)

## Phase 5.0.0: 俯瞰所見の対処
- [x] #4 dot_zshrc_for_common.sh:483 の ghcup ハードコード修正 (`$HOME/.ghcup/env`)
- [x] #1 PRE_CALLING_COMMON → COMMON_OVERRIDE (windows.sh のみ残存、Linux/WSL は #2 で削除)
- [x] #7 dot_zshrc.sh の MINGW case 統合 (`MINGW*_NT*` / `CURR_OS="Windows"`)
- [x] #6 dot_zshrc_for_mac.sh の二重 UNIQUE_SETTING ネストをフラット化
- [x] #2 Linux/WSL の MY_WORK_DIR / MY_GITCLONE_DIR 重複設定削除 (Windows は意図的上書きなので維持)
- [x] 構文チェック (zsh -n) — 全スクリプトOK (2026-05-18)

## Phase 6.0.0: uv alias 群の改善 (おすすめコース)
- [x] _deactivate_uvenv を `$VIRTUAL_ENV` ベースに修正 (`.venv` 有無ではなく実 active 状態をチェック)
- [x] _activate_uvenv の存在チェックを `.venv/bin/activate` ファイル単位に変更（ディレクトリだけだと壊れた venv で詰む）
- [x] _activate_uvenv に二重 activate 警告追加 (`$VIRTUAL_ENV` セット済みなら拒否)
- [x] _create_uvenv に既存 .venv 上書き警告追加
- [x] _create_uvenv の引数を 0/1 引数許容に柔軟化 (0引数は uv のデフォルト python)
- [x] 構文チェック (zsh -n) — 全スクリプトOK (2026-05-18)

## Phase 6.1.0: nvim 廃止 (vim 9 に移行)
- [x] `dot_config/nvim/init.vim` の Windows ブロックを uv 化（Python2 host_prog 削除、Python3 host_prog を `$HOME/.local/share/uv-venvs/neovim3/Scripts/python.exe`、コメント整理）
- [x] `initialize.3.sh` から `setup_neovim` 関数削除（メニュー選択肢 1〜4 に繰り上げ）
- [x] `core.editor` を `vim` に変更して `setup_dev_tools` 末尾に移動
- [x] `setup_dev_tools` の `npm install -g yarn neovim` から `neovim` を削除

## Phase 6.2.0: Windows uv 方針確定 + LOAD_ORDER mermaid 化
- [x] Windows での uv インストール方式を公式 PowerShell standalone installer に決定
- [x] DECISIONS.md に判断記録、README.md に Windows 用セットアップ手順追記
- [x] `initialize_windows.sh` 新規作成 (※Phase 7.0.0 で initialize.2.sh に統合・削除)
- [x] `LOAD_ORDER.md` の起動ルート図を ASCII art から mermaid flowchart に変更

## Phase 6.2.1: LOAD_ORDER mermaid 改善
- [x] subgraph 記述順を Linux → Mac → WSL → Windows に変更（Linux を基盤として記述）
- [x] Mac/WSL の util/compinit/for_common/for_linux を「(Linux同)」表記に統一
- [x] `for_linux` ノードに `linuxSame` クラス追加（緑塗り + 緑点線で「Linux継承」を視覚化）
- [x] Windows の `for_windows` ボックスを 3 分割（他環境対応 / wsl系 / その他）
- [x] Windows と Unix系の対応関係表を追加

## Phase 7.0.0: initialize.2.sh OS分岐 + ツール統合
- [x] `initialize_windows.sh` 削除（initialize.2.sh に統合）
- [x] `initialize.2.sh` で OS分岐 (Linux: apt + uv + vim, Windows: PowerShell uv + scoop vim, 共通: fzf git clone install)
- [x] `initialize.3.sh` の apt から `fzf` 削除 (2.sh と重複防止)
- [x] `dot_zshrc_for_common.sh`: `his` alias / `_show_history` 関数を削除（fzf の Ctrl+R で代替）
- [x] `dot_zshrc_for_common.sh`: `typeset -U path` を PRESETTING に追加（PATH 重複排除）
- [x] `dot_zshrc_for_common.sh`: fzf source を `.fzf.bash` → `.fzf.zsh` に変更
- [x] `README.md`: Windows ステップを git bash + scoop 前提に更新
- [x] 構文チェック (zsh -n) — 全スクリプトOK (2026-05-19)

## Phase 8.0.0: initialize.{4,5}.sh 削除 + tmux 設定 symlink 化
- [x] `initialize_ubuntu.4.sh` 削除（機能は initialize.3.sh の `setup_dev_tools` / `setup_tmux` に統合済み）
- [x] `initialize_ubuntu.5.sh` 削除（機能は initialize.3.sh の `setup_xmonad` に統合済み）
- [x] `dot_tmux.conf` 新規作成（initialize.3.sh の heredoc 内容を切り出し）
- [x] `link_dotfiles.sh` に `LINK_DOTS_OF_TMUX` セクション追加（`~/.tmux.conf` → `dot_tmux.conf`）
- [x] `initialize.3.sh` の `setup_tmux` を簡素化（heredoc 削除、symlink 確認のみ）
- [x] 構文チェック (bash -n / zsh -n) OK (2026-05-19)
- [x] ファイル名リネーム: `initialize_ubuntu.{1,2,3}.sh` → `initialize.{1,2,3}.sh` (OS分岐対応のため Ubuntu 限定の名前を解消)

## Phase 8.1.0: scoop 自動化
- [x] `initialize.2.sh` の Windows ブランチに scoop 自動インストールを追加（公式 PowerShell installer 経由、`Set-ExecutionPolicy -Scope CurrentUser` + `iwr get.scoop.sh | iex`）
- [x] インストール後に `export PATH="$HOME/scoop/shims:$PATH"` で当該セッションに反映
- [x] README.md の Windows 事前準備から「scoop 導入済み」を削除（git bash + zsh のみ事前準備）
- [x] 構文チェック (zsh -n) OK (2026-05-19)

## Phase 8.1.1: initialize.2.sh 実環境バグ修正
- [x] `link_dotfiles.sh` の呼び出しをスクリプト自身の場所基準に変更（旧: `$HOME/<親dir名>/<dotfiles dir名>` を仮定 → Windowsで `$HOME` 外に置く場合に破綻）
- [x] `git_clone` ディレクトリ確保を OS 分岐（Linux/Mac/WSL: `$HOME/git_clone`、Windows: `/c/git_clone`）※ Phase 9.0.0 で再整理
- [x] `dot_zshrc_for_common.sh` の `FLAGS_FOR_SETTING`: `MY_FLG_FZF` チェックに `[ -f ~/.fzf.zsh ]` 追加（fzf インストール直後の PATH チキン&エッグ問題を回避）
- [x] 構文チェック (zsh -n) OK (2026-05-19)

## Phase 9.0.0: Windows ディレクトリ抽象化 (symlink で $HOME ベース統一)
- [x] `link_dotfiles.sh`: `link_dotfile` 関数の存在チェックを `-f` → `-e` に変更（ファイル/ディレクトリ両対応）
- [x] `link_dotfiles.sh`: `LINK_OS_BASE_DIRS_FOR_WINDOWS` セクション追加（Windows のみ `$HOME/git_clone` → `/c/git_clone`、`$HOME/ws` → `/c/ws` の symlink 作成）
- [x] `initialize.2.sh`: `git_clone` 確保を OS分岐削除、`$HOME/git_clone` で統一（Windows は link_dotfiles.sh で symlink 済み）
- [x] `initialize.2.sh`: 末尾の `source ~/.zshrc` を通知メッセージに置換（サブシェル限定で意味なかった、ユーザーに `zrc` 実行を促す）
- [x] `dot_zshrc_for_windows.sh`: `COMMON_OVERRIDE` ブロック削除（`MY_WORK_DIR=/c/ws` / `MY_GITCLONE_DIR=/c/git_clone` の override 廃止、common.sh のデフォルト `$HOME/ws` / `$HOME/git_clone` を使用、symlink 経由で `/c` 配下を指す）
- [x] 実環境動作確認 (Windows): symlink 作成、fzf PATH 通る、`zrc` で zshrc 反映 確認済み (2026-05-19)
- [x] 構文チェック (bash -n / zsh -n) OK (2026-05-19)
