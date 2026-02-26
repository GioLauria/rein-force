package reinforce.sim;

import java.awt.Point;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;

public class GridEnvironment {
    public enum StepResult { CONTINUE, COLLISION, WALL, GOAL }

    private final int size;
    private final boolean[][] obstacles;
    private double[][] cellScores;
    private final Random rnd = new Random();
    private Point start;
    private Point goal;
    private Point agent;

    public GridEnvironment(int size, int obstacleCount) {
        this.size = size;
        this.obstacles = new boolean[size][size];
        this.cellScores = new double[size][size];
        reset(obstacleCount);
    }

    public void reset(int obstacleCount) {
        clearObstacles();
        clearScores();
        placeObstacles(obstacleCount);
        start = randomPerimeterPoint();
        goal = randomPerimeterPointDifferent(start);
        agent = new Point(start);
    }

    private void clearObstacles() {
        for (int y = 0; y < size; y++) for (int x = 0; x < size; x++) obstacles[y][x] = false;
    }

    private void placeObstacles(int count) {
        Set<Integer> used = new HashSet<>();
        while (used.size() < count) {
            int x = 1 + rnd.nextInt(size - 2);
            int y = 1 + rnd.nextInt(size - 2);
            int key = y * size + x;
            if (used.add(key)) obstacles[y][x] = true;
        }
    }

    private void clearScores() {
        for (int y = 0; y < size; y++) for (int x = 0; x < size; x++) cellScores[y][x] = 0.0;
    }

    private Point randomPerimeterPoint() {
        int side = rnd.nextInt(4);
        int coord = rnd.nextInt(size);
        switch (side) {
            case 0: return new Point(0, coord);
            case 1: return new Point(size - 1, coord);
            case 2: return new Point(coord, 0);
            default: return new Point(coord, size - 1);
        }
    }

    private Point randomPerimeterPointDifferent(Point p) {
        Point r;
        do { r = randomPerimeterPoint(); } while (r.equals(p));
        return r;
    }

    public int getSize() { return size; }
    public Point getStart() { return start; }
    public Point getGoal() { return goal; }
    public Point getAgent() { return agent; }
    public boolean isObstacle(int x, int y) { return obstacles[y][x]; }

    // Actions: 0=up,1=right,2=down,3=left
    public StepResult step(int action) {
        Point np = new Point(agent);
        switch (action) {
            case 0 -> np.y = Math.max(0, np.y - 1);
            case 1 -> np.x = Math.min(size - 1, np.x + 1);
            case 2 -> np.y = Math.min(size - 1, np.y + 1);
            case 3 -> np.x = Math.max(0, np.x - 1);
        }
        // wall (attempted move outside bounds results in no position change)
        boolean attemptedOutOfBounds = (action == 0 && agent.y == 0)
                || (action == 1 && agent.x == size - 1)
                || (action == 2 && agent.y == size - 1)
                || (action == 3 && agent.x == 0);
        if (attemptedOutOfBounds && np.equals(agent)) {
            return StepResult.WALL;
        }

        // collision with obstacle
        if (obstacles[np.y][np.x]) {
            agent = new Point(start);
            return StepResult.COLLISION;
        }
        agent = np;
        if (agent.equals(goal)) return StepResult.GOAL;
        return StepResult.CONTINUE;
    }

    public int stateIndex(Point p) { return p.y * size + p.x; }
    public int stateIndexAgent() { return stateIndex(agent); }
    
    public double getCellScore(int x, int y) { return cellScores[y][x]; }
    public void setCellScore(int x, int y, double score) { cellScores[y][x] = score; }
    public void setCellScore(Point p, double score) { setCellScore(p.x, p.y, score); }
}
