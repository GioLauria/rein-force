#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"
OUT=CHANGELOG.md
TMP=$(mktemp)

cat > "$TMP" <<'EOF'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to Semantic
Versioning.

EOF

tags=( $(git tag --list 'v*' --sort=version:refname) )

latest_tag=""
if [ ${#tags[@]} -gt 0 ]; then
  latest_tag=${tags[-1]}
fi

echo "## [Unreleased]" >> "$TMP"
echo "" >> "$TMP"
if [ -n "$latest_tag" ]; then
  # commits since latest tag
  commits=$(git log --pretty=format:%s "$latest_tag..HEAD")
else
  commits=$(git log --pretty=format:%s --reverse HEAD || true)
fi

if [ -z "$commits" ]; then
  echo "- Placeholder for upcoming changes." >> "$TMP"
else
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    echo "- $line" >> "$TMP"
  done <<< "$commits"
fi

echo "" >> "$TMP"

# list tags newest first
for (( idx=${#tags[@]}-1; idx>=0; idx-- )); do
  t=${tags[idx]}
  echo "## [$t]" >> "$TMP"
  echo "" >> "$TMP"
  if [ $idx -gt 0 ]; then
    prev=${tags[idx-1]}
    commits=$(git log --pretty=format:%s "$prev..$t" || true)
  else
    commits=$(git log --pretty=format:%s --reverse "$t" || true)
  fi
  if [ -z "$commits" ]; then
    echo "- No changes recorded." >> "$TMP"
  else
    while IFS= read -r line; do
      [ -z "$line" ] && continue
      echo "- $line" >> "$TMP"
    done <<< "$commits"
  fi
  echo "" >> "$TMP"
done

mv "$TMP" "$OUT"
echo "Updated $OUT"
