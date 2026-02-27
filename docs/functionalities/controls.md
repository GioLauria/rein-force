# Controls

Responsibility: runtime controls for simulation flow.

Buttons
- Play — starts or resumes the simulation timer (`Simulator.start()`).
- Stop — pauses the simulation timer (`Simulator.stop()`).
- Restart — stops, reinitializes environment (`env.reset(...)`), and starts again.

Behavior
- On `COLLISION`, the `Simulator` resets the agent to the start but continues the same training episode logic (update receives collision reward and episode termination flag).
- `Restart` creates a new random environment (new obstacles and new A/B).
- Movement rate: the bot's step frequency is configurable (default 4 moves/sec) via `Simulator#setMovesPerSecond`.

**Docs updated (2026-02-27):** Note: default movement rate has been changed to 20 moves/sec. The simulator uses a probabilistic `Randomizer` (softmax) for action selection and enforces no-immediate-backtrack plus a recent-position window to discourage revisits; loop-detection/backtrack is used when the agent gets stuck.
