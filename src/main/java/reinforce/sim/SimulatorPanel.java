package reinforce.sim;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Point;

import javax.swing.JPanel;

public class SimulatorPanel extends JPanel {
    private final Simulator sim;

    public SimulatorPanel(Simulator sim) {
        this.sim = sim;
        setPreferredSize(new Dimension(800, 800));
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        GridEnvironment env = sim.getEnvironment();
        int size = env.getSize();
        int w = getWidth();
        int h = getHeight();
        int cell = Math.min(w, h) / size;

        // draw background
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, w, h);

        // draw grid
        g.setColor(Color.LIGHT_GRAY);
        for (int i = 0; i <= size; i++) {
            g.drawLine(0, i * cell, size * cell, i * cell);
            g.drawLine(i * cell, 0, i * cell, size * cell);
        }

        // obstacles
        g.setColor(Color.DARK_GRAY);
        for (int y = 0; y < size; y++) for (int x = 0; x < size; x++)
            if (env.isObstacle(x, y)) g.fillRect(x * cell, y * cell, cell, cell);

        // start and goal
        g.setColor(Color.BLUE);
        Point s = env.getStart();
        g.fillOval(s.x * cell + cell/4, s.y * cell + cell/4, cell/2, cell/2);
        g.setColor(Color.GREEN.darker());
        Point gP = env.getGoal();
        g.fillOval(gP.x * cell + cell/4, gP.y * cell + cell/4, cell/2, cell/2);

        // agent
        Point a = env.getAgent();
        g.setColor(Color.RED);
        g.fillOval(a.x * cell + cell/6, a.y * cell + cell/6, cell*2/3, cell*2/3);
    }
}
