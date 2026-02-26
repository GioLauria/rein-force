#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <tag>"
  exit 1
fi
tag=$1

# update changelog
scripts/update_changelog.sh

# commit changelog
git add CHANGELOG.md
git commit -m "chore(release): update CHANGELOG for $tag"

# create annotated tag and push commit+tag
git tag -a "$tag" -m "Release $tag"
git push
git push origin "$tag"
