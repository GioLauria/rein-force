# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to Semantic
Versioning.

## [v0.0.11]


- ci: generate standardized release_notes.txt and update release body in ensure_release.sh

- chore: remove CODEOWNERS file



## [v0.0.10]


- ci: build upload URI with UriBuilder and validate base URL in upload_release_asset.ps1



## [v0.0.9]


- ci: fix upload URL template stripping and add debug output



## [v0.0.8]


- ci: restore default Maven output (target/) in build_with_tag scripts



## [v0.0.7]


- ci: sanitize upload URL and URL-encode asset name in upload_release_asset.ps1



## [v0.0.6]


- ci(release): sanitize GitHub upload_url template before uploading assets



## [v0.0.5]


- ci(release): include release notes in packaging; expose release body output



## [v0.0.4]


- build: use Maven profile 'outputs' and write artifacts to outputs/; update scripts

- scripts: copy built JAR to repo root (build_with_tag)

- Make collisions terminal; update Simulator and agent docs for variable-size grid (quadratp)

- Fix build scripts, POM comment, and docs (build_with_tag)

- ci: use revision property for build version; add build_with_tag scripts

- feat(sim): per-cell scores, +10 move reward, attraction-based actions, and heatmap trail

- ci: replace upload-release-asset action with in-repo upload scripts to avoid set-output deprecation



## [v0.0.3]


- ci(windows): add jar-only fallback when jlink packaging fails

- chore(ci): improve Windows packaging script and add release diagnostics



## [v0.0.2]


- ci: extract workflow scripts and call external scripts; make scripts executable on runners

- chore(ci): extract release scripts and add repo .gitconfig; update contributing

- ci: use API-backed ensure_release to avoid create-release already_exists error

- ci: handle existing release (query API if create-release fails)

- ci: chmod mvnw before executing in release workflow

- ci: allow GITHUB_TOKEN contents: write for release creation

- chore: add GUI stats overlay, points penalty, pre-commit package check, and release build workflow

- chore(git-hooks): add sample pre-commit hooks and docs to CONTRIBUTING

- chore(pom): add jar manifest mainClass (AppLauncher)

- chore(scripts): add run scripts for Windows and Unix (supports detached start)

- docs: add foreground and detached run instructions for the JAR (PowerShell, CMD, Unix)

- docs: add troubleshooting guide for Maven wrapper, JAVA_HOME, build/test and Windows file-locks

- docs: clarify compile and run Quick Start (use Maven Wrapper)

- chore(docs/pom): remove template placeholders; set groupId to org.reinforce

- docs: add JAVA_HOME setup instructions for Maven Wrapper

- chore: add Maven Wrapper (mvnw) to enforce Maven requirement

- chore: remove .github and start fresh

- ci(release): fix YAML indentation for changelog update step

- ci(release): export release notes for changelog update

- ci(release): auto-update CHANGELOG on tag push



## [v0.0.1]


- Initial commit

- chore: add Java simulator project, docs, CI, and repo cleanup

- chore: add Java simulator project, docs, CI, and repo cleanup



## [Unreleased]

- chore(scripts): place newest tag first and append Unreleased section

- chore(scripts): changelog headings use tag-only (no date)

- chore(release): update CHANGELOG for 0.0.12

- chore(scripts): intercept v* tags in pre-push and make tag_release recreate annotated tags; commit changelog only if changed

- chore(scripts): add changelog updater and release helpers; block direct tag pushes via .githooks/pre-push

- chore: save changes

- chore: consolidate CONTRIBUTING.md and remove duplicates



