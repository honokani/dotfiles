#!/usr/bin/zsh
# initialize_windows.sh - Windows 用 uv セットアップ
# msys2 / git bash から実行（内部で PowerShell を呼ぶ）

if ! command -v uv > /dev/null 2>&1; then
    echo "Installing uv (official PowerShell installer)..."
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
else
    echo "Updating uv..."
    uv self update
fi
