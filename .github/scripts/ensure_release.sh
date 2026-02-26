#!/usr/bin/env bash
set -euo pipefail

TAG=${1:-${GITHUB_REF_NAME:-unknown}}
REPO=${2:-${GITHUB_REPOSITORY:-unknown}}

echo "ensure_release: tag=$TAG repo=$REPO"

# query existing release by tag
rsp=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$REPO/releases/tags/$TAG")
id=$(echo "$rsp" | jq -r .id)
upload_url=$(echo "$rsp" | jq -r .upload_url)
body=$(echo "$rsp" | jq -r .body)
if [ -z "$id" ] || [ "$id" = "null" ]; then
  echo "Release not found for tag $TAG, creating..."
  data=$(jq -n --arg tag "$TAG" --arg name "Release $TAG" --arg body "Automated build artifacts for $TAG" '{tag_name:$tag, name:$name, body:$body, draft:false, prerelease:false}')
  created=$(curl -s -X POST -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" -d "$data" "https://api.github.com/repos/$REPO/releases")
  id=$(echo "$created" | jq -r .id)
  upload_url=$(echo "$created" | jq -r .upload_url)
  body=$(echo "$created" | jq -r .body)
  if [ -z "$id" ] || [ "$id" = "null" ]; then
    echo "Failed to create release: $created" >&2
    exit 1
  fi
else
  echo "Found existing release id=$id"
fi

echo "id=$id" >> "$GITHUB_OUTPUT"
echo "upload_url=$upload_url" >> "$GITHUB_OUTPUT"
# expose release body (may contain newlines) as output
## Generate standardized release notes and ensure they are saved and set as the release body

# fetch tags/commits to ensure git history is available (best-effort)
git fetch --no-tags --depth=50 origin || true
git fetch --tags --depth=1 origin || true

# determine previous tag (most recent tag excluding current)
prev_tag=$(git for-each-ref --sort=-creatordate --format '%(refname:short)' refs/tags | grep -v "^$TAG$" | head -n1 || true)

if [ -n "$prev_tag" ]; then
  compare_url="https://github.com/$REPO/compare/$prev_tag...$TAG"
  changelog=$(git log --pretty=format:"- %s (%an)" "$prev_tag".."$TAG" --no-merges || git log -n 20 --pretty=format:"- %s (%an)")
else
  compare_url=""
  changelog=$(git log -n 50 --pretty=format:"- %s (%an)" --no-merges "$TAG" || git log -n 20 --pretty=format:"- %s (%an)")
fi

release_date=$(date -u +"%Y-%m-%d %H:%M:%SZ")

generated_notes="Release $TAG\n\nDate: $release_date\nTag: $TAG\n"
if [ -n "$prev_tag" ]; then
  generated_notes="$generated_notes\nCompare: $compare_url\n"
fi
generated_notes="$generated_notes\nChangelog:\n$changelog"

# Merge generated notes with any existing body (append existing body if present and not the default placeholder)
if [ -n "$body" ] && [ "$body" != "null" ] && [ "$body" != "Automated build artifacts for $TAG" ]; then
  merged_body="$generated_notes\n\n---\n\n$body"
else
  merged_body="$generated_notes"
fi

# Update release body on GitHub if different
if [ "$(echo "$body" | tr -d '\r')" != "$(echo "$merged_body" | tr -d '\r')" ]; then
  echo "Updating release body for release id=$id"
  patch_data=$(jq -n --arg body "$merged_body" '{body:$body}')
  updated=$(curl -s -X PATCH -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" -d "$patch_data" "https://api.github.com/repos/$REPO/releases/$id")
  body=$(echo "$updated" | jq -r .body)
fi

# write release notes file for packaging
echo "$merged_body" > release_notes.txt

# expose release body (may contain newlines) as output
echo "body<<EOF" >> "$GITHUB_OUTPUT"
echo "$body" >> "$GITHUB_OUTPUT"
echo "EOF" >> "$GITHUB_OUTPUT"
