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
echo "body<<EOF" >> "$GITHUB_OUTPUT"
echo "$body" >> "$GITHUB_OUTPUT"
echo "EOF" >> "$GITHUB_OUTPUT"
