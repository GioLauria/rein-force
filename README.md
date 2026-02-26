# Rein-Force Simulator

Simple Java reinforcement-learning style simulator with a GUI. The environment is a square grid containing random obstacles; a spherical bot starts at a random perimeter point A and attempts to reach a random perimeter point B while avoiding obstacles. The agent uses a simple Q-learning table on a discretized grid.

Quick start

The project includes the Maven Wrapper so contributors don't need Maven pre-installed.

Using the Maven Wrapper (recommended)

Windows (PowerShell):

```powershell
.\mvnw.cmd -q -DskipTests package
java -jar target\rein-force-sim-0.1.0.jar
```

macOS / Linux:

```bash
./mvnw -q -DskipTests package
java -jar target/rein-force-sim-0.1.0.jar
```

Using system Maven (if installed):

```bash
mvn -q -DskipTests package
java -jar target/rein-force-sim-0.1.0.jar
```

Run tests:

```bash
./mvnw test
# or on Windows: mvnw.cmd test
```

Run from your IDE:

- Open the project as a Maven project in IntelliJ IDEA or Eclipse.
- Run the `reinforce.sim.AppLauncher` main class.

Notes:
- The Maven Wrapper requires `JAVA_HOME` to point to a JDK. See `CONTRIBUTING.md` or `docs/functionalities/development.md` for instructions to set `JAVA_HOME` if you see a "JAVA_HOME not found" error.

Controls:
- Play: resume simulation
- Stop: pause simulation
- Restart: new environment with random A, B, obstacles
