package reinforce.sim;

import java.awt.Point;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;

public class GridEnvironment {
    public enum StepResult { CONTINUE, COLLISION, WALL, GOAL }

    private final int width;
    private final int height;
    private final boolean[][] obstacles;
    private double[][] cellScores;
    private boolean[][] visited;
    private final Random rnd = new Random();
    private Point start;
    private Point goal;
    private Point agent;
    private static final int MIN_SIZE = 3;

    public GridEnvironment(int size, int obstacleCount) {
        this(size, size, obstacleCount);
    }

    public GridEnvironment(int width, int height, int obstacleCount) {
        if (width < MIN_SIZE || height < MIN_SIZE)
            throw new IllegalArgumentException("width/height must be >= " + MIN_SIZE);
        this.width = width;
        this.height = height;
        this.obstacles = new boolean[height][width];
        this.cellScores = new double[height][width];
        this.visited = new boolean[height][width];
        reset(obstacleCount);
    }

    public void reset(int obstacleCount) {
        clearObstacles();
        clearScores();
        clearVisited();
        placeObstacles(obstacleCount);
        start = randomPerimeterPoint();
        goal = randomPerimeterPointDifferent(start);
        agent = new Point(start);
        visited[agent.y][agent.x] = true;
        // ensure A has value 0
        setCellScore(agent.x, agent.y, 0.0);
    }

    private void clearObstacles() {
        for (int y = 0; y < height; y++) for (int x = 0; x < width; x++) obstacles[y][x] = false;
    }

    private void placeObstacles(int count) {
        int maxInterior = Math.max(0, (width - 2) * (height - 2));
        int toPlace = Math.max(0, Math.min(count, maxInterior));
        if (toPlace == 0) return;
        Set<Integer> used = new HashSet<>();
        while (used.size() < toPlace) {
            int x = 1 + rnd.nextInt(Math.max(1, width - 2));
            int y = 1 + rnd.nextInt(Math.max(1, height - 2));
            int key = y * width + x;
            if (used.add(key)) obstacles[y][x] = true;
        }
    }

    private void clearScores() {
        for (int y = 0; y < height; y++) for (int x = 0; x < width; x++) cellScores[y][x] = 0.0;
    }

    private void clearVisited() {
        for (int y = 0; y < height; y++) for (int x = 0; x < width; x++) visited[y][x] = false;
    }

    private Point randomPerimeterPoint() {
        int side = rnd.nextInt(4);
        int coord;
        switch (side) {
            case 0:
                coord = rnd.nextInt(height);
                return new Point(0, coord);
            case 1:
                coord = rnd.nextInt(height);
                return new Point(width - 1, coord);
            case 2:
                coord = rnd.nextInt(width);
                return new Point(coord, 0);
            default:
                coord = rnd.nextInt(width);
                return new Point(coord, height - 1);
        }
    }

    private Point randomPerimeterPointDifferent(Point p) {
        Point r;
        do { r = randomPerimeterPoint(); } while (r.equals(p));
        return r;
    }

    public int getWidth() { return width; }
    public int getHeight() { return height; }
    public int getSize() { return width; }
    public Point getStart() { return start == null ? null : new Point(start); }
    public Point getGoal() { return goal == null ? null : new Point(goal); }
    public Point getAgent() { return agent == null ? null : new Point(agent); }
    public boolean isObstacle(int x, int y) { return inBounds(x, y) && obstacles[y][x]; }

    private boolean inBounds(int x, int y) { return x >= 0 && x < width && y >= 0 && y < height; }

    // Actions: 0=up,1=right,2=down,3=left
    public StepResult step(int action) {
        Point np = new Point(agent);
        switch (action) {
            case 0 -> np.y = Math.max(0, np.y - 1);
            case 1 -> np.x = Math.min(width - 1, np.x + 1);
            case 2 -> np.y = Math.min(height - 1, np.y + 1);
            case 3 -> np.x = Math.max(0, np.x - 1);
        }
        // wall (attempted move outside bounds results in no position change)
        boolean attemptedOutOfBounds = (action == 0 && agent.y == 0)
                || (action == 1 && agent.x == width - 1)
                || (action == 2 && agent.y == height - 1)
                || (action == 3 && agent.x == 0);
        if (attemptedOutOfBounds && np.equals(agent)) {
            return StepResult.WALL;
        }
        // collision with obstacle: do not reset here, let episode handler decide
        if (!inBounds(np.x, np.y)) {
            return StepResult.WALL;
        }
        if (obstacles[np.y][np.x]) {
            // mark obstacle's cell score strongly negative for future attraction checks
            setCellScore(np.x, np.y, -10.0);
            return StepResult.COLLISION;
        }
        agent = np;
        visited[agent.y][agent.x] = true;
        if (agent.equals(goal)) return StepResult.GOAL;
        return StepResult.CONTINUE;
    }

    public int stateIndex(Point p) {
        if (p == null) throw new IllegalArgumentException("point is null");
        if (!inBounds(p.x, p.y)) throw new IllegalArgumentException("point out of bounds: " + p);
        return p.y * width + p.x;
    }
    public int stateIndexAgent() { return stateIndex(agent); }
    
    public double getCellScore(int x, int y) { return inBounds(x, y) ? cellScores[y][x] : 0.0; }
    public void setCellScore(int x, int y, double score) { if (inBounds(x, y)) cellScores[y][x] = score; }
    public void setCellScore(Point p, double score) { if (p != null) setCellScore(p.x, p.y, score); }
}
