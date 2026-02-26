# Contributing

Thanks for your interest in contributing!

> Template note: update placeholders (project name, language, tooling) before publishing.

## Ways to contribute

- Report bugs and request features
- Improve documentation
- Submit code changes
- Review pull requests

## Code of Conduct

Please follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Development setup

1. Fork and clone the repo.
2. Install dependencies (TBD).
3. Run tests (TBD).

## Branching and commits

- Use short, descriptive branch names.
- Keep commits focused and small.
- Use clear commit messages (TBD).

# Contributing

Thanks for your interest in contributing to Rein-Force Simulator.

This repository is a Java/Maven project. Below are the recommended steps and guidelines for contributing.

## Ways to contribute

- Report bugs and request features by opening an issue.
- Improve documentation under the `docs/` folder.
- Submit code changes via pull requests.
- Review pull requests and help triage issues.

## Code of Conduct

Please follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Development setup (Java / Maven)

1. Fork the repository and clone your fork:

```bash
git clone https://github.com/<your-username>/rein-force.git
cd rein-force
```

2. Build and run tests:

The project includes the Maven Wrapper so you do not need a local Maven installation.

On Windows:

```powershell
# Run the test suite
mvnw.cmd test

# Build without running tests
mvnw.cmd -DskipTests package
```

On macOS / Linux:

```bash
# Run the test suite
./mvnw test

# Build without running tests
./mvnw -DskipTests package

# Run the produced JAR
java -jar target/rein-force-sim-0.1.0.jar
```

Notes:
- The project uses JUnit 5 for tests.
- IDEs: IntelliJ IDEA and Eclipse are supported; use the provided `pom.xml`.

## Branching and commits

- Use short, descriptive branch names (e.g. `feature/rl-agent`, `fix/gui-refresh`).
- Keep commits focused and small.
- Commit message format (recommended):

```
<type>(<scope>): <short summary>

<optional longer description>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.

## Pull requests

- Describe the change, motivation, and any trade-offs.
- Add or update tests where appropriate.
- Update documentation when behavior changes.
- Ensure `./mvnw test` (or `mvnw.cmd test` on Windows) passes locally before opening a PR.
- Rebase or merge the latest `main` to keep PRs up to date.

CI runs tests on each PR. Fix any CI failures before requesting review.

## Testing

Run the full test suite with:

```bash
mvn test
```

Add unit tests under `src/test/java` following the project's package layout.

## Release process

Releases follow Semantic Versioning. Typical steps:

1. Ensure all tests pass and documentation is updated.
2. Update `CHANGELOG.md` with notable changes.
3. Tag the release (e.g., `v1.0.0`).
4. Create a GitHub release from the tag and attach artifacts if necessary.

If you need assistance making a release, contact the maintainers listed in `GOVERNANCE.md`.
