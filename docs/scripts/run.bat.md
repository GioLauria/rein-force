# scripts/run.bat

- **Location:** scripts/run.bat
- **Purpose:** Windows script to build and run the application JAR. Supports a `detach` argument to start without blocking.
- **Usage:**

```bat
scripts\run.bat
scripts\run.bat detach
```

- **Notes:**
  - Uses `mvnw.cmd` or `mvn` as available.
  - The script now determines the revision (latest `v*` tag or short commit SHA)
    and passes it to Maven as `-Drevision=%TAG%` so the build reflects the
    repository's release revision.
  - The produced JAR under `target\` is located and executed, so the script
    no longer relies on a fixed artifact filename.
