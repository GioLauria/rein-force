# Sequence Diagram: Simulator runtime

This sequence diagram is written in the WebSequenceDiagrams / sequencediagram.org
syntax so it can be rendered on https://sequencediagram.org/.

```
title Simulator runtime

participant UI as AppLauncher / UI
participant Sim as Simulator
participant Env as GridEnvironment
participant Agent as QLearningAgent
participant View as SimulatorPanel
participant Ctrl as ControlPanel

note over UI: Application startup and composition
UI->Sim: new Simulator(gridSize, obstacleCount)
UI->View: new SimulatorPanel(sim)
UI->Ctrl: new ControlPanel(sim)
UI->Sim: sim.setView(panel), sim.start()

note over Sim: Timer started (EDT)
loop Each timer tick
    Sim->Env: state = stateIndexAgent()
    Sim->Env: neighborScores[] = getCellScore(...) (up,right,down,left)
    Sim->Agent: chooseActionWithAttraction(state, neighborScores, weight)
    Agent->Sim: action
    Sim->Env: step(action)
    Env->Sim: StepResult (CONTINUE | COLLISION | WALL | GOAL)
    Sim->Agent: update(state, action, reward, nextState, done)
    Sim->Env: setCellScore(agentPos, totalPoints)
    Sim->View: view.repaint()
    alt episode done (GOAL or COLLISION)
        Sim->Sim: restart()  -- reset environment & stats
    end
end

Ctrl->Sim: start()/stop()/restart()  -- user actions via buttons

note over Sim,View: All UI painting and Timer callbacks run on the Swing EDT
```
