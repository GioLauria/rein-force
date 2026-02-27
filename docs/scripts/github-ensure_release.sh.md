# .github/scripts/ensure_release.sh

- **Location:** .github/scripts/ensure_release.sh
- **Purpose:** Ensure a GitHub release resource exists for a tag; generate/merge release notes and write `release_notes.txt` for downstream steps.
- **Usage:** (used in GitHub Actions workflows)

```bash
.github/scripts/ensure_release.sh v0.0.13
```

- **Notes:**
  - Requires `GITHUB_TOKEN` and `GITHUB_REPOSITORY` if run outside GitHub Actions.
  - Outputs `upload_url` and `body` via GitHub Actions outputs.
