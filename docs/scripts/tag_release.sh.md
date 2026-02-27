<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# scripts/tag_release.sh

- **Location:** scripts/tag_release.sh
- **Purpose:** Create (or replace) an annotated tag using the `CHANGELOG.md` section for the given tag as the tag message. Commits the changelog if it changed and pushes the annotated tag (force push).
- **Usage:**

```bash
./scripts/tag_release.sh v0.0.13
```

- **Notes:**
  - Extracts `## [<tag>]` section from `CHANGELOG.md` and uses it as the annotated tag message (via `-F`).
  - Will force-push the tag to `origin`.
