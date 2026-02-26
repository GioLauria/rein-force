package reinforce.sim;

import javax.swing.*;
import java.awt.*;

public class Simulator {
    private final GridEnvironment env;
    private final QLearningAgent agent;
    private SimulatorPanel view;
    private Timer timer;
    private boolean running = false;

    public Simulator(int gridSize, int obstacleCount) {
        this.env = new GridEnvironment(gridSize, obstacleCount);
        this.agent = new QLearningAgent(gridSize * gridSize);
        this.timer = new Timer(50, e -> step());
    }

    public void setView(SimulatorPanel v) { this.view = v; }

    public void start() { running = true; timer.start(); }
    public void stop() { running = false; timer.stop(); }

    public void restart() {
        stop();
        env.reset( (env.getSize() * env.getSize()) / 10 );
        start();
        if (view != null) view.repaint();
    }

    private void step() {
        int state = env.stateIndexAgent();
        int action = agent.chooseAction(state);
        GridEnvironment.StepResult result = env.step(action);
        int nextState = env.stateIndexAgent();
        boolean done = false;
        double reward = -1.0; // step cost
        if (result == GridEnvironment.StepResult.COLLISION) {
            reward = -10.0;
            done = true;
        } else if (result == GridEnvironment.StepResult.GOAL) {
            reward = 100.0;
            done = true;
        }
        agent.update(state, action, reward, nextState, done);
        if (view != null) view.repaint();
    }

    public GridEnvironment getEnvironment() { return env; }
    public QLearningAgent getAgent() { return agent; }
    public boolean isRunning() { return running; }
}
