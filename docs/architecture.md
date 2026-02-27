# Architecture Overview

This document summarizes the main classes in `src/main/java/reinforce/sim` and their relationships.

## Purpose

Provide a concise map of responsibilities and runtime interactions so contributors can quickly understand how the UI, simulation loop, environment and agent work together.

## Components

- `AppLauncher` — application entry point; composes the UI and starts the simulator.
- `Simulator` — orchestration and runtime loop (uses a `javax.swing.Timer`); owns the `GridEnvironment` and `QLearningAgent`; holds a reference to the view (`SimulatorPanel`) and exposes control methods used by `ControlPanel`.
- `GridEnvironment` — world model: grid size, obstacles, start/goal/agent positions and per-cell scores; exposes `step(action)` and helpers to read/set cell scores and positions.
-- `QLearningAgent` — Q-table and learning update (`update`). Action selection is performed by the runtime (`Simulator`) by combining Q-values with neighbor attraction scores and sampling via the `Randomizer` (softmax). The agent remains decoupled from environment internals via numeric state IDs.
- `SimulatorPanel` — Swing `JPanel` renderer: paints grid, obstacles, start/goal/agent, heatmap from cell scores and overlay stats. Passive view; repainted by `Simulator`.
- `ControlPanel` — simple UI with Play/Stop/Restart buttons that call `Simulator` methods.

## Runtime Flow

1. `AppLauncher` creates `Simulator(gridSize, obstacleCount)`, `SimulatorPanel(sim)` and `ControlPanel(sim)`, shows the UI, sets `sim.setView(panel)` and calls `sim.start()`.
2. `Simulator`'s `Timer` fires and calls `step()`:
   - Read `state = env.stateIndexAgent()` and neighbor cell scores via `env.getCellScore(...)`.
   - Compute combined per-action values (Q + neighbor attraction) and sample an action via `Randomizer.sampleSoftmax(...)`.
   - Execute action via `env.step(action)` → returns `StepResult` (CONTINUE, COLLISION, WALL, GOAL).
   - Compute `reward`, call `agent.update(state, action, reward, nextState, done)`.
   - Update per-cell score via `env.setCellScore(...)`, update stats and `view.repaint()`.
   - If episode `done` or points drop below threshold, `restart()` environment.

## Data Flow & Coupling

- `Simulator` is the central coordinator (owns env + agent + view).
- `GridEnvironment` exposes only safe accessors; `SimulatorPanel` uses those for rendering. `QLearningAgent` uses numeric state indices, so it is decoupled from environment internals.
- UI components (`SimulatorPanel`, `ControlPanel`) depend on `Simulator` only; `ControlPanel` triggers actions while `SimulatorPanel` is read-only.

## Extension Points

- Replace `QLearningAgent` with another policy implementation that exposes the same `chooseAction`/`update` signature.
- Swap rendering by providing a different view implementing similar repaint semantics.
- Parameterize rewards/timers and expose via the control panel for experiments.

## Quick File Map

- `src/main/java/reinforce/sim/AppLauncher.java`
- `src/main/java/reinforce/sim/Simulator.java`
- `src/main/java/reinforce/sim/GridEnvironment.java`
- `src/main/java/reinforce/sim/QLearningAgent.java`
- `src/main/java/reinforce/sim/SimulatorPanel.java`
- `src/main/java/reinforce/sim/ControlPanel.java`

**Docs updated (2026-02-27):** Simulator now defaults to 20 moves/sec; action selection uses a probabilistic `Randomizer` (softmax) and the simulator enforces no-immediate-backtrack plus a recent-position window (default 10). A simple loop-detection mechanism forces backtrack when stuck. Session end dialogs: "Episode Ended" (goal) and "Session Lost" (negative score).

