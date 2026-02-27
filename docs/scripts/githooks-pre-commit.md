# .githooks/pre-commit

- **Location:** .githooks/pre-commit (POSIX) and `.githooks/pre-commit.cmd` (Windows)
- **Purpose:** Run a project build before allowing commits. Ensures commits don't introduce build regressions.
- **Behavior:** Executes the Maven wrapper (`./mvnw` or `mvnw.cmd`) and runs `package`.
- **Notes:** Heavy-weight for frequent commits; intended as an optional safety net. Set `git config core.hooksPath .githooks` to enable.
