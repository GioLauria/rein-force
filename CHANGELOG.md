# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to Semantic
Versioning.

## [Unreleased]

- docs(functionalities): document release scripts, hooks, and run/build workflow
- chore(scripts): make run scripts use latest tag/sha as revision and execute built JAR

> chore(scripts): make run scripts use latest tag/sha as revision and execute built JAR

- chore(release): make changelog conform to Keep a

> chore(release): make changelog conform to Keep a

- hangelog (Unreleased first, dated versions) and use section for annotated tag messages
- chore(scripts): make PowerShell changelog/tag helpers robust; add scripts docs

> chore(scripts): make PowerShell changelog/tag helpers robust; add scripts docs

- fix(release): generate multiline

> fix(release): generate multiline

- arkdown changelog and use changelog section for annotated tag
- refactor(app): improve startup (LAF, args, pack, validation, error handling)

> refactor(app): improve startup (LAF, args, pack, validation, error handling)

- refactor(ui): improve

> refactor(ui): improve

- ontrolPanel (null-check, tooltips, mnemonics, button state)
- refactor(env): validate size, bounds-safe accessors, cap obstacle placement

> refactor(env): validate size, bounds-safe accessors, cap obstacle placement

- refactor(agent): validate inputs, tie-break actions, defensive getQ, setters/getters

> refactor(agent): validate inputs, tie-break actions, defensive getQ, setters/getters

- refactor(sim): clarity and safety improvements in Simulator (clamp neighbors, constants, reuse agent pos)

> refactor(sim): clarity and safety improvements in Simulator (clamp neighbors, constants, reuse agent pos)

- chore(ui): remove avg/last durations from overlay stats

> chore(ui): remove avg/last durations from overlay stats

- fix(ui): center grid, guard zero-size, use Graphics2D and antialiasing

> fix(ui): center grid, guard zero-size, use Graphics2D and antialiasing

- chore: save changes

> chore: save changes

- chore(release): include v0.0.12 in

> chore(release): include v0.0.12 in

- HANGEL
- G
- chore(release): update

> chore(release): update

- HANGEL
- G for v0.0.13
- chore(scripts): place newest tag first and append Unreleased section

> chore(scripts): place newest tag first and append Unreleased section

- chore(scripts): changelog headings use tag-only (no date)

> chore(scripts): changelog headings use tag-only (no date)


## [v0.0.12] - 2026-02-26

- chore(release): update
- HANGEL
- G for 0.0.12
- chore(scripts): intercept v* tags in pre-push and make tag_release recreate annotated tags; commit changelog only if changed

> chore(scripts): intercept v* tags in pre-push and make tag_release recreate annotated tags; commit changelog only if changed

- chore(scripts): add changelog updater and release helpers; block direct tag pushes via .githooks/pre-push

> chore(scripts): add changelog updater and release helpers; block direct tag pushes via .githooks/pre-push

- chore: save changes

> chore: save changes

- chore: consolidate

> chore: consolidate

- N
- R
- BU
- NG.md and remove duplicates

## [v0.0.11] - 2026-02-26

- ci: generate standardized release_notes.txt and update release body in ensure_release.sh
- chore: remove

> chore: remove

- DE
- WNERS file

## [v0.0.10] - 2026-02-26

- ci: build upload UR
- with UriBuilder and validate base URL in upload_release_asset.ps1

## [v0.0.9] - 2026-02-26

- ci: fix upload URL template stripping and add debug output

## [v0.0.8] - 2026-02-26

- ci: restore default
- aven output (target/) in build_with_tag scripts

## [v0.0.7] - 2026-02-26

- ci: sanitize upload URL and URL-encode asset name in upload_release_asset.ps1

## [v0.0.6] - 2026-02-26

- ci(release): sanitize GitHub upload_url template before uploading assets

## [v0.0.5] - 2026-02-26

- ci(release): include release notes in packaging; expose release body output

## [v0.0.4] - 2026-02-26

- build: use
- aven profile 'outputs' and write artifacts to outputs/; update scripts
- scripts: copy built JAR to repo root (build_with_tag)

> scripts: copy built JAR to repo root (build_with_tag)

- ake collisions terminal; update Simulator and agent docs for variable-size grid (quadratp)
- Fix build scripts, P

> Fix build scripts, P

- comment, and docs (build_with_tag)
- ci: use revision property for build version; add build_with_tag scripts

> ci: use revision property for build version; add build_with_tag scripts

- feat(sim): per-cell scores, +10 move reward, attraction-based actions, and heatmap trail

> feat(sim): per-cell scores, +10 move reward, attraction-based actions, and heatmap trail

- ci: replace upload-release-asset action with in-repo upload scripts to avoid set-output deprecation

> ci: replace upload-release-asset action with in-repo upload scripts to avoid set-output deprecation


## [v0.0.3] - 2026-02-26

- ci(windows): add jar-only fallback when jlink packaging fails
- chore(ci): improve Windows packaging script and add release diagnostics

> chore(ci): improve Windows packaging script and add release diagnostics


## [v0.0.2] - 2026-02-26

- ci: extract workflow scripts and call external scripts; make scripts executable on runners
- chore(ci): extract release scripts and add repo .gitconfig; update contributing

> chore(ci): extract release scripts and add repo .gitconfig; update contributing

- ci: use AP

> ci: use AP

- -backed ensure_release to avoid create-release already_exists error
- ci: handle existing release (query AP

> ci: handle existing release (query AP

- if create-release fails)
- ci: chmod mvnw before executing in release workflow

> ci: chmod mvnw before executing in release workflow

- ci: allow G

> ci: allow G

- HUB_
- KEN contents: write for release creation
- chore: add GU

> chore: add GU

- stats overlay, points penalty, pre-commit package check, and release build workflow
- chore(git-hooks): add sample pre-commit hooks and docs to

> chore(git-hooks): add sample pre-commit hooks and docs to

- N
- R
- BU
- NG
- chore(pom): add jar manifest main

> chore(pom): add jar manifest main

- lass (AppLauncher)
- chore(scripts): add run scripts for Windows and Unix (supports detached start)

> chore(scripts): add run scripts for Windows and Unix (supports detached start)

- docs: add foreground and detached run instructions for the JAR (PowerShell,

> docs: add foreground and detached run instructions for the JAR (PowerShell,

- D, Unix)
- docs: add troubleshooting guide for

> docs: add troubleshooting guide for

- aven wrapper, JAVA_H
- E, build/test and Windows file-locks
- docs: clarify compile and run Quick Start (use

> docs: clarify compile and run Quick Start (use

- aven Wrapper)
- chore(docs/pom): remove template placeholders; set group

> chore(docs/pom): remove template placeholders; set group

- d to org.reinforce
- docs: add JAVA_H

> docs: add JAVA_H

- E setup instructions for
- aven Wrapper
- docs: document

> docs: document

- aven Wrapper usage in
- N
- R
- BU
- NG and development docs
- chore: add

> chore: add

- aven Wrapper (mvnw) to enforce
- aven requirement
- chore: remove .github and start fresh

> chore: remove .github and start fresh

- ci(release): fix YA

> ci(release): fix YA

- L indentation for changelog update step
- ci(release): export release notes for changelog update

> ci(release): export release notes for changelog update

- ci(release): auto-update

> ci(release): auto-update

- HANGEL
- G on tag push

## [v0.0.1] - 2026-02-26

- chore: add Java simulator project, docs,
- , and repo cleanup
- chore: add Java simulator project, docs,

> chore: add Java simulator project, docs,

- , and repo cleanup
- nitial commit

