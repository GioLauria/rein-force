# scripts/update_changelog.sh

- **Location:** scripts/update_changelog.sh
- **Purpose:** Rebuild CHANGELOG.md from Git history using Keep a Changelog format. Preserves multiline commit bodies by rendering them as blockquote lines so GitHub keeps paragraph breaks.
- **Usage:**

```bash
./scripts/update_changelog.sh
```

- **Notes:**
  - Uses tags matching `v*` to determine prior releases and writes an `## [Unreleased]` section with commits since the latest tag.
