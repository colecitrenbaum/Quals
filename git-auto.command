#!/usr/bin/env bash
# git-auto.command  — double‑click to stage all, commit, and push.
# Works from anywhere because it cd's into the script’s own folder
# (assumed to be your repo root).

set -euo pipefail

# Jump to the directory containing this script.
cd "$(dirname "$0")"

# Confirm we’re inside a Git repo.
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "⚠️  The folder $(pwd) is not a Git repository (no .git directory)."
  echo "   Move git-auto.command into your repo’s root, or pass a path:"
  echo "     ./git-auto.command /path/to/repo [commit‑msg]"
  exit 1
fi

# If first arg is a directory, treat it as repo path and shift.
if [[ -d "${1-}" && -d "${1}/.git" ]]; then
  cd "$1"
  shift
fi

# Use remaining argument as the commit message, or timestamp by default.
commit_msg="${1:-Auto commit $(date '+%Y-%m-%d %H:%M:%S')}"

git add -A

if ! git diff --cached --quiet; then
  git commit -m "$commit_msg"
  echo "✅ Committed with message: $commit_msg"
else
  echo "ℹ️  Nothing to commit — working tree clean."
fi

git push -u origin main
