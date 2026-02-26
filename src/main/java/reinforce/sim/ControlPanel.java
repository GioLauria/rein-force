package reinforce.sim;

import java.awt.FlowLayout;

import javax.swing.JButton;
import javax.swing.JPanel;

public class ControlPanel extends JPanel {
    public ControlPanel(Simulator sim) {
        setLayout(new FlowLayout(FlowLayout.CENTER));
        JButton play = new JButton("Play");
        JButton stop = new JButton("Stop");
        JButton restart = new JButton("Restart");

        play.addActionListener(e -> {
            if (!sim.isRunning()) sim.start();
        });
        stop.addActionListener(e -> sim.stop());
        restart.addActionListener(e -> sim.restart());

        add(play);
        add(stop);
        add(restart);
    }
}
