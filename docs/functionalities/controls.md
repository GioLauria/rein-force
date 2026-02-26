# Controls

Responsibility: runtime controls for simulation flow.

Buttons
- Play — starts or resumes the simulation timer (`Simulator.start()`).
- Stop — pauses the simulation timer (`Simulator.stop()`).
- Restart — stops, reinitializes environment (`env.reset(...)`), and starts again.

Behavior
- On `COLLISION`, the `Simulator` resets the agent to the start but continues the same training episode logic (update receives collision reward and episode termination flag).
- `Restart` creates a new random environment (new obstacles and new A/B).
