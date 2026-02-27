<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# scripts/update_changelog.ps1

- **Location:** scripts/update_changelog.ps1
- **Purpose:** PowerShell implementation of `update_changelog.sh`. Generates `CHANGELOG.md` following Keep a Changelog and includes commit subjects. Writen for Windows/PowerShell environments.
- **Usage:**

```powershell
.\	emplates\scripts\update_changelog.ps1
```

- **Notes:**
  - Designed to be run under PowerShell. Writes `CHANGELOG.md` in repository root.
