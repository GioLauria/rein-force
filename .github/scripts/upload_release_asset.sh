#!/usr/bin/env bash
set -euo pipefail

UPLOAD_URL="$1"
ASSET_PATH="$2"
ASSET_NAME="$3"

echo "Uploading $ASSET_PATH as $ASSET_NAME to $UPLOAD_URL"

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "GITHUB_TOKEN is required" >&2
  exit 1
fi

curl -sSL -H "Authorization: Bearer $GITHUB_TOKEN" -H "Content-Type: application/zip" --data-binary @"${ASSET_PATH}" "${UPLOAD_URL}?name=${ASSET_NAME}" || {
  echo "Upload failed" >&2
  exit 1
}

echo "Upload completed: ${ASSET_NAME}"
