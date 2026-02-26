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

# Run the application
java -jar target/rein-force-sim-0.1.0.jar
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

Build with repository revision

You can build the project and embed the current Git tag/commit into the JAR's manifest by using the helper scripts in `scripts/`.

- Windows:

```cmd
scripts\build_with_tag.bat
```

- macOS / Linux:

```bash
./scripts/build_with_tag.sh
```

Build output location

Both helper scripts place the built JAR under the `outputs/` directory at the repository root as `outputs/rein-force-sim-<revision>.jar`.

The scripts will attempt to use the latest Git tag as the `Implementation-Version` manifest entry and fall back to the short commit id or `unknown` when no tag is available.

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
