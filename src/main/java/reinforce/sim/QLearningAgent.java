package reinforce.sim;

import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class QLearningAgent {
    private final int stateCount;
    private final int actionCount;
    private final double[][] q;
    private final Random rnd;
    private double alpha = 0.2;
    private double gamma = 0.95;
    private double epsilon = 0.1;

    public QLearningAgent(int stateCount) {
        this(stateCount, 4, new Random());
    }

    public QLearningAgent(int stateCount, int actionCount) {
        this(stateCount, actionCount, new Random());
    }

    public QLearningAgent(int stateCount, int actionCount, Random rnd) {
        if (stateCount <= 0) throw new IllegalArgumentException("stateCount must be > 0");
        if (actionCount <= 0) throw new IllegalArgumentException("actionCount must be > 0");
        this.stateCount = stateCount;
        this.actionCount = actionCount;
        this.q = new double[stateCount][actionCount];
        this.rnd = rnd == null ? new Random() : rnd;
    }

    private void checkState(int s) {
        if (s < 0 || s >= stateCount) throw new IllegalArgumentException("invalid state: " + s);
    }

    private void checkAction(int a) {
        if (a < 0 || a >= actionCount) throw new IllegalArgumentException("invalid action: " + a);
    }

    public int chooseAction(int state) {
        checkState(state);
        if (rnd.nextDouble() < epsilon) return rnd.nextInt(actionCount);
        double[] row = q[state];
        List<Integer> bests = new ArrayList<>();
        double bestVal = Double.NEGATIVE_INFINITY;
        for (int a = 0; a < actionCount; a++) {
            double val = row[a];
            int cmp = Double.compare(val, bestVal);
            if (cmp > 0) {
                bests.clear();
                bests.add(a);
                bestVal = val;
            } else if (cmp == 0) {
                bests.add(a);
            }
        }
        return bests.get(rnd.nextInt(bests.size()));
    }

    public int chooseActionWithAttraction(int state, double[] neighborScores, double attractionWeight) {
        checkState(state);
        if (rnd.nextDouble() < epsilon) return rnd.nextInt(actionCount);
        double[] row = q[state];
        // clamp attraction weight to reasonable range
        double w = Double.isFinite(attractionWeight) ? Math.max(0.0, Math.min(1.0, attractionWeight)) : 0.0;
        List<Integer> bests = new ArrayList<>();
        double bestVal = Double.NEGATIVE_INFINITY;
        for (int a = 0; a < actionCount; a++) {
            double attr = (neighborScores != null && neighborScores.length > a) ? neighborScores[a] : 0.0;
            double val = row[a] + w * attr;
            int cmp = Double.compare(val, bestVal);
            if (cmp > 0) {
                bests.clear();
                bests.add(a);
                bestVal = val;
            } else if (cmp == 0) {
                bests.add(a);
            }
        }
        return bests.get(rnd.nextInt(bests.size()));
    }

    public void update(int s, int a, double reward, int sNext, boolean done) {
        checkState(s);
        checkAction(a);
        double qsa = q[s][a];
        double maxNext = 0.0;
        if (!done) {
            checkState(sNext);
            double[] nextRow = q[sNext];
            double m = Double.NEGATIVE_INFINITY;
            for (int i = 0; i < nextRow.length; i++) if (nextRow[i] > m) m = nextRow[i];
            if (m != Double.NEGATIVE_INFINITY) maxNext = m;
        }
        q[s][a] = qsa + alpha * (reward + gamma * maxNext - qsa);
    }

    public double[][] getQ() {
        double[][] copy = new double[stateCount][actionCount];
        for (int i = 0; i < stateCount; i++) copy[i] = Arrays.copyOf(q[i], actionCount);
        return copy;
    }

    public int getStateCount() { return stateCount; }
    public int getActionCount() { return actionCount; }

    public double getAlpha() { return alpha; }
    public void setAlpha(double alpha) { this.alpha = Math.max(0.0, Math.min(1.0, alpha)); }

    public double getGamma() { return gamma; }
    public void setGamma(double gamma) { this.gamma = Math.max(0.0, Math.min(1.0, gamma)); }

    public double getEpsilon() { return epsilon; }
    public void setEpsilon(double e) { this.epsilon = Math.max(0.0, Math.min(1.0, e)); }
}
