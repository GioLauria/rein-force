package reinforce.sim;

import java.util.Arrays;
import java.util.Random;

public class QLearningAgent {
    private final int stateCount;
    private final int actionCount = 4;
    private final double[][] q;
    private final Random rnd = new Random();
    private double alpha = 0.2;
    private double gamma = 0.95;
    private double epsilon = 0.1;

    public QLearningAgent(int stateCount) {
        this.stateCount = stateCount;
        this.q = new double[stateCount][actionCount];
    }

    public int chooseAction(int state) {
        if (rnd.nextDouble() < epsilon) return rnd.nextInt(actionCount);
        double[] row = q[state];
        int best = 0;
        for (int a = 1; a < actionCount; a++) if (row[a] > row[best]) best = a;
        return best;
    }

    public void update(int s, int a, double reward, int sNext, boolean done) {
        double qsa = q[s][a];
        double maxNext = 0;
        if (!done) {
            double[] nextRow = q[sNext];
            maxNext = Arrays.stream(nextRow).max().orElse(0.0);
        }
        q[s][a] = qsa + alpha * (reward + gamma * maxNext - qsa);
    }

    public double[][] getQ() { return q; }
    public void setEpsilon(double e) { this.epsilon = e; }
}
