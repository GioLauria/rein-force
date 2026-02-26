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

Rewards used by simulator
- step: -1
- collision: -10 (and episode reset)
- goal: +100 (episode terminal)

Hints for tuning
- Increase `epsilon` to encourage exploration during early training.
- Decrease `alpha` for more stable learning when rewards are noisy.
