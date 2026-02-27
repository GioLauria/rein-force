<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# .github/scripts/upload_release_asset.sh

- **Location:** .github/scripts/upload_release_asset.sh
- **Purpose:** Upload a release asset to a GitHub release via the `upload_url` returned by the Releases API. Used by GitHub Actions workflows.
- **Usage:**

```bash
.github/scripts/upload_release_asset.sh "$UPLOAD_URL" "path/to/asset.zip" "asset-name.zip"
```

- **Notes:**
  - Requires `GITHUB_TOKEN` set in environment.
  - Strips URI template suffix before uploading.
