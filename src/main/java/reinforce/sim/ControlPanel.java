package reinforce.sim;

import java.awt.FlowLayout;

import javax.swing.JButton;
import javax.swing.JPanel;

public class ControlPanel extends JPanel {
    public ControlPanel(Simulator sim) {
        if (sim == null) throw new IllegalArgumentException("sim must not be null");
        setLayout(new FlowLayout(FlowLayout.CENTER));
        JButton play = new JButton("Play");
        JButton stop = new JButton("Stop");
        JButton restart = new JButton("Restart");

        play.setToolTipText("Start the simulator");
        stop.setToolTipText("Stop the simulator");
        restart.setToolTipText("Restart the environment and statistics");

        play.setMnemonic('P');
        stop.setMnemonic('S');
        restart.setMnemonic('R');

        // initialize button enabled state from simulator
        play.setEnabled(!sim.isRunning());
        stop.setEnabled(sim.isRunning());

        play.addActionListener(e -> {
            try {
                if (!sim.isRunning()) {
                    sim.start();
                    play.setEnabled(false);
                    stop.setEnabled(true);
                }
            } catch (RuntimeException ex) {
                // swallow to avoid UI crash; caller can inspect logs
                ex.printStackTrace();
            }
        });

        stop.addActionListener(e -> {
            try {
                if (sim.isRunning()) {
                    sim.stop();
                    play.setEnabled(true);
                    stop.setEnabled(false);
                }
            } catch (RuntimeException ex) {
                ex.printStackTrace();
            }
        });

        restart.addActionListener(e -> {
            try {
                // restart() stops, resets and starts again
                sim.restart();
                // after restart simulator is running
                play.setEnabled(false);
                stop.setEnabled(true);
            } catch (RuntimeException ex) {
                ex.printStackTrace();
            }
        });

        add(play);
        add(stop);
        add(restart);
    }
}
