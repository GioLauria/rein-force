<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# scripts/post_commit_update_changelog.sh

- **Location:** scripts/post_commit_update_changelog.sh
- **Purpose:** Run after a commit (hook) to append the latest commit subject/body to `CHANGELOG.md` under `## [Unreleased]` in Keep a Changelog friendly format.
- **Usage:**

```bash
./scripts/post_commit_update_changelog.sh
```

- **Notes:**
  - Safe no-op if `CHANGELOG.md` is missing or if the commit SHA is already recorded.
  - Designed to be invoked by `.githooks/post-commit`.
