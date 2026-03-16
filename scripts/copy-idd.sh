#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF' >&2
Usage: copy-idd.sh <target-repo-path> [--delete] [--scope <entire-repo|selected-paths>] [--scope-path <repo-relative-path> ...]

Copies this repo's methodology/ and library/ into the target repo's
.methodologies/idd/ folder.

Use --delete to remove files in target methodology/library folders that no longer
exist here.

Scope options:
- --scope entire-repo: apply IDD across the whole repo.
- --scope selected-paths --scope-path <path> [...]: apply IDD only within
  selected repo-relative paths.
- If scope options are omitted, status.md is initialized with setup placeholders.
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

target_repo="$1"
shift
delete_flag=""
scope_mode=""
scope_input_provided=0
declare -a scope_paths=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --delete)
      delete_flag="--delete"
      shift
      ;;
    --scope)
      if [[ $# -lt 2 ]]; then
        echo "Error: --scope requires a value." >&2
        usage
        exit 1
      fi
      scope_mode="$2"
      scope_input_provided=1
      shift 2
      ;;
    --scope-path)
      if [[ $# -lt 2 ]]; then
        echo "Error: --scope-path requires a value." >&2
        usage
        exit 1
      fi
      scope_paths+=("$2")
      scope_input_provided=1
      shift 2
      ;;
    *)
      echo "Error: unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ "$scope_mode" != "" && "$scope_mode" != "entire-repo" && "$scope_mode" != "selected-paths" ]]; then
  echo "Error: --scope must be 'entire-repo' or 'selected-paths'." >&2
  exit 1
fi

if [[ "$scope_mode" == "" && ${#scope_paths[@]} -gt 0 ]]; then
  scope_mode="selected-paths"
fi

if [[ "$scope_mode" == "entire-repo" && ${#scope_paths[@]} -gt 0 ]]; then
  echo "Error: --scope entire-repo cannot be combined with --scope-path." >&2
  exit 1
fi

if [[ "$scope_mode" == "selected-paths" && ${#scope_paths[@]} -eq 0 ]]; then
  echo "Error: --scope selected-paths requires at least one --scope-path." >&2
  exit 1
fi

if [[ ${#scope_paths[@]} -gt 0 ]]; then
  for path in "${scope_paths[@]}"; do
    if [[ "$path" == /* ]]; then
      echo "Error: --scope-path must be repo-relative, not absolute: $path" >&2
      exit 1
    fi
  done
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
target_scratch="$target_idd_root/scratch"
target_arc="$target_scratch/arc"
target_evidence="$target_scratch/evidence"
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

mkdir -p "$target_methodology" "$target_library" "$target_scratch" "$target_arc" "$target_evidence"

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

status_scope_block() {
  local mode_line
  local roots_block

  mode_line="- (set during setup: \`entire-repo\` or \`selected-paths\`)"
  roots_block="- (set during setup)"

  if [[ "$scope_mode" == "entire-repo" ]]; then
    mode_line="- \`entire-repo\`"
    roots_block="- \`.\`"
  elif [[ "$scope_mode" == "selected-paths" ]]; then
    mode_line="- \`selected-paths\`"
    roots_block=""
    for path in "${scope_paths[@]}"; do
      roots_block+="- \`$path\`"$'\n'
    done
    roots_block="${roots_block%$'\n'}"
  fi

  cat <<EOF
<!-- idd-operating-scope:start -->
## Operating scope

Define where IDD is intended to run for this install. Capture this during setup
from user input. This is the intended scope boundary; \`Permissions\` remains
the hard read/write enforcement boundary.

### Mode
$mode_line

### In-scope roots
$roots_block

### Guidelines
- Use repo-relative paths.
- \`entire-repo\` means IDD may be applied anywhere in the repo.
- \`selected-paths\` means IDD should run only inside listed folders or files
  unless scope is explicitly expanded and approved.
- Update this section when operating scope changes.
<!-- idd-operating-scope:end -->
EOF
}

status_permissions_block() {
  cat <<'EOF'
<!-- idd-permissions:start -->
## Permissions

Define where IDD may operate in this repo. Set this during setup, then adjust as
needed for future runs. Permissions are hard boundaries and should align with
`Operating scope`. Most specific path entries win.

### Read and write allowed
- (none)

### Read-only
- (none)

### No access
- (none)

### Guidelines
- `read and write allowed`: the agent may read and modify files in these paths.
- `read-only`: the agent may read for context but must not modify files in these paths.
- `no access`: the agent must not read or modify files in these paths.
- Use repo-relative paths when possible (for example: `docs/`, `src/`, `intents/`).
- If a path is not listed in a permission bucket, treat it as `no access`.
- Reads and writes outside `Operating scope` are disallowed even if a
  permission entry exists.
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

$(status_scope_block)

$(status_permissions_block)
EOF
}

normalize_sources_without_markers() {
  local tmp_file
  local block_file
  tmp_file="$(mktemp)"
  block_file="$(mktemp)"
  status_primary_block >"$block_file"

  awk -v block_path="$block_file" '
    function print_primary_block(line) {
      while ((getline line < block_path) > 0) {
        print line
      }
      close(block_path)
    }
    BEGIN {
      in_sources=0
      saw_sources=0
      saw_additional=0
    }
    /^## Sources$/ {
      saw_sources=1
      in_sources=1
      print "## Sources"
      print ""
      print_primary_block()
      print ""
      next
    }
    in_sources && /^## / {
      if (!saw_additional) {
        print "### Additional library sources"
        print "- (none yet)"
        print ""
      }
      in_sources=0
    }
    in_sources {
      if ($0 ~ /^<!-- idd-primary-sources:start -->/) next
      if ($0 ~ /^<!-- idd-primary-sources:end -->/) next
      if ($0 ~ /^### Primary sources$/) next
      if ($0 ~ /^- Methodology source:/) next
      if ($0 ~ /^- Library source:/) next
      if ($0 ~ /^- Primary methodology source path:/) next
      if ($0 ~ /^- Primary library source path:/) next
      if ($0 ~ /^- Additional library sources:/) next
      if ($0 ~ /^### Additional library sources$/) saw_additional=1
      print
      next
    }
    { print }
    END {
      if (in_sources && !saw_additional) {
        print "### Additional library sources"
        print "- (none yet)"
      }
      if (!saw_sources) {
        print ""
        print "## Sources"
        print ""
        print_primary_block()
        print ""
        print "### Additional library sources"
        print "- (none yet)"
      }
    }
  ' "$target_status" >"$tmp_file"

  mv "$tmp_file" "$target_status"
  rm -f "$block_file"
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
    normalize_sources_without_markers
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

normalize_scope_without_markers() {
  local tmp_file
  local block_file
  tmp_file="$(mktemp)"
  block_file="$(mktemp)"
  status_scope_block >"$block_file"

  awk -v block_path="$block_file" '
    function print_scope_block(line) {
      while ((getline line < block_path) > 0) {
        print line
      }
      close(block_path)
    }
    BEGIN {
      in_scope=0
      inserted=0
    }
    /^## Operating scope$/ {
      if (!inserted) {
        print_scope_block()
        print ""
        inserted=1
      }
      in_scope=1
      next
    }
    in_scope && /^## / {
      in_scope=0
    }
    in_scope {
      if ($0 ~ /^<!-- idd-operating-scope:start -->/) next
      if ($0 ~ /^<!-- idd-operating-scope:end -->/) next
      next
    }
    /^## Permissions$/ {
      if (!inserted) {
        print_scope_block()
        print ""
        inserted=1
      }
      print
      next
    }
    { print }
    END {
      if (!inserted) {
        print ""
        print_scope_block()
      }
    }
  ' "$target_status" >"$tmp_file"

  mv "$tmp_file" "$target_status"
  rm -f "$block_file"
}

update_status_scope() {
  local scope_block
  local current_block
  local tmp_file
  local block_file
  scope_block="$(status_scope_block)"

  if [[ ! -f "$target_status" ]]; then
    create_status
    return
  fi

  if ! grep -Fq "<!-- idd-operating-scope:start -->" "$target_status" || \
     ! grep -Fq "<!-- idd-operating-scope:end -->" "$target_status"; then
    if [[ "$scope_input_provided" == "0" ]] && grep -Eq '^## Operating scope$' "$target_status"; then
      return
    fi
    normalize_scope_without_markers
    return
  fi

  if [[ "$scope_input_provided" == "0" ]]; then
    return
  fi

  current_block="$(
    awk '
      /<!-- idd-operating-scope:start -->/ {in_block=1}
      in_block {print}
      /<!-- idd-operating-scope:end -->/ {in_block=0}
    ' "$target_status"
  )"

  if [[ "$current_block" == "$scope_block" ]]; then
    return
  fi

  tmp_file="$(mktemp)"
  block_file="$(mktemp)"
  printf "%s\n" "$scope_block" >"$block_file"

  awk -v block_path="$block_file" '
    BEGIN {in_block=0; replaced=0}
    /<!-- idd-operating-scope:start -->/ {
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
    /<!-- idd-operating-scope:end -->/ {
      in_block=0
      next
    }
    !in_block {print}
  ' "$target_status" >"$tmp_file"

  mv "$tmp_file" "$target_status"
  rm -f "$block_file"
}

missing_permissions_buckets_block() {
  local include_rw include_ro include_na
  include_rw="$1"
  include_ro="$2"
  include_na="$3"

  if [[ "$include_rw" == "1" ]]; then
    cat <<'EOF'
### Read and write allowed
- (none)

EOF
  fi

  if [[ "$include_ro" == "1" ]]; then
    cat <<'EOF'
### Read-only
- (none)

EOF
  fi

  if [[ "$include_na" == "1" ]]; then
    cat <<'EOF'
### No access
- (none)

EOF
  fi
}

append_to_permissions_section() {
  local block="$1"
  local tmp_file
  local block_file

  tmp_file="$(mktemp)"
  block_file="$(mktemp)"
  printf "%s" "$block" >"$block_file"

  awk -v block_path="$block_file" '
    function print_block(line) {
      while ((getline line < block_path) > 0) {
        print line
      }
      close(block_path)
    }
    BEGIN {in_permissions=0; inserted=0}
    /^## Permissions$/ {in_permissions=1; print; next}
    in_permissions && /^## / {
      if (!inserted) {
        print ""
        print_block()
        inserted=1
      }
      in_permissions=0
      print
      next
    }
    { print }
    END {
      if (in_permissions && !inserted) {
        print ""
        print_block()
      }
    }
  ' "$target_status" >"$tmp_file"

  mv "$tmp_file" "$target_status"
  rm -f "$block_file"
}

ensure_status_permissions_section() {
  local permissions_block
  local add_rw
  local add_ro
  local add_na
  local missing_block
  permissions_block="$(status_permissions_block)"

  if [[ ! -f "$target_status" ]]; then
    create_status
    return
  fi

  if ! grep -Eq '^## Permissions$' "$target_status"; then
    printf "\n%s\n" "$permissions_block" >>"$target_status"
    return
  fi

  add_rw=0
  add_ro=0
  add_na=0

  if ! grep -Eq '^### Read and write allowed$' "$target_status"; then
    add_rw=1
  fi
  if ! grep -Eq '^### Read-only$' "$target_status"; then
    add_ro=1
  fi
  if ! grep -Eq '^### No access$' "$target_status"; then
    add_na=1
  fi

  if [[ "$add_rw" == "0" && "$add_ro" == "0" && "$add_na" == "0" ]]; then
    return
  fi

  missing_block="$(missing_permissions_buckets_block "$add_rw" "$add_ro" "$add_na")"
  append_to_permissions_section "$missing_block"
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
update_status_scope
ensure_status_permissions_section
