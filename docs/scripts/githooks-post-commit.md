<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# .githooks/post-commit

- **Location:** .githooks/post-commit (POSIX) and `.githooks/post-commit.cmd` (Windows)
- **Purpose:** Run the `post_commit_update_changelog` updater to add the latest commit to `CHANGELOG.md` under `## [Unreleased]`.
- **Usage:** Enabled by setting `git config core.hooksPath .githooks`.
- **Local install:** For convenience the repository also installs a copy of the hook into `.git/hooks/post-commit` so the hook works out-of-the-box for local clones. The installed hook simply runs `scripts/post_commit_update_changelog.sh`.
- **Notes:** The Windows wrapper calls the PowerShell updater; POSIX wrapper calls the shell updater. The updater now automatically commits `CHANGELOG.md` after inserting the latest commit under `## [Unreleased]`.

## Installing / enabling hooks

- Recommended (repo-managed hooks):

	- Run:

		```bash
		git config core.hooksPath .githooks
		```

	- Ensure `.githooks/post-commit` (POSIX) and `.githooks/post-commit.cmd` (Windows) are executable.

- Local (one-off):

	- The repository already writes a helper into `.git/hooks/post-commit` during development. If you need to reinstall it manually, run:

		```bash
		cp scripts/post_commit_update_changelog.sh .git/hooks/post-commit
		chmod +x .git/hooks/post-commit
		```

