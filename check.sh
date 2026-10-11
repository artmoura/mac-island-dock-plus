#!/usr/bin/env bash
# Checks a mod for compile errors with Windhawk's own compiler and flags,
# without installing it: ./check.sh [file.wh.cpp]
set -uo pipefail
file="$(cd "$(dirname "${1:-mac-island-dock-fork.wh.cpp}")" && pwd)/$(basename "${1:-mac-island-dock-fork.wh.cpp}")"
compiler="/c/Program Files/Windhawk/Compiler"
cd "$compiler"
failed=0
for target in x86_64-w64-mingw32 i686-w64-mingw32; do
    echo "== $target"
    output=$(./bin/clang++.exe -fsyntax-only -x c++ -std=c++23 -target "$target" \
        -DUNICODE -D_UNICODE -DWINVER=0x0A00 -D_WIN32_WINNT=0x0A00 \
        -D_WIN32_IE=0x0A00 -DNTDDI_VERSION=0x0A000008 \
        -D__USE_MINGW_ANSI_STDIO=0 -DWH_MOD -DWH_EDITING -DWIN32_LEAN_AND_MEAN \
        -Iinclude -include windhawk_api.h \
        -Wno-pragma-pack -Wno-pragma-system-header-outside-header \
        "$file" 2>&1)
    if grep -qE "error" <<<"$output"; then
        grep -E "error" <<<"$output"
        failed=1
    else
        echo "ok"
    fi
done
exit $failed
