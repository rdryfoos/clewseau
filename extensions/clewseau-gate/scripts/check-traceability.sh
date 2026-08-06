#!/usr/bin/env bash
# Clewseau Gate 2 — portable traceability check.
# Silent gaps and untraced scope fail. Tracked debt (open tasks with Traces) is allowed.
set -euo pipefail

export LC_ALL=C

EXT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# Project root: walk up from extension install path (.specify/extensions/clewseau-gate)
PROJECT_ROOT="${CLEWSEAU_PROJECT_ROOT:-}"
if [[ -z "$PROJECT_ROOT" ]]; then
  PROJECT_ROOT="$(cd "$EXT_DIR/../../.." && pwd)"
fi
cd "$PROJECT_ROOT"

CONFIG="${CLEWSEAU_CONFIG:-$EXT_DIR/clewseau-gate-config.yml}"
if [[ ! -f "$CONFIG" ]]; then
  if [[ -f "$EXT_DIR/clewseau-gate-config.template.yml" ]]; then
    CONFIG="$EXT_DIR/clewseau-gate-config.template.yml"
    echo "WARN: using template config; copy to clewseau-gate-config.yml for real projects" >&2
  else
    echo "FAIL: no clewseau-gate-config.yml (looked in $EXT_DIR)" >&2
    exit 2
  fi
fi

# Minimal YAML subset reader: key: value and simple list items under a key.
yaml_scalar() {
  local key="$1"
  awk -v k="$key" '
    $0 ~ "^"k":[[:space:]]*" {
      sub("^[^:]+:[[:space:]]*", "")
      gsub(/^"/, ""); gsub(/"$/, "")
      print
      exit
    }
  ' "$CONFIG"
}

yaml_list() {
  local key="$1"
  awk -v k="$key" '
    $0 ~ "^"k":[[:space:]]*$" { inlist=1; next }
    inlist && /^[^[:space:]-]/ { exit }
    inlist && /^[[:space:]]*-[[:space:]]*/ {
      sub(/^[[:space:]]*-[[:space:]]*/, "")
      gsub(/^"/, ""); gsub(/"$/, "")
      print
    }
  ' "$CONFIG"
}

REGISTRY="$(yaml_scalar registry)"
SPECS_GLOB="$(yaml_scalar specs)"
TASKS_GLOB="$(yaml_scalar tasks)"
ID_RE="$(yaml_scalar id_regex)"
COVERS_RE="$(yaml_scalar covers_regex)"
TEST_AC_RE="$(yaml_scalar test_ac_regex)"

[[ -n "$REGISTRY" ]] || { echo "FAIL: config missing registry" >&2; exit 2; }
[[ -n "$ID_RE" ]] || ID_RE='(FR|NFR|AC|US)-[A-Z][A-Z0-9]{1,5}-[0-9]{2,}[a-z]?'
[[ -n "$COVERS_RE" ]] || COVERS_RE='@covers\s+.*'
[[ -n "$TEST_AC_RE" ]] || TEST_AC_RE='AC_[A-Z][A-Z0-9]{1,5}_[0-9]{2,}[a-z]?'
[[ -n "$SPECS_GLOB" ]] || SPECS_GLOB='specs/**/spec.md'
[[ -n "$TASKS_GLOB" ]] || TASKS_GLOB='specs/**/tasks.md'

fail=0
err() { echo "FAIL: $*" >&2; fail=1; }

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

if [[ ! -f "$REGISTRY" ]]; then
  err "registry not found: $REGISTRY"
  exit 1
fi

grep -Eoh "$ID_RE" "$REGISTRY" | sort -u > "$tmp/registry.txt"

# Expand simple globs via find (portable; avoids bash-4 globstar/mapfile)
expand_glob() {
  local pattern="$1"
  local dir base
  if [[ "$pattern" == *\*\*/* ]]; then
    dir="${pattern%%/\*\*/*}"
    base="${pattern##*/}"
    [[ -d "$dir" ]] || return 0
    find "$dir" -type f -name "$base" 2>/dev/null
  elif [[ "$pattern" == */* ]]; then
    dir="$(dirname "$pattern")"
    base="$(basename "$pattern")"
    # dirname of "src/**" is "src" with basename "**" — treat ** as recurse-all
    if [[ "$base" == "**" ]]; then
      [[ -d "$dir" ]] || return 0
      find "$dir" -type f 2>/dev/null
      return 0
    fi
    [[ -d "$dir" ]] || return 0
    find "$dir" -type f -name "$base" 2>/dev/null
  else
    find . -type f -name "$pattern" 2>/dev/null
  fi
}

: > "$tmp/spec.txt"
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  grep -Eoh "$ID_RE" "$f" | sort -u >> "$tmp/spec.txt" || true
done < <(expand_glob "$SPECS_GLOB")
sort -u "$tmp/spec.txt" -o "$tmp/spec.txt"

: > "$tmp/tasks.txt"
: > "$tmp/pending.txt"
: > "$tmp/task_map.txt"
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  grep -Eoh "$ID_RE" "$f" | sort -u >> "$tmp/tasks.txt" || true
  grep -E '^- \[ \]' "$f" | grep -Eo "$ID_RE" | sort -u >> "$tmp/pending.txt" || true
  sed -nE 's/^- \[(x| )\] (T[0-9]+[a-z]?).*\*\*Traces\*\*: (.*)$/\1|\2|\3/p' "$f" >> "$tmp/task_map.txt" || true
done < <(expand_glob "$TASKS_GLOB")
sort -u "$tmp/tasks.txt" -o "$tmp/tasks.txt"
sort -u "$tmp/pending.txt" -o "$tmp/pending.txt"

# Source covers
: > "$tmp/covers_raw.txt"
while IFS= read -r g; do
  [[ -z "$g" ]] && continue
  while IFS= read -r f; do
    [[ -f "$f" ]] || continue
    grep -Eoh "$COVERS_RE" "$f" >> "$tmp/covers_raw.txt" || true
  done < <(expand_glob "$g")
done < <(yaml_list src_globs)

grep -Eoh "$ID_RE" "$tmp/covers_raw.txt" 2>/dev/null | sort -u > "$tmp/covers.txt" || true

# Test-encoded ACs
: > "$tmp/test_names.txt"
while IFS= read -r g; do
  [[ -z "$g" ]] && continue
  while IFS= read -r f; do
    [[ -f "$f" ]] || continue
    grep -Eoh "$TEST_AC_RE" "$f" >> "$tmp/test_names.txt" || true
  done < <(expand_glob "$g")
done < <(yaml_list test_globs)

tr '_' '-' < "$tmp/test_names.txt" | sort -u > "$tmp/test_acs.txt" || true

# 1) Spec / tasks IDs must be subset of registry
while IFS= read -r id; do
  [[ -z "$id" ]] && continue
  grep -qx "$id" "$tmp/registry.txt" || err "spec references ID not in registry: $id"
done < "$tmp/spec.txt"

while IFS= read -r id; do
  [[ -z "$id" ]] && continue
  grep -qx "$id" "$tmp/registry.txt" || err "tasks reference ID not in registry: $id"
done < "$tmp/tasks.txt"

# 2) Every task with a checkbox should have Traces (best-effort: lines matching task bullets)
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  while IFS= read -r line; do
    if [[ "$line" =~ ^-\ \[[x\ ]\]\ T ]]; then
      if ! grep -Eq '\*\*Traces\*\*:' <<<"$line"; then
        err "task missing Traces field: ${line:0:80}"
      fi
    fi
  done < "$f"
done < <(expand_glob "$TASKS_GLOB")

# 3) Untraced scope: covers / test ACs must be in registry
while IFS= read -r id; do
  [[ -z "$id" ]] && continue
  grep -qx "$id" "$tmp/registry.txt" || err "untraced scope (@covers): $id not in registry"
done < "$tmp/covers.txt"

while IFS= read -r id; do
  [[ -z "$id" ]] && continue
  grep -qx "$id" "$tmp/registry.txt" || err "untraced scope (test name): $id not in registry"
done < "$tmp/test_acs.txt"

# 4) Silent gaps: every AC in registry needs a test OR an open (unchecked) task
while IFS= read -r id; do
  [[ -z "$id" ]] && continue
  [[ "${id%%-*}" == "AC" ]] || continue
  if grep -qx "$id" "$tmp/test_acs.txt"; then
    continue
  fi
  if grep -qx "$id" "$tmp/pending.txt"; then
    continue
  fi
  err "silent gap: $id has no test and no open tracked-debt task"
done < "$tmp/registry.txt"

if [[ "$fail" -ne 0 ]]; then
  echo "Clewseau Gate 2: FAILED" >&2
  exit 1
fi

echo "Clewseau Gate 2: OK ($(wc -l < "$tmp/registry.txt" | tr -d ' ') registry IDs)"
