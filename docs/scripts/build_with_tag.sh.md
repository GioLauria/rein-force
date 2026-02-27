<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# scripts/build_with_tag.sh / scripts/build_with_tag.bat

- **Location:** `scripts/build_with_tag.sh` and `scripts/build_with_tag.bat`
- **Purpose:** Build the project with a `revision` property set to the most recent tag (or short commit SHA), so artifacts can embed the revision.
- **Usage:**

```bash
./scripts/build_with_tag.sh
```

- **Notes:**
  - Script determines a tag via `git describe --tags --abbrev=0` or falls back to `git rev-parse --short HEAD`.
  - Invokes the Maven wrapper from repository root and passes `-Drevision=<tag>`.
