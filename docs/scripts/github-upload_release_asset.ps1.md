# .github/scripts/upload_release_asset.ps1

- **Location:** .github/scripts/upload_release_asset.ps1
- **Purpose:** PowerShell counterpart to upload a release asset to a GitHub release. Used in Windows runners.
- **Usage:**

```powershell
.github\scripts\upload_release_asset.ps1 -UploadUrl $uploadUrl -AssetPath "path\to\asset.zip" -AssetName "asset.zip"
```

- **Notes:**
  - Requires `GITHUB_TOKEN` in environment.
