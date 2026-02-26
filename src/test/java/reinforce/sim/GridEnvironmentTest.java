package reinforce.sim;

import org.junit.jupiter.api.Test;

import java.awt.*;

import static org.junit.jupiter.api.Assertions.*;

public class GridEnvironmentTest {
    @Test
    public void testResetAndStep() {
        GridEnvironment env = new GridEnvironment(10, 5);
        Point start = env.getStart();
        Point goal = env.getGoal();
        assertNotNull(start);
        assertNotNull(goal);
        assertNotEquals(start, goal);

        // move agent until either goal or collision occurs
        boolean terminal = false;
        for (int i = 0; i < 1000 && !terminal; i++) {
            GridEnvironment.StepResult r = env.step(1); // try moving right repeatedly
            if (r != GridEnvironment.StepResult.CONTINUE) terminal = true;
        }
    }
}
