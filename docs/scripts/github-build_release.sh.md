<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# .github/scripts/build_release.sh

- **Location:** .github/scripts/build_release.sh
- **Purpose:** Produce a runnable release image (Linux) and package it for upload. Uses `jlink` to create a runtime image and zips the package.
- **Usage:**

```bash
.github/scripts/build_release.sh v0.0.13
```

- **Notes:**
  - Requires `JAVA_HOME` for `jlink`.
  - Produces `release/rein-force-<tag>-linux.zip` and `release_notes.txt`.
