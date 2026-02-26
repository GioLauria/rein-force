# API / Class Reference

This page gives a quick overview of the main classes and their responsibilities.

- `reinforce.sim.GridEnvironment` — the world model: grid size, obstacles, start/goal placement, `step()` and state index mapping.
- `reinforce.sim.QLearningAgent` — tabular Q-learning agent: action selection and Q updates.
- `reinforce.sim.Simulator` — orchestrates steps, timing, reward mapping, and connects agent + environment.
- `reinforce.sim.SimulatorPanel` — Swing component that renders the grid, obstacles, start/goal, and agent.
- `reinforce.sim.ControlPanel` — Play/Stop/Restart buttons wired to `Simulator`.
- `reinforce.sim.AppLauncher` — main entrypoint that builds the `JFrame` and starts the simulation.

For more details, open the Java sources under `src/main/java/reinforce/sim`.
