# dotfiles — PROGRESS.md

> 更新頻度：高（実装ステップごとに更新）

---

## 現在のフェーズ: **Phase 8.0.0 完了、実環境確認待ち**

テスト累計: **0 Green** （テストなし）

---

## フェーズ一覧

```
Phase 1.0.0: Claude管理開始時点の安定状態     完了 (2026-05-15)
Phase 2.0.0: pyenv → uv 移行                 構文OK / 実環境確認待ち
Phase 3.0.0: ファイル構造再編 (Linux ベース継承)  構文OK / 実環境確認待ち
Phase 4.0.0: uva の OS分岐 (C案=上書き方式)      構文OK / 実環境確認待ち
Phase 5.0.0: 俯瞰所見の対処                   構文OK / 実環境確認待ち
Phase 6.0.0: uv alias 群の改善                構文OK / 実環境確認待ち
Phase 7.0.0: initialize.2.sh OS分岐 + ツール統合 構文OK / 実環境確認待ち
Phase 8.0.0: initialize.{4,5}.sh 削除 + tmux 設定 symlink 化  構文OK / 実環境確認待ち
俯瞰: LOAD_ORDER.md (PFDもどき)              完了 (2026-05-18)
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

## Phase: ロード順俯瞰 (PFDもどき)
- [x] LOAD_ORDER.md 作成 — 各起動ルート (Mac/Linux/WSL/Windows) のロード順と各ファイルの宣言タスクを俯瞰、所見8項目を記載 (2026-05-18)

## Phase 5.0.0: 俯瞰所見の対処
- [x] #4 dot_zshrc_for_common.sh:483 の ghcup ハードコード修正 (`$HOME/.ghcup/env`)
- [x] #1 PRE_CALLING_COMMON → COMMON_OVERRIDE (windows.sh のみ残存、Linux/WSL は #2 で削除)
- [x] #7 dot_zshrc.sh の MINGW case 統合 (`MINGW*_NT*` / `CURR_OS="Windows"`)
- [x] #6 dot_zshrc_for_mac.sh の二重 UNIQUE_SETTING ネストをフラット化
- [x] #2 Linux/WSL の MY_WORK_DIR / MY_GITCLONE_DIR 重複設定削除 (Windows は意図的上書きなので維持)
- [x] 構文チェック (zsh -n) — 全スクリプトOK (2026-05-18)

## 即興変更ログ (Phase未割当)
- 2026-05-18: `dot_config/nvim/init.vim` の Windows ブロックを uv 化（Python2 host_prog削除、Python3 host_prog を `$HOME/.local/share/uv-venvs/neovim3/Scripts/python.exe`、コメント整理）
- 2026-05-18: `initialize.3.sh` から `setup_neovim` 関数削除（メニュー選択肢 1〜4 に繰り上げ）、`core.editor` を `vim` に変更して `setup_dev_tools` 末尾に移動、`npm install -g yarn neovim` の `neovim` 削除（vim 9 を使う方針に対応）
- 2026-05-18: Windows での uv インストール方式を公式 PowerShell standalone installer に決定、README.md に Windows 用セットアップ手順追記、DECISIONS.md に判断記録
- 2026-05-18: `initialize_windows.sh` 新規作成 (uv の Windows インストール用、内部で PowerShell installer を呼ぶ)、README.md の Windows ステップをスクリプト実行に置き換え
- 2026-05-18: `LOAD_ORDER.md` の起動ルート図を ASCII art から mermaid flowchart に変更 (PFDもどきとしての視覚化)

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

## Phase 6.0.0: uv alias 群の改善 (おすすめコース)
- [x] _deactivate_uvenv を `$VIRTUAL_ENV` ベースに修正 (`.venv` 有無ではなく実 active 状態をチェック)
- [x] _activate_uvenv の存在チェックを `.venv/bin/activate` ファイル単位に変更（ディレクトリだけだと壊れた venv で詰む）
- [x] _activate_uvenv に二重 activate 警告追加 (`$VIRTUAL_ENV` セット済みなら拒否)
- [x] _create_uvenv に既存 .venv 上書き警告追加
- [x] _create_uvenv の引数を 0/1 引数許容に柔軟化 (0引数は uv のデフォルト python)
- [x] 構文チェック (zsh -n) — 全スクリプトOK (2026-05-18)
