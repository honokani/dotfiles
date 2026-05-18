# dotfiles — VISION.md

## Why
複数環境（Windows/WSL/Linux/Mac）の個人開発環境を一元管理し、新規セットアップを `initialize_ubuntu.*.sh` で自動化する。

## 設計思想

### 全体指針
- [philosophy] 環境差分は zshrc を common + 環境別ファイル に分割して吸収する
  - OS固有機能（特定OSでしか動かない/意味がない）→ 環境別ファイル
  - OS横断機能で差分が小さい（パス・フラグ程度）→ common.sh で関数内分岐
  - OS横断機能で差分が中程度（関数1〜数行の違い）→ ベースを for_linux.sh に置き、windows.sh で上書き（Unix系=linux/mac/wsl は継承）
- [philosophy] ファイルロード構造は Unix継承: Mac=common→linux→mac, Linux=common→linux, WSL=common→linux→wsl, Windows=common→windows
- [philosophy] ロードは dot_zshrc.sh が一元管理し、各 for_*.sh は他ファイルを呼ばない
- [philosophy] 公式推奨ツール / self-update可能なツールを優先する

### 機能横断ルール
- [philosophy] dotfilesはシンボリックリンクで配置する（`link_dotfiles.sh`）
- [philosophy] 改行コードは gitattributes で制御し、環境差分を git に持ち込まない

### 機能別指針
<!-- 必要時のみ追加 -->

## 散在情報
<!-- シェルエイリアス一覧、キーバインドなど、必要に応じて追加 -->
