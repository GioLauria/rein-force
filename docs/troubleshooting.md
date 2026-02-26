```markdown
# Troubleshooting

This page collects common problems and quick fixes contributors may encounter.

## Maven Wrapper: "JAVA_HOME not found"
- Cause: the wrapper needs `JAVA_HOME` pointing to a JDK installation.
- Quick fix (session):
  - PowerShell: `$env:JAVA_HOME = 'C:\Program Files\Java\jdk-XX'`
  - macOS / Linux: `export JAVA_HOME="/path/to/jdk"`
- Persist: use `setx` on Windows or add `export` to your shell profile on Unix.

## `mvnw` / permission issues on Unix
- If `./mvnw` is not executable: `chmod +x mvnw`.

## Build failures
- Re-run with debug for details: `./mvnw -e clean package` or `./mvnw -X package`.
- Clean and force-update dependencies: `./mvnw -U clean package`.
- If tests fail, inspect `target/surefire-reports/` for the failing test output.

## Tests failing locally but not in CI
- Ensure you run the same JDK as CI; check `java -version` and `./mvnw -v`.
- Run a single test to inspect: `./mvnw -Dtest=MyTest test`.

## JAR won't run or UI doesn't show
- Run: `java -jar target/rein-force-sim-0.1.0.jar`.
- If headless environment (remote server), the Swing GUI will not display — run locally with a display.

## GUI stats incorrect or missing
- If the overlay showing Iterations / Average duration / Last duration does not appear or shows unexpected values:
  - Ensure the application actually started (check console or process list).
  - Verify there are no exceptions in the application's console output — timing metrics are updated on successful iterations.
  - If running in a headless or remote environment, the Swing UI (and overlay) will not render — run locally with a display.
  - For intermittent or unexpected long durations, run the simulator under a profiler or check for GC pauses or heavy I/O.

## Running detached (background)
- Windows PowerShell: use `Start-Process` to launch the JAR in a new process and return immediately:

```powershell
Start-Process -FilePath 'java' -ArgumentList '-jar','target\\rein-force-sim-0.1.0.jar' -PassThru
```

- Windows CMD: `start javaw -jar target\rein-force-sim-0.1.0.jar` uses `javaw` to avoid a console window.

- macOS / Linux: use `nohup` and background the process:

```bash
nohup java -jar target/rein-force-sim-0.1.0.jar > /dev/null 2>&1 &
disown
```

After starting detached, find the process and stop it when needed:

- Windows (PowerShell): `Get-Process | Where-Object {$_.ProcessName -match "java"}` then `Stop-Process -Id <PID>`
- macOS / Linux: `ps aux | grep rein-force-sim` then `kill <PID>`

## Windows: file locked / failed to delete target files
- Symptom: `Failed to delete ... target/test-classes ...` during `mvn clean`.
- Fixes:
  - Close running Java processes (IDE, background JVMs). Use Task Manager to stop `java.exe`.
  - Close IDE or any process holding files (IntelliJ/Eclipse).
  - If files persist, reboot or use `handle.exe` / `Sysinternals` to locate locks.

## Git / placeholder problems
- If you see leftover template placeholders (e.g., `<your-username>`), search the repo and update to your project/fork URL.

## CI / GitHub Actions failures
- Check the workflow logs in Actions for the failing job and step.
- Ensure `.github/workflows/*` exist in the branch being built and that secrets (if any) are configured in repository settings.

If you can't resolve an issue, open an issue and attach the relevant logs (Maven `-e` output and `target/surefire-reports` if tests are involved).

---
Last updated: 2026-02-26
```