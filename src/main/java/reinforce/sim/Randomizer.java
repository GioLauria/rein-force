package reinforce.sim;

import java.util.Random;

/**
 * Small utility that selects an action index from a set of scores using
 * a probabilistic softmax sampling. This serves as the "randomizer" item.
 */
public final class Randomizer {
    private final Random rnd;

    public Randomizer(Random rnd) { this.rnd = rnd == null ? new Random() : rnd; }

    public int sampleSoftmax(double[] scores) {
        if (scores == null || scores.length == 0) return 0;
        // numeric safe softmax: shift by max
        double max = Double.NEGATIVE_INFINITY;
        for (double s : scores) if (s > max) max = s;
        double sum = 0.0;
        double[] exps = new double[scores.length];
        for (int i = 0; i < scores.length; i++) {
            double v = Math.exp(scores[i] - max);
            exps[i] = v;
            sum += v;
        }
        if (sum <= 0.0) return rnd.nextInt(scores.length);
        double r = rnd.nextDouble() * sum;
        double acc = 0.0;
        for (int i = 0; i < exps.length; i++) {
            acc += exps[i];
            if (r <= acc) return i;
        }
        return exps.length - 1;
    }
}
