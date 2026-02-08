#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"

if ! command -v rg >/dev/null 2>&1; then
  echo "rg is required for this script." >&2
  exit 2
fi

missing=0
while IFS= read -r path; do
  if [[ ! -f "$path" ]]; then
    echo "Missing blueprint file: $path"
    missing=1
  fi
done < <(rg -o "blueprints/[A-Za-z0-9_./-]+\.md" "$root" --glob "*.desc.md" --no-messages | sort -u)

if [[ "$missing" -ne 0 ]]; then
  exit 1
fi

echo "Blueprint references look present."
