package reinforce.sim;

import java.awt.BorderLayout;
import java.awt.Dimension;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;

public class AppLauncher {
    public static void main(String[] args) {
        // apply system look & feel where available
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ignored) {}

        SwingUtilities.invokeLater(() -> {
            try {
                int gridSize = 20;
                int obstacleCount = 40;
                if (args.length >= 1) {
                    try { gridSize = Integer.parseInt(args[0]); } catch (NumberFormatException ex) { /* keep default */ }
                }
                if (args.length >= 2) {
                    try { obstacleCount = Integer.parseInt(args[1]); } catch (NumberFormatException ex) { /* keep default */ }
                }
                if (gridSize < 3) gridSize = 3;
                if (obstacleCount < 0) obstacleCount = 0;

                JFrame frame = new JFrame("Rein-Force Simulator");
                frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                frame.setLayout(new BorderLayout());

                Simulator sim = new Simulator(gridSize, obstacleCount);
                SimulatorPanel panel = new SimulatorPanel(sim);
                ControlPanel controls = new ControlPanel(sim);

                frame.add(panel, BorderLayout.CENTER);
                frame.add(controls, BorderLayout.SOUTH);
                frame.pack();
                // ensure a sensible minimum size
                Dimension min = panel.getPreferredSize();
                frame.setMinimumSize(new Dimension(Math.max(400, min.width), Math.max(200, min.height + 60)));
                frame.setLocationRelativeTo(null);
                frame.setVisible(true);

                sim.setView(panel);
                sim.start();
            } catch (Throwable t) {
                t.printStackTrace();
                JOptionPane.showMessageDialog(null, "Failed to start simulator: " + t.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            }
        });
    }
}
