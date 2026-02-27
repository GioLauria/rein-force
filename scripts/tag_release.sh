#!/usr/bin/env bash
set -euo pipefail

SKIP_PUSH=0
SKIP_COMMIT=0
# parse options (allow any order)
while [ "$#" -gt 0 ] && [ "${1#-}" != "$1" ]; do
  case "$1" in
    --no-push)
      SKIP_PUSH=1; shift ;;
    --no-commit)
      SKIP_COMMIT=1; shift ;;
    --help|-h)
      echo "Usage: $0 [--no-push] [--no-commit] <tag>"; exit 0 ;;
    *)
      echo "Unknown option: $1"; echo "Usage: $0 [--no-push] [--no-commit] <tag>"; exit 1 ;;
  esac
done
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 [--no-push] [--no-commit] <tag>"
  exit 1
fi
tag=$1

# update changelog
scripts/update_changelog.sh

# commit changelog if changed
if ! git diff --quiet -- CHANGELOG.md; then
  git add CHANGELOG.md
  if [ "$SKIP_COMMIT" -eq 1 ]; then
    echo "SKIP_COMMIT enabled: staged CHANGELOG.md but not committing."
  else
    if ! git commit -m "chore(release): update CHANGELOG for $tag"; then
      echo "Warning: git commit failed (update CHANGELOG). Continuing without committing."
    fi
  fi
fi
# Move Unreleased -> tag section, create empty Unreleased, and commit changelog
TMP_UNRELEASED=$(mktemp)
# Prefer perl for robust multiline extraction, fall back to sed if perl missing
if command -v perl >/dev/null 2>&1; then
  perl -0777 -ne 'if (/^## \[Unreleased\]\s*\n(.*?)(?=\n## \[|$)/ms) { print $1 }' CHANGELOG.md > "$TMP_UNRELEASED"
else
  # sed: print lines between the Unreleased header and the next header (exclude headers)
  sed -n '/^## \[Unreleased\]/,/^## \[/ {/^## \[Unreleased\]/d;/^## \[/q;p}' CHANGELOG.md > "$TMP_UNRELEASED"
fi

# prepare tag section content
if [ -s "$TMP_UNRELEASED" ]; then
  DATE=$(date +%Y-%m-%d)
  TMPMSG=$(mktemp)
  echo "## [$tag] - $DATE" > "$TMPMSG"
  echo "" >> "$TMPMSG"
  cat "$TMP_UNRELEASED" >> "$TMPMSG"
else
  TMPMSG=$(mktemp)
  echo "Release $tag" > "$TMPMSG"
fi

# rebuild CHANGELOG: replace Unreleased block with empty placeholder, and insert tag section after Unreleased header
# Rebuild CHANGELOG.md: print up to Unreleased header, then our placeholder + tag section, then the rest
CHANGELOG_NEW=$(mktemp)
# print up to and including Unreleased header
sed -n '1,/^## \[Unreleased\]/p' CHANGELOG.md > "$CHANGELOG_NEW"
echo "" >> "$CHANGELOG_NEW"
echo "- Placeholder for upcoming changes." >> "$CHANGELOG_NEW"
echo "" >> "$CHANGELOG_NEW"
cat "$TMPMSG" >> "$CHANGELOG_NEW"
echo "" >> "$CHANGELOG_NEW"
# find the line number of the next header after Unreleased
start=$(awk '/^## \[Unreleased\]/ {found=1; next} found && /^## \[/ {print NR; exit}' CHANGELOG.md || true)
if [ -n "$start" ]; then
  tail -n +"$start" CHANGELOG.md >> "$CHANGELOG_NEW"
fi
mv "$CHANGELOG_NEW" CHANGELOG.md

rm -f "$TMP_UNRELEASED"

# commit changelog if changed
if ! git diff --quiet -- CHANGELOG.md; then
  git add CHANGELOG.md
  if [ "$SKIP_COMMIT" -eq 1 ]; then
    echo "SKIP_COMMIT enabled: staged CHANGELOG.md but not committing (move Unreleased -> $tag)."
  else
    if ! git commit -m "chore(release): move Unreleased -> $tag and clear Unreleased"; then
      echo "Warning: git commit failed (move Unreleased -> $tag). Continuing without committing."
    fi
  fi
fi

# ensure annotated tag exists (replace if existing) using the prepared tag message
if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
  git tag -f -a "$tag" -F "$TMPMSG"
else
  git tag -a "$tag" -F "$TMPMSG"
fi

# push commit (if any) and force-update tag on remote
if [ "$SKIP_PUSH" -eq 1 ]; then
  echo "Skipping git push (local-only mode)."
else
  git push || true
  git push origin --force refs/tags/$tag || true
fi

rm -f "$TMPMSG"
