# Agent (QLearning)

Responsibility: decide actions for the agent using a Q-learning table.

Implementation
- `QLearningAgent` implements a tabular Q-learning agent with:
  - Actions: 4 discrete actions (0=up,1=right,2=down,3=left)
  - Table: `double[stateCount][4]`
  - Hyperparameters: `alpha` (learning rate), `gamma` (discount), `epsilon` (exploration)

Key methods
- `chooseAction(state)` — epsilon-greedy selection.
- `update(s,a,reward,sNext,done)` — Q-value update rule.

 Timing: the bot performs 4 moves per second by default; this is configurable via the `Simulator` API (`setMovesPerSecond`).
- The agent is prevented from immediately backtracking to its previous cell unless that reverse move is the only unblocked option.
- The environment tracks a visited trail for display and attraction purposes.
- Session-level `totalPoints` is tracked; if it becomes negative the simulator resets (randomizes obstacles and positions).

Quadratp (variable-size grid) guidance
- State space: an N x N grid with obstacles masked. Use a flattened index `i = y*N + x` for fixed-size tabular Q.
- Q-table size: `N*N x 4` (tabular). For N up to ~200 (≈160k states) tabular Q is still feasible; for larger grids consider a DQN with a CNN that takes the grid as an image input.
- Obstacles: treat stepping into an obstacle as a terminal event with a large negative reward (e.g. -100). Alternatively, mark obstacle cells as invalid and exclude them from the tabular state indexing (maintain a free-state mapping).

Pseudocode (updated)

Inizializza quadratp[N][N] con ostacoli, A=(0,0), B=(N-1,N-1)
Q[stato][a] = 0  # stato = (x,y) o flatten(i=N*x+y)

Per episode=1 to M:
  s = A
  While non terminale:
    a = ε-greedy su Q[s]
    s_next, r = step_quadratp(s, a)  # Controlla bounds/ostacoli
    Se ostacolo: r=-100, termina
    Q[s][a] += α*(r + γ*max Q[s_next] - Q[s][a])
    s = s_next
  ε *= decay
Policy finale: da s, argmax_a Q[s,a] per navigare quadratp.

Notes:
- Consider maintaining a mapping of free states if many obstacles exist to reduce Q-table size.
- For very large grids, represent the grid as an image and train a DQN (CNN encoder + dense policy/Q head).

Hints for tuning
- Increase `epsilon` to encourage exploration during early training.
- Decrease `alpha` for more stable learning when rewards are noisy.

**Docs updated (2026-02-27):** Simulator now defaults to 20 moves/sec; action selection can use a probabilistic `Randomizer` (softmax) combined with Q-values and neighbor attraction. The simulator enforces no-immediate-backtrack and a recent-position window (default 10) to reduce trivial revisits; a simple loop-detection forces backtrack when stuck. Session-level dialogs: "Episode Ended" on reaching goal, "Session Lost" when `totalPoints` goes negative.
