#!/usr/bin/env bash
# Stop hook: when this branch changed meaningful project files but CLAUDE.md
# was not updated, block the stop once and remind Claude to update CLAUDE.md.
#
# Loop-safe: it only ever blocks once per stop (guarded by stop_hook_active),
# and it always exits 0 so a failure here never breaks the session.

input="$(cat 2>/dev/null || true)"

# Loop guard: if we already blocked once for this stop, allow the stop.
if command -v jq >/dev/null 2>&1; then
  active="$(printf '%s' "$input" | jq -r '.stop_hook_active // false' 2>/dev/null || echo false)"
  [ "$active" = "true" ] && exit 0
fi

# Operate from the repo root; if we're not in a git repo, do nothing.
root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$root" ] && exit 0
cd "$root" 2>/dev/null || exit 0

# Files changed on this branch = committed vs the default-branch base, plus any
# uncommitted working-tree changes.
base="$(git merge-base origin/main HEAD 2>/dev/null || true)"
changed="$(
  {
    [ -n "$base" ] && git diff --name-only "$base" HEAD 2>/dev/null
    git status --porcelain=1 2>/dev/null | awk '{print $NF}'
  } | sort -u | sed '/^$/d'
)"

# Nothing changed, or CLAUDE.md is already among the changes → allow stop.
[ -z "$changed" ] && exit 0
printf '%s\n' "$changed" | grep -qx 'CLAUDE.md' && exit 0

# Ignore generated/lockfile noise — only remind for real project files.
meaningful="$(printf '%s\n' "$changed" \
  | grep -vE '^(package-lock\.json|Gemfile\.lock|_site/|\.lighthouseci/|node_modules/|vendor/)' || true)"
[ -z "$meaningful" ] && exit 0

list="$(printf '%s\n' "$meaningful" | sed 's/^/  - /')"
reason="This branch changed project files but CLAUDE.md was not updated:
${list}

Per the project rule, if any of this changes what a future session should know
(key facts, conventions, build/deploy, gotchas, or TODOs), update CLAUDE.md now
and include it in the same commit/PR. If the change is trivial and does not
affect project context, you may stop."

if command -v jq >/dev/null 2>&1; then
  jq -n --arg r "$reason" '{decision:"block", reason:$r}'
else
  printf '{"decision":"block","reason":"Project files changed but CLAUDE.md was not updated. Update CLAUDE.md if this affects project context, otherwise you may stop."}'
fi
exit 0
