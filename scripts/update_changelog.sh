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

# If we have tags, list them newest-first so the top-most tag is the
# latest pushed tag. We'll then add an Unreleased section showing commits
# since the latest tag.
if [ ${#tags[@]} -gt 0 ]; then
  for (( idx=${#tags[@]}-1; idx>=0; idx-- )); do
    t=${tags[idx]}
    echo "## [$t]" >> "$TMP"
    echo "" >> "$TMP"
    if [ $idx -gt 0 ]; then
      prev=${tags[idx-1]}
      range="$prev..$t"
    else
      range="$t"
    fi
    # use full commit body (%B) and separate commits by a sentinel
    commits=$(git log --pretty=format:%B"<<COMMIT>>" "$range" || true)
    if [ -z "$commits" ]; then
      echo "- No changes recorded." >> "$TMP"
    else
      IFS='<<COMMIT>>'
      for block in $commits; do
        # trim leading/trailing whitespace
        block=$(echo "$block" | sed -e 's/^\s\+//' -e 's/\s\+$//')
        [ -z "$block" ] && continue
        # first non-empty line is the subject
        subject=$(echo "$block" | awk 'NF{print; exit}')
        echo "- $subject" >> "$TMP"
        # remaining lines as blockquote to preserve paragraphs in GitHub
        body=$(echo "$block" | sed -n '2,$p' | sed -e 's/^/> /')
        if [ -n "$(echo "$body" | sed -e '/^> \s*$/d')" ]; then
          echo "" >> "$TMP"
          printf "%s\n" "$body" >> "$TMP"
          echo "" >> "$TMP"
        fi
      done
      unset IFS
    fi
    echo "" >> "$TMP"
  done
  latest_tag=${tags[-1]}
else
  latest_tag=""
fi

# Now add the Unreleased section (commits since the latest tag). This keeps
# the latest tag visible at the top of the file as requested.
echo "## [Unreleased]" >> "$TMP"
echo "" >> "$TMP"
if [ -n "$latest_tag" ]; then
  range="$latest_tag..HEAD"
else
  range="HEAD"
fi
commits=$(git log --pretty=format:%B"<<COMMIT>>" "$range" || true)
if [ -z "$commits" ]; then
  echo "- Placeholder for upcoming changes." >> "$TMP"
else
  IFS='<<COMMIT>>'
  for block in $commits; do
    block=$(echo "$block" | sed -e 's/^\s\+//' -e 's/\s\+$//')
    [ -z "$block" ] && continue
    subject=$(echo "$block" | awk 'NF{print; exit}')
    echo "- $subject" >> "$TMP"
    body=$(echo "$block" | sed -n '2,$p' | sed -e 's/^/> /')
    if [ -n "$(echo "$body" | sed -e '/^> \s*$/d')" ]; then
      echo "" >> "$TMP"
      printf "%s\n" "$body" >> "$TMP"
      echo "" >> "$TMP"
    fi
  done
  unset IFS
fi

echo "" >> "$TMP"

mv "$TMP" "$OUT"
echo "Updated $OUT"
