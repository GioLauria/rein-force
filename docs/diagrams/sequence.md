# Sequence Diagram: Simulator runtime

This Mermaid sequence diagram shows the runtime interactions between the UI, `Simulator`, `GridEnvironment`, `QLearningAgent`, `SimulatorPanel` and `ControlPanel` during normal operation.

```mermaid
sequenceDiagram
    participant UI as AppLauncher / UI
    participant Sim as Simulator
    participant Env as GridEnvironment
    participant Agent as QLearningAgent
    participant View as SimulatorPanel
    participant Ctrl as ControlPanel

    Note over UI: Application startup and composition
    UI->>Sim: new Simulator(gridSize, obstacleCount)
    UI->>View: new SimulatorPanel(sim)
    UI->>Ctrl: new ControlPanel(sim)
    UI->>Sim: sim.setView(panel), sim.start()

    Note over Sim: Timer started (EDT)
    loop Each timer tick
        Sim->>Env: state = stateIndexAgent()
        Sim->>Env: neighborScores[] = getCellScore(...) (up,right,down,left)
        Sim->>Agent: chooseActionWithAttraction(state, neighborScores, weight)
        Agent-->>Sim: action
        Sim->>Env: step(action)
        Env-->>Sim: StepResult (CONTINUE | COLLISION | WALL | GOAL)
        Sim->>Agent: update(state, action, reward, nextState, done)
        Sim->>Env: setCellScore(agentPos, totalPoints)
        Sim->>View: view.repaint()
        alt episode done (GOAL or COLLISION)
            Sim->>Sim: restart()  -- reset environment & stats
        end
    end

    Ctrl->>Sim: start()/stop()/restart()  -- user actions via buttons

    Note over Sim,View: All UI painting and Timer callbacks run on the Swing EDT
```
