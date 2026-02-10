#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NAME=$(sed -n 's/^name: *//p' "$SCRIPT_DIR/SKILL.md" | head -1)

if [ -z "$NAME" ]; then
  echo "Error: could not read name from SKILL.md frontmatter" >&2
  exit 1
fi

TARGET="$HOME/.claude/skills/$NAME"
mkdir -p "$TARGET"

for item in SKILL.md context examples syntax; do
  ln -sfn "$SCRIPT_DIR/$item" "$TARGET/$item"
done

echo "Installed skill '$NAME' -> $TARGET"
