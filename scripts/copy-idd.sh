#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF' >&2
Usage: copy-idd.sh <target-repo-path> [--delete]

Copies this repo's methodology/ and library/ into the target repo's
.methodologies/idd/ folder.

Use --delete to remove files in target methodology/library folders that no longer
exist here.
EOF
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

target_repo="$1"
delete_flag=""

if [[ "${2:-}" == "--delete" ]]; then
  delete_flag="--delete"
elif [[ "${2:-}" != "" ]]; then
  usage
  exit 1
fi

if [[ ! -d "$target_repo" ]]; then
  echo "Target repo does not exist: $target_repo" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_root="$(cd "$script_dir/.." && pwd)"
source_methodology="$source_root/methodology"
source_library="$source_root/library"
target_idd_root="$target_repo/.methodologies/idd"
target_methodology="$target_idd_root/methodology"
target_library="$target_idd_root/library"
target_workflow="$target_idd_root/workflow"
target_gitignore="$target_idd_root/.gitignore"
target_status="$target_idd_root/status.md"

if [[ ! -d "$source_methodology" ]]; then
  echo "Source directory not found: $source_methodology" >&2
  exit 1
fi

if [[ ! -d "$source_library" ]]; then
  echo "Source directory not found: $source_library" >&2
  exit 1
fi

mkdir -p "$target_methodology" "$target_library" "$target_workflow"

write_gitignore() {
  if [[ ! -f "$target_gitignore" ]]; then
    cat >"$target_gitignore" <<'EOF'
# Keep downloaded methodology assets out of version control.
/methodology/
/library/
EOF
    return
  fi

  if ! grep -Fxq "/methodology/" "$target_gitignore"; then
    printf "\n/methodology/\n" >>"$target_gitignore"
  fi
  if ! grep -Fxq "/library/" "$target_gitignore"; then
    printf "/library/\n" >>"$target_gitignore"
  fi
}

status_primary_block() {
  cat <<EOF
<!-- idd-primary-sources:start -->
### Primary sources
- Methodology source: \`$source_methodology\`
- Library source: \`$source_library\`
<!-- idd-primary-sources:end -->
EOF
}

status_permissions_block() {
  cat <<'EOF'
<!-- idd-permissions:start -->
## Permissions

Define where IDD may operate in this repo. Set this during setup, then adjust as
needed for future runs. Most specific path entries win.

### Read and write allowed
- `/`

### Read-only
- (none yet)

### No access
- (none yet)

### Guidelines
- `read and write allowed`: the agent may read and modify files in these paths.
- `read-only`: the agent may read for context but must not modify files in these paths.
- `no access`: the agent must not read or modify files in these paths.
- Use repo-relative paths when possible (for example: `docs/`, `src/`, `intents/`).
- Update this section when boundaries change; keep it current for subsequent runs.
<!-- idd-permissions:end -->
EOF
}

create_status() {
  cat >"$target_status" <<EOF
# IDD Status

## Sources

$(status_primary_block)

### Additional library sources
- (none yet)

$(status_permissions_block)
EOF
}

update_status_sources() {
  local primary_block
  local current_block
  local tmp_file
  local block_file
  primary_block="$(status_primary_block)"

  if [[ ! -f "$target_status" ]]; then
    create_status
    return
  fi

  if ! grep -Fq "<!-- idd-primary-sources:start -->" "$target_status" || \
     ! grep -Fq "<!-- idd-primary-sources:end -->" "$target_status"; then
    printf "\n## Sources\n\n%s\n" "$primary_block" >>"$target_status"
    return
  fi

  current_block="$(
    awk '
      /<!-- idd-primary-sources:start -->/ {in_block=1}
      in_block {print}
      /<!-- idd-primary-sources:end -->/ {in_block=0}
    ' "$target_status"
  )"

  if [[ "$current_block" == "$primary_block" ]]; then
    return
  fi

  tmp_file="$(mktemp)"
  block_file="$(mktemp)"
  printf "%s\n" "$primary_block" >"$block_file"

  awk -v block_path="$block_file" '
    BEGIN {in_block=0; replaced=0}
    /<!-- idd-primary-sources:start -->/ {
      if (!replaced) {
        while ((getline line < block_path) > 0) {
          print line
        }
        close(block_path)
        replaced=1
      }
      in_block=1
      next
    }
    /<!-- idd-primary-sources:end -->/ {
      in_block=0
      next
    }
    !in_block {print}
  ' "$target_status" >"$tmp_file"
  mv "$tmp_file" "$target_status"
  rm -f "$block_file"
}

ensure_status_permissions_section() {
  local permissions_block
  permissions_block="$(status_permissions_block)"

  if [[ ! -f "$target_status" ]]; then
    create_status
    return
  fi

  if grep -Fq "<!-- idd-permissions:start -->" "$target_status" && \
     grep -Fq "<!-- idd-permissions:end -->" "$target_status"; then
    return
  fi

  if grep -Eq '^## Permissions$' "$target_status"; then
    return
  fi

  printf "\n%s\n" "$permissions_block" >>"$target_status"
}

if command -v rsync >/dev/null 2>&1; then
  rsync_args=(-a)
  if [[ -n "$delete_flag" ]]; then
    rsync_args+=(--delete)
  fi

  rsync "${rsync_args[@]}" "$source_methodology"/ "$target_methodology"/
  rsync "${rsync_args[@]}" "$source_library"/ "$target_library"/
else
  if [[ -n "$delete_flag" ]]; then
    echo "Error: --delete requires rsync." >&2
    exit 1
  fi
  cp -R "$source_methodology"/. "$target_methodology"/
  cp -R "$source_library"/. "$target_library"/
fi

write_gitignore
update_status_sources
ensure_status_permissions_section
