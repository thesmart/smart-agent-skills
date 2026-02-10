#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <skill-name>" >&2
  echo "" >&2
  echo "Available skills:" >&2
  for dir in "$SCRIPT_DIR"/*/; do
    [ -f "$dir/SKILL.md" ] && echo "  $(basename "$dir")" >&2
  done
  exit 1
fi

SKILL="$1"
SKILL_DIR="$SCRIPT_DIR/$SKILL"

if [ ! -d "$SKILL_DIR" ]; then
  echo "Error: skill '$SKILL' not found in $SCRIPT_DIR" >&2
  exit 1
fi

if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
  echo "Error: $SKILL_DIR/SKILL.md not found" >&2
  exit 1
fi

NAME=$(sed -n 's/^name: *//p' "$SKILL_DIR/SKILL.md" | head -1)

if [ -z "$NAME" ]; then
  echo "Error: could not read name from $SKILL_DIR/SKILL.md frontmatter" >&2
  exit 1
fi

TARGET="$HOME/.claude/skills/$NAME"
mkdir -p "$TARGET"
cp -Rv "$SKILL_DIR"/* "$TARGET/"

if [ "$SKILL" = "diagram" ]; then
  cp -Rv "$SCRIPT_DIR/../contextualize-mermaid-syntax/context" "$TARGET/"
fi

echo "Installed skill '$NAME' -> $TARGET"
