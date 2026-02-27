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
  - On Windows the detached mode uses `javaw`.
