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

# ensure annotated tag exists (replace if existing)
if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
  git tag -f -a "$tag" -m "Release $tag"
else
  git tag -a "$tag" -m "Release $tag"
fi

# push commit (if any) and force-update tag on remote to ensure annotated tag is used
git push || true
git push origin --force refs/tags/$tag
