package reinforce.sim;

import javax.swing.*;
import java.awt.*;

public class AppLauncher {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame frame = new JFrame("Rein-Force Simulator");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setLayout(new BorderLayout());

            Simulator sim = new Simulator(20, 40); // 20x20 grid with 40 obstacles
            SimulatorPanel panel = new SimulatorPanel(sim);
            ControlPanel controls = new ControlPanel(sim);

            frame.add(panel, BorderLayout.CENTER);
            frame.add(controls, BorderLayout.SOUTH);
            frame.setSize(800, 860);
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);

            sim.setView(panel);
            sim.start();
        });
    }
}
