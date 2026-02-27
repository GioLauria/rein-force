# Development

Responsibility: build, run and IDE setup for contributors.

Requirements
- Java 17 or later
- Maven 3.6+ (or use the included Maven Wrapper)

Using the Maven Wrapper
- The project includes the Maven Wrapper so contributors don't need Maven pre-installed.
- On Windows use: `mvnw.cmd test` or `mvnw.cmd -DskipTests package`.
- On macOS/Linux use: `./mvnw test` or `./mvnw -DskipTests package`.

Common commands

```bash
# Run tests (wrapper)
./mvnw test

# Build artifact without tests (wrapper)
./mvnw -DskipTests package

# Run the application using helper script (preferred)
./scripts/run.sh

# Build and embed the repository revision into the artifact
./scripts/build_with_tag.sh
```

Set JAVA_HOME (required by the Maven Wrapper)

The Maven Wrapper requires a valid `JAVA_HOME` pointing to a JDK installation. You can set it for the current session or persistently.

Windows (PowerShell — session):

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-XX'
```

Windows (persist — Command Prompt):

```cmd
setx JAVA_HOME "C:\Program Files\Java\jdk-XX"
```

macOS / Linux (session):

```bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-XX.jdk/Contents/Home"
```

macOS / Linux (persist): add the `export` line to `~/.bashrc`, `~/.bash_profile` or `~/.zshrc`.

Verify:

```bash
echo $JAVA_HOME  # or on Windows: echo %JAVA_HOME%
java -version
```

Build and release helpers

The project includes helper scripts in `scripts/` to standardize builds and releases:

- `scripts/build_with_tag.sh` / `scripts/build_with_tag.bat`: build the project and set the Maven `revision` property to the latest `v*` tag (or short commit SHA). This lets the build embed the release revision.
- `scripts/run.sh` / `scripts/run.bat`: build (passing `-Drevision`) and run the produced JAR. The script locates the JAR in `target/` and executes it, so the filename need not be hard-coded.
- `scripts/update_changelog.sh` / `scripts/update_changelog.ps1`: regenerate `CHANGELOG.md` following Keep a Changelog (Unreleased first, version headers include dates). Commit bodies are preserved as blockquotes so GitHub release bodies keep paragraph breaks.
- `scripts/tag_release.sh` / `scripts/tag_release.ps1`: create (or replace) an annotated tag using the `CHANGELOG.md` section for the tag as the tag message, then push the annotated tag to `origin`.

Build output location

The built JAR is produced under `target/` by Maven and executed by `scripts/run.*`. Use `scripts/build_with_tag.*` to ensure the `revision` property is set to the same value as your intended release tag.

IDE tips
- IntelliJ: Open the project as a Maven project. Use `Run` on `AppLauncher` or create an artifact.
- Eclipse: `Import -> Existing Maven Projects`.

Formatting and CI
- Optionally add a Java formatter (e.g., google-java-format) and configure a Maven plugin for CI checks.

GUI statistics overlay

- The simulator GUI now shows a small overlay at the top of the window with three live metrics:
	- **Iterations:** total iterations/steps completed in the current run.
	- **Average duration:** moving average of iteration durations in milliseconds (useful for spotting slowdowns).
	- **Last duration:** duration in milliseconds of the most recent iteration.

These metrics are updated on the Swing event thread and are intended for quick, local performance checks while developing or running experiments.
