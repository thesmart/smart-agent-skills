#!/bin/sh
# urlencode.sh — percent-encode a string for use in URLs
#
# Usage:
#   ./urlencode.sh "hello world"        → hello%20world
#   echo "foo/bar" | ./urlencode.sh     → foo%2Fbar

set -eu

urlencode() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$1" | jq -sRr @uri
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1],safe=''))" "$1"
  elif command -v python >/dev/null 2>&1; then
    python -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1],safe=''))" "$1"
  else
    printf 'error: jq or python3 is required\n' >&2
    exit 1
  fi
}

if [ $# -gt 0 ]; then
  urlencode "$1"
else
  while IFS= read -r line; do
    urlencode "$line"
  done
fi
