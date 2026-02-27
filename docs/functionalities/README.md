# Project Functionalities

This directory documents the project organized by functionality. Each page focuses on a single responsibility so contributors and users can quickly find relevant information.

- `environment.md` — environment, grid and obstacles
- `agent.md` — learning agent, algorithm and parameters
- `gui.md` — GUI layout and rendering
- `controls.md` — runtime controls (Play / Stop / Restart)
- `testing.md` — unit tests and manual testing procedure
- `development.md` — build, run and IDE setup
- `api.md` — brief API/class reference

Release & scripts
- `scripts/` — helper scripts for building, running, changelog generation and releases. See `docs/scripts/` for per-script documentation.
- Git hooks are provided in `.githooks/` (pre-commit, post-commit, pre-push) and can be enabled with `git config core.hooksPath .githooks`.

**Docs updated (2026-02-27):** Functional behavior updated: simulator defaults to 20 moves/sec; probabilistic `Randomizer` is used for actions (softmax); no-immediate-backtrack and recent-window avoidance are enforced; loop-detection/backtrack prevents cycles; sessions show "Episode Ended" and "Session Lost" dialogs.
