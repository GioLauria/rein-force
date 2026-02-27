# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to Semantic
Versioning.

## [Unreleased]

chore(changelog): add b329192 to Unreleased (6a41bde)


chore(changelog): add 494ac65 to Unreleased (b329192)


chore(changelog): add e3121bd to Unreleased (494ac65)


chore(changelog): add dd73588 to Unreleased (e3121bd)


chore(changelog): add ff47bc8 to Unreleased (dd73588)


chore(changelog): add fcd6184 to Unreleased (ff47bc8)


chore(changelog): add a7ed012 to Unreleased (fcd6184)


chore(changelog): add 2d818d2 to Unreleased (a7ed012)


chore(changelog): add b0b59f8 to Unreleased (2d818d2)


chore(changelog): add db1fd5f to Unreleased (b0b59f8)


chore(changelog): add 00eda3f to Unreleased (db1fd5f)


chore(changelog): add 33ad0fa to Unreleased (00eda3f)


chore(changelog): add 8ea82cb to Unreleased (33ad0fa)


chore(changelog): add 32c13e1 to Unreleased (8ea82cb)


chore(changelog): add af5f0ed to Unreleased (32c13e1)


chore(changelog): add 91e4bea to Unreleased (af5f0ed)


chore(changelog): add 030809d to Unreleased (91e4bea)


chore(changelog): add 7bf787e to Unreleased (030809d)


chore(changelog): add 0aafd76 to Unreleased (7bf787e)


chore(changelog): add ebae4aa to Unreleased (0aafd76)


chore(changelog): add bb143dd to Unreleased (ebae4aa)


chore(changelog): add e425602 to Unreleased (bb143dd)


chore(changelog): add ea64ba8 to Unreleased (e425602)


chore(changelog): add 13c45ac to Unreleased (ea64ba8)


chore(release): finalize hooks, changelog and release scripts (13c45ac)


chore(hooks): install post-commit hook and document it; clean changelog (0416e1b)


- Placeholder for upcoming changes.
 
## [v0.0.14] - 2026-02-27

- chore(docs): update docs and changelog; record simulator behavior changes (2026-02-27)
- fix(sim): use uniform random fallback among allowed moves to increase exploration
- fix(sim): reset Randomizer each move (fresh RNG per step)
- feat(sim): add Randomizer selector; use probabilistic softmax for action selection; update docs
- chore(docs/sim): set default moves/sec to 4 and expose configurable API
- feat(sim): forbid moves into last-10 positions; track recent trail
- feat(sim): implement RL rules, scoring, trail; update docs
- chore: commit workspace changes
- docs(diagram): use full class names in sequence diagram
- docs(diagram): make sequence diagram compatible with sequencediagram.org
- docs(diagram): add Mermaid sequence diagram for simulator runtime
- docs(architecture): add code relationships and runtime flow
- chore(release): finalize docs, scripts and changelog
- docs: update README with new scripts, changelog and release workflow

## [v0.0.13] - 2026-02-27

- docs(functionalities): document release scripts, hooks, and run/build workflow
- chore(scripts): make run scripts use latest tag/sha as revision and execute built JAR
- chore(release): make changelog conform to Keep a Changelog (Unreleased first, dated versions) and use section for annotated tag messages
- chore(scripts): make PowerShell changelog/tag helpers robust; add scripts docs
- fix(release): generate multiline Markdown changelog and use changelog section for annotated tag
- refactor(app): improve startup (LAF, args, pack, validation, error handling)
- refactor(ui): improve ControlPanel (null-check, tooltips, mnemonics, button state)
- refactor(env): validate size, bounds-safe accessors, cap obstacle placement
- refactor(agent): validate inputs, tie-break actions, defensive getQ, setters/getters
- refactor(sim): clarity and safety improvements in Simulator (clamp neighbors, constants, reuse agent pos)
- chore(ui): remove avg/last durations from overlay stats
- fix(ui): center grid, guard zero-size, use Graphics2D and antialiasing
- chore: save changes
- chore(release): include v0.0.12 in CHANGELOG
- chore(release): update CHANGELOG for v0.0.13
- chore(scripts): place newest tag first and append Unreleased section
- chore(scripts): changelog headings use tag-only (no date)

## [v0.0.12] - 2026-02-26

- chore(release): update CHANGELOG for 0.0.12
- chore(scripts): intercept v* tags in pre-push and make tag_release recreate annotated tags; commit changelog only if changed
- chore(scripts): add changelog updater and release helpers; block direct tag pushes via .githooks/pre-push
- chore: save changes
- chore: consolidate CONTRIBUTING.md and remove duplicates

## [v0.0.11] - 2026-02-26

- ci: generate standardized release_notes.txt and update release body in ensure_release.sh
- chore: remove CODEOWNERS file

## [v0.0.10] - 2026-02-26

- ci: build upload URI with UriBuilder and validate base URL in upload_release_asset.ps1

## [v0.0.9] - 2026-02-26

- ci: fix upload URL template stripping and add debug output

## [v0.0.8] - 2026-02-26

- ci: restore default Maven output (target/) in build_with_tag scripts

## [v0.0.7] - 2026-02-26

- ci: sanitize upload URL and URL-encode asset name in upload_release_asset.ps1

## [v0.0.6] - 2026-02-26

- ci(release): sanitize GitHub upload_url template before uploading assets

## [v0.0.5] - 2026-02-26

- ci(release): include release notes in packaging; expose release body output

## [v0.0.4] - 2026-02-26

- build: use Maven profile 'outputs' and write artifacts to outputs/; update scripts
- scripts: copy built JAR to repo root (build_with_tag)
- Make collisions terminal; update Simulator and agent docs for variable-size grid (quadratp)
- Fix build scripts, POM comment, and docs (build_with_tag)
- ci: use revision property for build version; add build_with_tag scripts
- feat(sim): per-cell scores, +10 move reward, attraction-based actions, and heatmap trail
- ci: replace upload-release-asset action with in-repo upload scripts to avoid set-output deprecation

## [v0.0.3] - 2026-02-26

- ci(windows): add jar-only fallback when jlink packaging fails
- chore(ci): improve Windows packaging script and add release diagnostics

## [v0.0.2] - 2026-02-26

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
- docs: document Maven Wrapper usage in CONTRIBUTING and development docs
- chore: add Maven Wrapper (mvnw) to enforce Maven requirement
- chore: remove .github and start fresh
- ci(release): fix YAML indentation for changelog update step
- ci(release): export release notes for changelog update
- ci(release): auto-update CHANGELOG on tag push

## [v0.0.1] - 2026-02-26

- chore: add Java simulator project, docs, CI, and repo cleanup
- chore: add Java simulator project, docs, CI, and repo cleanup
- Initial commit

