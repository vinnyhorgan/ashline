#!/usr/bin/env bash
# Build ashline.love — packaged LÖVE2D game file
# Usage: ./package.sh [output_name]
#
# A .love file is a zip archive with main.lua at the root.
# Only includes files used at runtime (no docs, backups, tests, scripts).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT="${1:-ashline.love}"
WORK_DIR=$(mktemp -d)

trap 'rm -rf "$WORK_DIR"' EXIT

echo "Packaging ASHLINE → ${OUTPUT}"

# Runtime Lua files
RUNTIME_LUA=(
    main.lua
    conf.lua
    game.lua
    commands.lua
    data.lua
    terminal.lua
    menu_ui.lua
    sound.lua
    settings.lua
    save.lua
    boot.lua
    colors.lua
    display.lua
    utf8_utils.lua
)

for f in "${RUNTIME_LUA[@]}"; do
    cp "${SCRIPT_DIR}/${f}" "${WORK_DIR}/${f}"
done

# Libraries
mkdir -p "${WORK_DIR}/lib/moonshine"
cp "${SCRIPT_DIR}/lib/json.lua" "${WORK_DIR}/lib/json.lua"
cp "${SCRIPT_DIR}"/lib/moonshine/*.lua "${WORK_DIR}/lib/moonshine/"

# Assets (fonts + sounds)
mkdir -p "${WORK_DIR}/assets/fonts" "${WORK_DIR}/assets/sounds"
cp "${SCRIPT_DIR}"/assets/fonts/*.ttf "${WORK_DIR}/assets/fonts/"
cp "${SCRIPT_DIR}"/assets/sounds/*.wav "${WORK_DIR}/assets/sounds/"

# Build the .love (zip) archive
cd "${WORK_DIR}"
zip -9 -q -r "${SCRIPT_DIR}/${OUTPUT}" .

FILE_SIZE=$(du -h "${SCRIPT_DIR}/${OUTPUT}" | cut -f1)
FILE_COUNT=$(find . -type f | wc -l)

echo "Done: ${OUTPUT} (${FILE_SIZE}, ${FILE_COUNT} files)"
echo "Run with: love ${OUTPUT}"
