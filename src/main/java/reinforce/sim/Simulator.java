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
    private final int initialObstacleCount;
    private static final int DEFAULT_TIMER_MS = 50;

    public Simulator(int gridSize, int obstacleCount) {
        this.env = new GridEnvironment(gridSize, obstacleCount);
        this.agent = new QLearningAgent(gridSize * gridSize);
        this.initialObstacleCount = obstacleCount;
        this.timer = new Timer(DEFAULT_TIMER_MS, e -> step());
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
        // compute neighbor cell scores to bias action selection
        double[] neighborScores = new double[4];
        java.awt.Point ap = env.getAgent();
        // directions: up, right, down, left
        int[] dx = {0, 1, 0, -1};
        int[] dy = {-1, 0, 1, 0};
        int maxIdx = env.getSize() - 1;
        for (int i = 0; i < 4; i++) {
            int nx = Math.max(0, Math.min(maxIdx, ap.x + dx[i]));
            int ny = Math.max(0, Math.min(maxIdx, ap.y + dy[i]));
            neighborScores[i] = env.getCellScore(nx, ny);
        }

        double attractionWeight = 0.5; // moderate bias towards higher-scored cells
        int action = agent.chooseActionWithAttraction(state, neighborScores, attractionWeight);
        GridEnvironment.StepResult result = env.step(action);
        int nextState = env.stateIndexAgent();
        boolean done = false;
        double reward = 0.0;
        switch (result) {
            case CONTINUE:
                reward = 10.0; // ordinary move
                break;
            case COLLISION:
                reward = -100.0; // terminal severe penalty for hitting obstacle
                done = true;
                break;
            case WALL:
                reward = -1.0; // penalty for hitting wall (non-terminal)
                break;
            case GOAL:
                reward = 100.0;
                done = true;
                break;
            default:
                reward = 0.0;
        }
        agent.update(state, action, reward, nextState, done);
        long t1 = System.nanoTime();
        lastDurationMs = (long) ((t1 - t0) / 1_000_000.0);
        iterations++;
        // incremental average (more numerically stable)
        avgDurationMs += ((double) lastDurationMs - avgDurationMs) / iterations;
        totalPoints += reward;
        // assimilate totalPoints into the current cell
        env.setCellScore(ap.x, ap.y, totalPoints);
        // if episode terminated (goal or collision), restart environment
        if (done) {
            restart();
            return;
        }

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
