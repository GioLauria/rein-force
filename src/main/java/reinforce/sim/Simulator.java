package reinforce.sim;

import javax.swing.Timer;

public class Simulator {
    private final GridEnvironment env;
    private final QLearningAgent agent;
    private SimulatorPanel view;
    private Timer timer;
    private boolean running = false;
    private long iterations = 0;
    private double avgDurationMs = 0.0;
    private long lastDurationMs = 0;
    private double totalPoints = 0.0;

    public Simulator(int gridSize, int obstacleCount) {
        this.env = new GridEnvironment(gridSize, obstacleCount);
        this.agent = new QLearningAgent(gridSize * gridSize);
        this.timer = new Timer(50, e -> step());
        resetStats();
    }

    public void setView(SimulatorPanel v) { this.view = v; }

    public void start() { running = true; timer.start(); }
    public void stop() { running = false; timer.stop(); }

    public void restart() {
        stop();
        env.reset( (env.getSize() * env.getSize()) / 10 );
        resetStats();
        start();
        if (view != null) view.repaint();
    }

    private void step() {
        long t0 = System.nanoTime();
        int state = env.stateIndexAgent();
        int action = agent.chooseAction(state);
        GridEnvironment.StepResult result = env.step(action);
        int nextState = env.stateIndexAgent();
        boolean done = false;
        double reward = 0.0; // default: no point change for ordinary moves
        if (result == GridEnvironment.StepResult.COLLISION) {
            reward = -1.0; // penalty for hitting obstacle
            done = false; // collision resets agent inside env; not terminal for simulator
        } else if (result == GridEnvironment.StepResult.WALL) {
            reward = -1.0; // penalty for hitting wall
        } else if (result == GridEnvironment.StepResult.GOAL) {
            reward = 100.0;
            done = true;
        }
        agent.update(state, action, reward, nextState, done);
        long t1 = System.nanoTime();
        lastDurationMs = (long)((t1 - t0) / 1_000_000.0);
        iterations++;
        // incremental average
        avgDurationMs = ((avgDurationMs * (iterations - 1)) + lastDurationMs) / iterations;
        totalPoints += reward;
        // if points drop below zero, restart the environment
        if (totalPoints < 0.0) {
            restart();
            return;
        }
        if (view != null) view.repaint();
    }

    private void resetStats() {
        iterations = 0;
        avgDurationMs = 0.0;
        lastDurationMs = 0;
        totalPoints = 0.0;
    }

    public long getIterations() { return iterations; }
    public double getAvgDurationMs() { return avgDurationMs; }
    public long getLastDurationMs() { return lastDurationMs; }
    public double getTotalPoints() { return totalPoints; }

    public GridEnvironment getEnvironment() { return env; }
    public QLearningAgent getAgent() { return agent; }
    public boolean isRunning() { return running; }
}
