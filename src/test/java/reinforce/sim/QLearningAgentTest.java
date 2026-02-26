package reinforce.sim;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class QLearningAgentTest {
    @Test
    public void testUpdateChangesQ() {
        QLearningAgent agent = new QLearningAgent(4);
        int s = 0, a = 1, sNext = 2;
        double before = agent.getQ()[s][a];
        agent.update(s, a, 1.0, sNext, false);
        double after = agent.getQ()[s][a];
        assertNotEquals(before, after);
    }
}
