#!/usr/bin/env bash
# Brings the original mod's newest version into the fork:
#   ./update-upstream.sh
# Puts it on the "upstream" branch, then merges it into "main" (the fork's
# changes on top). A conflict stops the merge for it to be resolved; then
# ./check.sh and ./deploy.ps1.
set -euo pipefail
cd "$(dirname "$0")"

mod=mac-island-dock
file=mac-island-dock-fork.wh.cpp
cli="/c/Program Files/Windhawk/windhawk-cli.exe"

if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
    echo "Há mudanças não registradas no git; registre-as antes." >&2
    exit 1
fi

latest=$("$cli" repo versions "$mod" 2>/dev/null | head -1 | cut -f1)
current=$(git show upstream:"$file" | sed -n 's|^// @version *||p' | head -1 | tr -d '\r')
echo "versão do autor: ${latest:-?}  |  base do fork: ${current:-?}"
if [ -z "$latest" ] || [ "$latest" = "$current" ]; then
    echo "Nada novo."
    exit 0
fi

tmp=$(mktemp)
curl -fsSL "https://raw.githubusercontent.com/ramensoftware/windhawk-mods/main/mods/$mod.wh.cpp" -o "$tmp"
downloaded=$(sed -n 's|^// @version *||p' "$tmp" | head -1 | tr -d '\r')
if [ "$downloaded" != "$latest" ]; then
    echo "O arquivo baixado é a versão $downloaded, não $latest; tente mais tarde." >&2
    rm -f "$tmp"
    exit 1
fi
# The repository keeps LF; the fork keeps CRLF, like Windhawk's editor.
sed 's/\r*$/\r/' "$tmp" > "$tmp.crlf"

git checkout -q upstream
cp "$tmp.crlf" "$file"
git commit -qam "Upstream mac-island-dock $latest"
git checkout -q main
rm -f "$tmp" "$tmp.crlf"

if git merge --no-edit upstream; then
    echo "Versão $latest mesclada. Agora: ./check.sh e depois o deploy."
else
    echo "Conflitos ao mesclar a versão $latest: resolva-os (git status) e faça o commit." >&2
    exit 1
fi
