# Docs updated (2026-02-27): simulator runtime behavior updated; see `docs/architecture.md` for details.
# Sequence Diagram: Simulator runtime

This sequence diagram is written in the WebSequenceDiagrams / sequencediagram.org
syntax so it can be rendered on https://sequencediagram.org/.

```
title Simulator runtime

participant AppLauncher
participant Simulator
participant GridEnvironment
participant QLearningAgent
participant SimulatorPanel
participant ControlPanel

note over AppLauncher: Application startup and composition
AppLauncher->Simulator: new Simulator(gridSize, obstacleCount)
AppLauncher->SimulatorPanel: new SimulatorPanel(sim)
AppLauncher->ControlPanel: new ControlPanel(sim)
AppLauncher->Simulator: sim.setView(panel), sim.start()

note over Simulator: Timer started (EDT)
loop Each timer tick
    Simulator->GridEnvironment: state = stateIndexAgent()
    Simulator->GridEnvironment: neighborScores[] = getCellScore(...) (up,right,down,left)
    Simulator->QLearningAgent: chooseActionWithAttraction(state, neighborScores, weight)
    QLearningAgent->Simulator: action
    Simulator->GridEnvironment: step(action)
    GridEnvironment->Simulator: StepResult (CONTINUE | COLLISION | WALL | GOAL)
    Simulator->QLearningAgent: update(state, action, reward, nextState, done)
    Simulator->GridEnvironment: setCellScore(agentPos, totalPoints)
    Simulator->SimulatorPanel: view.repaint()
    alt episode done (GOAL or COLLISION)
        Simulator->Simulator: restart()  -- reset environment & stats
    end
end

ControlPanel->Simulator: start()/stop()/restart()  -- user actions via buttons

note over Simulator,SimulatorPanel: All UI painting and Timer callbacks run on the Swing EDT
```
