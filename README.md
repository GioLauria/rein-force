# Rein-Force Simulator

Simple Java reinforcement-learning style simulator with a GUI. The environment is a square grid containing random obstacles; a spherical bot starts at a random perimeter point A and attempts to reach a random perimeter point B while avoiding obstacles. The agent uses a simple Q-learning table on a discretized grid.

Quick start

This project includes helper scripts and an opinionated release flow. The quick guidance below reflects the current, recommended workflow.

Prerequisites
- Java 17+ (set `JAVA_HOME`)
- Git

Build & run (recommended)

Unix / macOS (preferred):

```bash
./scripts/build_with_tag.sh       # builds with -Drevision set to latest v* tag or short SHA
./scripts/run.sh                 # builds (if needed) and runs the produced JAR
```

Windows (PowerShell / CMD):

```powershell
scripts\build_with_tag.bat
scripts\run.bat
```

Run tests

```bash
./mvnw test
# or on Windows: mvnw.cmd test
```

Changelog & release flow
- `scripts/update_changelog.sh` / `scripts/update_changelog.ps1` regenerate `CHANGELOG.md` in Keep a Changelog format (Unreleased first, dated versions). Commit bodies are preserved as blockquote lines so GitHub release descriptions keep paragraph breaks.
- `scripts/tag_release.sh` / `scripts/tag_release.ps1` create (or replace) an annotated `v*` tag using the matching `## [vX.Y.Z]` section from `CHANGELOG.md` as the tag message, then push the annotated tag to `origin`.
- Git hooks are provided in `.githooks/` (pre-commit, post-commit, pre-push). Enable them locally with:

```bash
git config core.hooksPath .githooks
```

Notes about tagging
- The repo's helper scripts now ensure changelog entries are generated and used as annotated tag messages so releases on GitHub show readable, multiline notes.
- If you create a local tag, push it with:

```bash
git push origin --force refs/tags/v0.0.13
```

Documentation
- Per-script docs: `docs/scripts/`
- Developer guidance: `docs/functionalities/development.md`
- Full changelog: `CHANGELOG.md`

Contributing
- See `CONTRIBUTING.md` for recommended workflows, coding style, and how to enable hooks.

What changed recently
- The project now preserves commit bodies in the changelog, uses annotated tags with changelog messages, and includes hooks to keep the changelog updated automatically on commit.

If you want a different release workflow or tag naming convention, update `scripts/tag_release.sh` and corresponding PowerShell script accordingly.
