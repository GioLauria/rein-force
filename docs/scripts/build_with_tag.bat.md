# scripts/build_with_tag.bat

- **Location:** scripts/build_with_tag.bat
- **Purpose:** Windows batch variant of build_with_tag; same behavior on Windows.
- **Usage:**

```bat
scripts\build_with_tag.bat
```

- **Notes:**
  - Ensures `mvnw.cmd` is executed from repository root and passes `-Drevision=%TAG%`.
