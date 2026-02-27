# scripts/run.sh / scripts/run.bat

- **Location:** `scripts/run.sh` (POSIX) and `scripts/run.bat` (Windows)
- **Purpose:** Build the project (using the Maven wrapper if available) and run the application JAR. Optional `detach` argument starts the app in background.
- **Usage (Linux/macOS):**

```bash
./scripts/run.sh
./scripts/run.sh detach
```

- **Usage (Windows):**

```bat
scripts\run.bat
scripts\run.bat detach
```

- **Notes:**
  - Uses `./mvnw` or `mvn` as available.
  - The script now determines the revision (latest `v*` tag or short commit SHA)
    and passes it to Maven as `-Drevision=<rev>` so the build reflects the
    repository's release revision.
  - The produced JAR under `target/` is located and executed, so the script
    no longer relies on a fixed artifact filename.
  - On Windows the detached mode uses `javaw`.
