# Environment

Responsibility: define the simulation world and its dynamics.

Contents
- Grid: square discrete grid of size N x N.
- Obstacles: randomly placed cells (not on perimeter by default).
- Start / Goal: random, distinct perimeter points A (start) and B (goal).
- Agent position: single cell representing the spherical bot.

Key behaviors
- `GridEnvironment.reset(count)` — (re)creates obstacles and places A/B.
- `GridEnvironment.step(action)` — moves the agent (actions: up, right, down, left). Returns `CONTINUE`, `COLLISION` or `GOAL`.
- On collision the agent is reset to start.

Notes
- Obstacles are placed avoiding the outer perimeter to ensure start/goal can be on edges.
- State indexing: `stateIndex(Point)` maps (x,y) to a linear state id used by the agent.
