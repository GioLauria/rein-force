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
    private static final int DEFAULT_MOVES_PER_SECOND = 4;
    private int movesPerSecond = DEFAULT_MOVES_PER_SECOND; // configurable
    private int lastAction = -1; // track previous action to avoid immediate backtracking
    private final Randomizer randomizer = new Randomizer(new java.util.Random());

    public Simulator(int gridSize, int obstacleCount) {
        this(gridSize, obstacleCount, DEFAULT_MOVES_PER_SECOND);
    }

    public Simulator(int gridSize, int obstacleCount, int movesPerSecond) {
        this.env = new GridEnvironment(gridSize, obstacleCount);
        this.agent = new QLearningAgent(env.getWidth() * env.getHeight());
        this.initialObstacleCount = obstacleCount;
        setMovesPerSecond(movesPerSecond);
        int delay = Math.max(1, 1000 / this.movesPerSecond);
        this.timer = new Timer(delay, e -> step());
        resetStats();
    }

    public int getMovesPerSecond() { return movesPerSecond; }
    public void setMovesPerSecond(int movesPerSecond) {
        if (movesPerSecond <= 0) movesPerSecond = 1;
        this.movesPerSecond = movesPerSecond;
        if (this.timer != null) {
            int delay = Math.max(1, 1000 / this.movesPerSecond);
            this.timer.setDelay(delay);
        }
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
        int maxX = env.getWidth() - 1;
        int maxY = env.getHeight() - 1;
        for (int i = 0; i < 4; i++) {
            int nx = ap.x + dx[i];
            int ny = ap.y + dy[i];
            if (nx < 0 || nx > maxX || ny < 0 || ny > maxY) {
                neighborScores[i] = Double.NEGATIVE_INFINITY; // out-of-bounds
            } else if (env.isObstacle(nx, ny)) {
                neighborScores[i] = -10.0; // obstacle
            } else if (env.isInRecent(nx, ny)) {
                neighborScores[i] = Double.NEGATIVE_INFINITY; // avoid last-N visited cells
            } else {
                neighborScores[i] = env.getCellScore(nx, ny);
            }
        }

        double attractionWeight = 0.5; // moderate bias towards higher-scored cells
        // combine Q-values and neighbor scores into a per-action value array
        double[] qrow = agent.getQ()[state];
        double[] combined = new double[4];
        for (int i = 0; i < 4; i++) combined[i] = qrow[i] + attractionWeight * neighborScores[i];
        // select action via the randomizer (softmax sampling) so direction is decided probabilistically
        int action = randomizer.sampleSoftmax(combined);
        // enforce "cannot go back unless blocked": if chosen action is reverse of lastAction
        if (lastAction != -1) {
            int reverse = (lastAction + 2) % 4;
            int nx = ap.x + dx[reverse];
            int ny = ap.y + dy[reverse];
            boolean reverseBlocked = (nx < 0 || nx > maxX || ny < 0 || ny > maxY) || env.isObstacle(nx, ny);
            if (action == reverse && !reverseBlocked) {
                // find best alternative action (q + attraction) excluding reverse
                double[] qrowLocal = agent.getQ()[state];
                double bestVal = Double.NEGATIVE_INFINITY;
                int bestAction = action; // fallback
                for (int a = 0; a < 4; a++) {
                    if (a == reverse) continue;
                    int tx = ap.x + dx[a];
                    int ty = ap.y + dy[a];
                    if (tx < 0 || tx > maxX || ty < 0 || ty > maxY) continue;
                    if (env.isObstacle(tx, ty)) continue;
                    if (env.isInRecent(tx, ty)) continue; // do not move to recent cells
                    double val = qrowLocal[a] + attractionWeight * neighborScores[a];
                    if (val > bestVal) {
                        bestVal = val;
                        bestAction = a;
                    }
                }
                action = bestAction;
            }
        }
        GridEnvironment.StepResult result = env.step(action);
        int nextState = env.stateIndexAgent();
        boolean done = false;
        double reward = 0.0;
        switch (result) {
            case CONTINUE:
                // moved to an empty/valid cell
                reward = 10.0;
                // increase the destination cell's score so agent can prefer higher cells
                java.awt.Point newPos = env.getAgent();
                double prevVal = env.getCellScore(newPos.x, newPos.y);
                env.setCellScore(newPos.x, newPos.y, prevVal + 10.0);
                break;
            case COLLISION:
                // hitting obstacle: stay in place, obstacle cell becomes -10, subtract 1 point
                reward = -1.0;
                // do not mark episode done; episode continues until totalPoints < 0 or goal reached
                break;
            case WALL:
                reward = -1.0; // penalty for hitting border
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
        // update lastAction for backtracking rule
        lastAction = action;
        // if episode terminated (goal or collision), restart environment
        if (done) {
            // show a dialog on goal reached
            if (result == GridEnvironment.StepResult.GOAL && view != null) {
                javax.swing.SwingUtilities.invokeLater(() ->
                    javax.swing.JOptionPane.showMessageDialog(view, "Episode Ended"));
            }
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
