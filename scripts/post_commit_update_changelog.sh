#!/bin/sh
# Append the most recent commit message to CHANGELOG.md under the
# "## [Unreleased]" header in a Keep a Changelog-friendly style.
set -eu
repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"
if [ ! -f CHANGELOG.md ]; then
  exit 0
fi
hash=$(git rev-parse --short HEAD)
# avoid duplicates
if grep -q "$hash" CHANGELOG.md; then
  exit 0
fi
title=$(git log -1 --pretty=format:%s)
body=$(git log -1 --pretty=format:%b)
entry_file=$(mktemp)
printf "%s (%s)\n\n" "$title" "$hash" > "$entry_file"
if [ -n "$body" ]; then
  printf "%s\n" "$body" | sed 's/^/> /' >> "$entry_file"
  printf "\n" >> "$entry_file"
fi
awk -v f="$entry_file" '{
  print
  if(!inserted && $0 ~ /^## \[Unreleased\]/){
    print ""
    system("cat " f)
    inserted=1
  }
}' CHANGELOG.md > CHANGELOG.new
mv CHANGELOG.new CHANGELOG.md
rm -f "$entry_file"
git add CHANGELOG.md
git commit -m "chore(changelog): add ${hash} to Unreleased" || true
