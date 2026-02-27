#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <tag>"
  exit 1
fi
tag=$1

# update changelog
scripts/update_changelog.sh

# commit changelog if changed
if ! git diff --quiet -- CHANGELOG.md; then
  git add CHANGELOG.md
  git commit -m "chore(release): update CHANGELOG for $tag"
fi

# extract the changelog section for this tag to use as the annotated tag message
TMPMSG=$(mktemp)
awk -v tag="$tag" '
  # match header like: ## [tag] or ## [tag] - YYYY-MM-DD
  $0 ~ ("^## \\"\[" tag "\\]") {printing=1; next}
  /^## \[/ { if (printing) exit }
  printing { print }
' CHANGELOG.md > "$TMPMSG"

if [ ! -s "$TMPMSG" ]; then
  echo "Release $tag" > "$TMPMSG"
fi

# ensure annotated tag exists (replace if existing) using the changelog section as message
if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
  git tag -f -a "$tag" -F "$TMPMSG"
else
  git tag -a "$tag" -F "$TMPMSG"
fi

# push commit (if any) and force-update tag on remote to ensure annotated tag is used
git push || true
git push origin --force refs/tags/$tag

rm -f "$TMPMSG"
