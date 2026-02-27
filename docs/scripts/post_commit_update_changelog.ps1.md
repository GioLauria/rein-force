<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# scripts/post_commit_update_changelog.ps1

- **Location:** scripts/post_commit_update_changelog.ps1
- **Purpose:** PowerShell version of the post-commit updater that appends the last commit message into `CHANGELOG.md` under `## [Unreleased]`.
- **Usage:**

```powershell
.\scripts\post_commit_update_changelog.ps1
```

- **Notes:**
  - Intended to be used by the `.githooks/post-commit.cmd` wrapper on Windows.
  - Best-effort: failures are non-fatal to commits.
