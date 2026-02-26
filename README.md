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

Build with repository revision

To build and embed the current Git tag or commit in the JAR manifest use the helper scripts in `scripts/`:

Windows (Command Prompt / PowerShell):

```powershell
scripts\build_with_tag.bat
```

macOS / Linux:

```bash
./scripts/build_with_tag.sh
```

The scripts set the `Implementation-Version` manifest entry to the latest tag when available, otherwise the short commit id, and finally `unknown` if Git data is unavailable.

Run from your IDE:

- Open the project as a Maven project in IntelliJ IDEA or Eclipse.
- Run the `reinforce.sim.AppLauncher` main class.

Notes:
- The Maven Wrapper requires `JAVA_HOME` to point to a JDK. See `CONTRIBUTING.md` or `docs/functionalities/development.md` for instructions to set `JAVA_HOME` if you see a "JAVA_HOME not found" error.

Running the JAR (foreground vs detached)

Foreground (shows console output, blocks current terminal):

Windows (PowerShell):

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-XX'  # session-only
java -jar target\rein-force-sim-0.1.0.jar
```

macOS / Linux:

```bash
export JAVA_HOME="/path/to/jdk"  # session-only
java -jar target/rein-force-sim-0.1.0.jar
```

Detached / background (returns immediately):

Windows (PowerShell — detached):

```powershell
# Start in a new process and return immediately. Capture PID if desired:
Start-Process -FilePath 'java' -ArgumentList '-jar','target\\rein-force-sim-0.1.0.jar' -PassThru
```

Windows (Command Prompt — detached):

```cmd
start javaw -jar target\rein-force-sim-0.1.0.jar
```

macOS / Linux (detached):

```bash
nohup java -jar target/rein-force-sim-0.1.0.jar > /dev/null 2>&1 &
disown
```

Notes:
- Ensure you run the commands from the project root (the folder containing `pom.xml`).
- To stop a detached process, locate its PID (`ps` / Task Manager) and terminate it.

Controls:
- Play: resume simulation
- Stop: pause simulation
- Restart: new environment with random A, B, obstacles

GUI status overlay:

- **Iterations:** number of training/steps completed since the current run started.
- **Average duration:** moving average of iteration durations (ms) shown to help gauge performance.
- **Last duration:** duration (ms) of the most recent iteration.

These three values are displayed at the top of the GUI while the simulator runs.
They are useful for checking performance regressions (longer iteration times) and ensuring the environment is progressing.
