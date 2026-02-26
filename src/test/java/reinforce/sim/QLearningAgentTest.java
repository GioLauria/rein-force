package reinforce.sim;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class QLearningAgentTest {
    @Test
    public void testUpdateChangesQ() {
        QLearningAgent agent = new QLearningAgent(4);
        double[][] before = agent.getQ();
        int s = 0, a = 1, sNext = 2;
        agent.update(s, a, 1.0, sNext, false);
        double[][] after = agent.getQ();
        assertNotEquals(before[s][a], after[s][a]);
    }
}
