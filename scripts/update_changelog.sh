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

# Determine latest tag (if any)
if [ ${#tags[@]} -gt 0 ]; then
  latest_tag=${tags[-1]}
else
  latest_tag=""
fi

# First: Unreleased section (per Keep a Changelog: Unreleased appears first)
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

# Then: released versions newest-first
if [ ${#tags[@]} -gt 0 ]; then
  for (( idx=${#tags[@]}-1; idx>=0; idx-- )); do
    t=${tags[idx]}
    # get tag date (short YYYY-MM-DD) where available
    tag_date=$(git log -1 --format=%ad --date=short "$t" 2>/dev/null || true)
    if [ -n "$tag_date" ]; then
      echo "## [$t] - $tag_date" >> "$TMP"
    else
      echo "## [$t]" >> "$TMP"
    fi
    echo "" >> "$TMP"
    if [ $idx -gt 0 ]; then
      prev=${tags[idx-1]}
      range="$prev..$t"
    else
      range="$t"
    fi
    # use full commit body (%B) and separate commits with ASCII RS (0x1E)
    raw=$(git log --pretty=format:"%B%x1e" "$range" 2>/dev/null || true)
    if [ -z "$raw" ]; then
      echo "- No changes recorded." >> "$TMP"
    else
      printf "%s" "$raw" | awk 'BEGIN{ RS = sprintf("%c", 30) }
        function trim(s){ sub(/^[ \t\r\n]+/,"",s); sub(/[ \t\r\n]+$/,"",s); return s }
        { blk = trim($0); if (blk == "") next;
          n = split(blk, lines, "\n");
          # find first non-empty line as subject
          subject=""; for(i=1;i<=n;i++){ if (lines[i] ~ /[^[:space:]]/){ subject=lines[i]; break } }
          if (subject=="") next;
          print "- " subject;
          if (n>1) {
            print "";
            for (i=2;i<=n;i++) { if (lines[i] ~ /[^[:space:]]/) print "> " lines[i]; else print "> " }
            print "";
          }
        }' >> "$TMP"
    fi
    echo "" >> "$TMP"
  done
fi

mv "$TMP" "$OUT"
echo "Updated $OUT"
