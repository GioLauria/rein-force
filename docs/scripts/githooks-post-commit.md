<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# .githooks/post-commit

- **Location:** .githooks/post-commit (POSIX) and `.githooks/post-commit.cmd` (Windows)
- **Purpose:** Run the `post_commit_update_changelog` updater to add the latest commit to `CHANGELOG.md` under `## [Unreleased]`.
- **Usage:** Enabled by setting `git config core.hooksPath .githooks`.
- **Notes:** The Windows wrapper calls the PowerShell updater; POSIX wrapper calls the shell updater.
