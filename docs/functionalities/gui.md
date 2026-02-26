# GUI

Responsibility: render the environment and provide a simple control surface.

Components
- `SimulatorPanel` — custom Swing `JPanel` that draws:
  - grid lines, obstacle tiles, start (blue), goal (green), agent (red)
  - scales cells to panel size; uses simple `paintComponent` drawing
- `ControlPanel` — JPanel with `Play`, `Stop`, `Restart` buttons
- `AppLauncher` — constructs the main `JFrame` and wires `Simulator`, `SimulatorPanel`, and `ControlPanel` together

Rendering details
- Uses fixed cell-based rendering; avoids anti-aliasing for simplicity.
- Preferred frame size in launcher: 800x860.
