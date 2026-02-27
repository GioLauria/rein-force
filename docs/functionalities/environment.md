# Environment

Responsibility: define the simulation world and its dynamics.

Contents
- Grid: square discrete grid of size N x N.
- Obstacles: randomly placed cells (not on perimeter by default).
- Start / Goal: random, distinct perimeter points A (start) and B (goal).
- Movement direction selection: the simulator uses a configurable probabilistic "randomizer" to pick directions based on Q-values and local cell scores.
- Agent position: single cell representing the spherical bot.

Key behaviors
- `GridEnvironment.reset(count)` — (re)creates obstacles and places A/B.
- `GridEnvironment.step(action)` — moves the agent (actions: up, right, down, left). Returns `CONTINUE`, `COLLISION` or `GOAL`.
- On collision the agent is reset to start.

Notes
- Obstacles are placed avoiding the outer perimeter to ensure start/goal can be on edges.
- State indexing: `stateIndex(Point)` maps (x,y) to a linear state id used by the agent.

**Docs updated (2026-02-27):** The simulator now defaults to 20 moves/sec. Movement selection uses a probabilistic `Randomizer` (softmax) combined with Q-values and neighbor attraction. The environment exposes `isInRecent(x,y)` (default capacity 10) which the simulator uses to avoid revisits; a loop-detection + forced backtrack mechanism prevents simple cycles.
