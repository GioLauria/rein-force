<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# scripts/tag_release.ps1

- **Location:** scripts/tag_release.ps1
- **Purpose:** PowerShell helper to create or replace an annotated tag and push it to the remote, optionally updating `CHANGELOG.md` first.
- **Usage:**

```powershell
.\scripts\tag_release.ps1 -Tag v0.0.13
```

- **Notes:**
  - Intended for Windows/PowerShell users.
  - Will run `update_changelog.ps1` before tagging.
