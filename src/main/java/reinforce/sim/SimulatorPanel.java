package reinforce.sim;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.RenderingHints;

import javax.swing.JPanel;

public class SimulatorPanel extends JPanel {
    private final Simulator sim;

    public SimulatorPanel(Simulator sim) {
        this.sim = sim;
        setPreferredSize(new Dimension(800, 800));
        setBackground(Color.WHITE);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

        GridEnvironment env = sim.getEnvironment();
        int size = env.getSize();
        int w = getWidth();
        int h = getHeight();
        if (size <= 0) return;
        int cell = Math.min(w, h) / size;
        if (cell <= 0) return;

        // compute offsets to center the grid
        int gridPx = cell * size;
        int ox = (w - gridPx) / 2;
        int oy = (h - gridPx) / 2;

        // draw grid
        g2.setColor(Color.LIGHT_GRAY);
        for (int i = 0; i <= size; i++) {
            g2.drawLine(ox, oy + i * cell, ox + size * cell, oy + i * cell);
            g2.drawLine(ox + i * cell, oy, ox + i * cell, oy + size * cell);
        }

        // obstacles
        g2.setColor(Color.DARK_GRAY);
        for (int y = 0; y < size; y++) for (int x = 0; x < size; x++)
            if (env.isObstacle(x, y)) g2.fillRect(ox + x * cell, oy + y * cell, cell, cell);

        // cell score heatmap (draw under agent)
        double maxAbs = 1.0;
        for (int y = 0; y < size; y++) for (int x = 0; x < size; x++) {
            double s = env.getCellScore(x, y);
            if (Math.abs(s) > maxAbs) maxAbs = Math.abs(s);
        }
        for (int y = 0; y < size; y++) for (int x = 0; x < size; x++) {
            double s = env.getCellScore(x, y);
            float norm = (float)(s / maxAbs);
            if (Math.abs(norm) < 1e-6) continue;
            Color c;
            if (norm > 0) {
                // positive -> red tint
                float v = Math.min(1.0f, norm);
                c = new Color(1.0f, 1.0f - v, 1.0f - v);
            } else {
                // negative -> blue tint
                float v = Math.min(1.0f, (float)-norm);
                c = new Color(1.0f - v, 1.0f - v, 1.0f);
            }
            g2.setColor(new Color(c.getRed(), c.getGreen(), c.getBlue(), 64));
            g2.fillRect(ox + x * cell, oy + y * cell, cell, cell);
        }

        // start and goal
        g2.setColor(Color.BLUE);
        Point s = env.getStart();
        g2.fillOval(ox + s.x * cell + cell/4, oy + s.y * cell + cell/4, cell/2, cell/2);
        g2.setColor(Color.GREEN.darker());
        Point gP = env.getGoal();
        g2.fillOval(ox + gP.x * cell + cell/4, oy + gP.y * cell + cell/4, cell/2, cell/2);

        // agent
        Point a = env.getAgent();
        g2.setColor(Color.RED);
        g2.fillOval(ox + a.x * cell + cell/6, oy + a.y * cell + cell/6, cell*2/3, cell*2/3);

        // overlay stats (top-left)
        String stats = String.format("Iterations: %d  Points: %.1f",
            sim.getIterations(), sim.getTotalPoints());
        java.awt.FontMetrics fm = g2.getFontMetrics();
        int textW = fm.stringWidth(stats);
        int textH = fm.getHeight();
        int pad = 6;
        int bx = 6, by = 6;
        g2.setColor(Color.WHITE);
        g2.fillRect(bx, by, textW + pad, textH + pad/2);
        g2.setColor(Color.BLACK);
        g2.drawString(stats, bx + 4, by + fm.getAscent());
    }
}
