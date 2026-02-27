<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# .github/scripts/build_release.ps1

- **Location:** .github/scripts/build_release.ps1
- **Purpose:** PowerShell variant of the release builder for Windows runners.
- **Usage:**

```powershell
.github\scripts\build_release.ps1 -Tag v0.0.13
```

- **Notes:**
  - Ensures artifacts and `release_notes.txt` are written for later steps.
