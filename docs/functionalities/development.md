# Development

Responsibility: build, run and IDE setup for contributors.

Requirements
- Java 17 or later
- Maven 3.6+

Common commands

```bash
# Run tests
mvn test

# Build artifact without tests
mvn -DskipTests package

# Run the application
java -jar target/rein-force-sim-0.1.0.jar
```

IDE tips
- IntelliJ: Open the project as a Maven project. Use `Run` on `AppLauncher` or create an artifact.
- Eclipse: `Import -> Existing Maven Projects`.

Formatting and CI
- Optionally add a Java formatter (e.g., google-java-format) and configure a Maven plugin for CI checks.
