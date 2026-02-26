# Rein-Force Simulator

Simple Java reinforcement-learning style simulator with a GUI. The environment is a square grid containing random obstacles; a spherical bot starts at a random perimeter point A and attempts to reach a random perimeter point B while avoiding obstacles. The agent uses a simple Q-learning table on a discretized grid.

Quick start

```bash
cd "simulator"
mvn -q -DskipTests package
java -jar target/rein-force-sim-0.1.0.jar
```

Controls:
- Play: resume simulation
- Stop: pause simulation
- Restart: new environment with random A, B, obstacles
