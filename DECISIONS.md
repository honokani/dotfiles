# dotfiles — DECISIONS.md

> 「なぜAではなくBか」を記録する。コードからは読めない判断根拠。
> PROGRESS.mdの決定ログは「何をしたか」の実行記録、本ファイルは「なぜそうしたか」の判断根拠。
> 環境列（Win/Mac/Linux/WSL）は ◯/× で関係性を示す。

## Python

| Phase | 大分類 | 小分類 | Win | Mac | Linux | WSL | 選択 | 却下案 | 理由 |
|-------|--------|--------|-----|-----|-------|-----|------|--------|------|
| -     | Python | パッケージ管理 | ◯ | ◯ | ◯ | ◯ | pyenv + pyenv-virtualenv | - | （要確認） |

--- 2026-05-15: Claude管理開始 ---

| Phase | 大分類 | 小分類 | Win | Mac | Linux | WSL | 選択 | 却下案 | 理由 |
|-------|--------|--------|-----|-----|-------|-----|------|--------|------|
| -     | Python | パッケージ管理 | ◯ | ◯ | ◯ | ◯ | uv | pyenv + pyenv-virtualenv | Rust製で高速、Python本体も管理可、self-update可、グローバルでの環境管理が不要 |
| -     | Python | uvインストール | ◯ | ◯ | ◯ | ◯ | 公式 standalone installer | apt / pipx | 公式推奨、self-update対応、aptは古くなりがち |

## zsh

| Phase | 大分類 | 小分類 | Win | Mac | Linux | WSL | 選択 | 却下案 | 理由 |
|-------|--------|--------|-----|-----|-------|-----|------|--------|------|
| -     | zsh    | 構造分割 | ◯ | ◯ | ◯ | ◯ | common + 環境別ファイル | 単一ファイル | （要確認） |
| -     | zsh    | OS判別 | × | × | ◯ | ◯ | WSLをLinuxと別ファイルに分離 | Linuxに統合 | （要確認） |

--- 2026-05-15: Claude管理開始 ---

| Phase | 大分類 | 小分類 | Win | Mac | Linux | WSL | 選択 | 却下案 | 理由 |
|-------|--------|--------|-----|-----|-------|-----|------|--------|------|
| 3.0.0 | zsh    | ロード構造 | ◯ | ◯ | ◯ | ◯ | Unix継承（Mac/WSL は linux を経由） | 並列4ファイル | Unix系3つ（linux/mac/wsl）が同一処理を要するケースの重複を避ける。WSL実体はUbuntuなので linux 基盤が自然 |
| 3.0.0 | zsh    | ロード一元管理 | ◯ | ◯ | ◯ | ◯ | dot_zshrc.sh で全ロードを管理 | 各 for_*.sh が common を自己呼び出し | Mac だけ構造が違う不整合を解消。ロード順がトップで一覧できる |
| 4.0.0 | zsh    | OS分岐方式 | ◯ | ◯ | ◯ | ◯ | C案: 上書き方式（for_linux.sh で定義、for_windows.sh で上書き） | A案: 関数内分岐 / B案: OSNAME連結 | A案は VISION.md の分割原則と矛盾。B案は OSNAME管理 + エイリアスチェーンが複雑。Unix継承構造下では C案がもっとも自然 |
| 5.0.0 | zsh    | ブロック名 | ◯ | ◯ | ◯ | ◯ | COMMON_OVERRIDE | PRE_CALLING_COMMON | 新構造では common.sh ロード後の上書きなので「PRE」は実態と逆 |
| 5.0.0 | zsh    | OS判定 case | ◯ | × | × | × | MINGW*_NT* 1ケースに統合, CURR_OS="Windows" | MINGW32_NT* / MINGW64_NT* を分離 | 両者で処理が同一、bit表示が必要なら uname -a が出力 |
| 5.0.0 | zsh    | mac.sh 構造 | × | ◯ | × | × | フラット化（外側 UNIQUE_SETTING のみ） | 二重 UNIQUE_SETTING ネスト維持 | 内側に PRE_CALLING_COMMON 相当がないので外側だけで充分 |
| 5.0.0 | zsh    | MY_WORK_DIR 設定 | ◯ | × | × | × | Windowsのみ明示上書き (/c/ws) | 全環境で明示設定 / 全環境でcommon任せ | Windowsはアドレスバーから直打ち用に /c/ws を意図的に使用。Linux/Mac/WSL は common デフォルト ($HOME/ws) で十分 |
| 5.0.0 | Haskell | ghcupパス | ◯ | ◯ | ◯ | ◯ | $HOME/.ghcup/env | /Users/shoto.miki/.ghcup/env (他ユーザー名ハードコード) | バグ修正、HOME 経由が正しい |
| 6.0.0 | uv | deactivate判定 | ◯ | ◯ | ◯ | ◯ | $VIRTUAL_ENV を見る | `.venv` ディレクトリ有無を見る | `.venv` 有無と active状態は別。active していないのに deactivate を呼ぶと error |
| 6.0.0 | uv | activate存在チェック | ◯ | ◯ | ◯ | ◯ | activate スクリプト本体 (`-f`) | `.venv` ディレクトリ (`-d`) | ディレクトリだけだと壊れた venv (bin/activate なし) で source 失敗 |
| 6.0.0 | uv | 二重 activate | ◯ | ◯ | ◯ | ◯ | 警告して拒否 | 黙って上書き | 既に他 venv に居ることを気づかず再 activate する事故防止 |
| 6.0.0 | uv | create 引数仕様 | ◯ | ◯ | ◯ | ◯ | 0/1 引数許容 (0=uv デフォルト python) | 1引数必須 | `uv venv` 自体が引数なしで動くので、ラッパー側で縛る理由がない |
| -     | uv | Windowsインストール方式 | ◯ | × | × | × | 公式 PowerShell standalone installer | Scoop / WinGet | Linux/Mac と一貫した配置 (`%USERPROFILE%\.local\bin\uv.exe`)、現状の zshrc PATH 設定がそのまま機能、self-update対応 |

## vim

| Phase | 大分類 | 小分類 | Win | Mac | Linux | WSL | 選択 | 却下案 | 理由 |
|-------|--------|--------|-----|-----|-------|-----|------|--------|------|
| -     | vim    | エディタ | ◯ | ◯ | ◯ | ◯ | neovim | vim | （要確認） |
| -     | vim    | plugin manager | ◯ | ◯ | ◯ | ◯ | dein.vim / denite | - | （要確認） |

--- 2026-05-15: Claude管理開始 ---

## 環境・Git

| Phase | 大分類 | 小分類 | Win | Mac | Linux | WSL | 選択 | 却下案 | 理由 |
|-------|--------|--------|-----|-----|-------|-----|------|--------|------|
| -     | WM     | Linux用WM | × | × | ◯ | × | xmonad | - | （要確認） |
| -     | Git    | 改行コード | ◯ | ◯ | ◯ | ◯ | gitattributes で制御 | autocrlf設定 | （要確認） |
| -     | Git    | symlink | ◯ | × | × | × | Windowsでも有効化 | - | （要確認） |

--- 2026-05-15: Claude管理開始 ---
