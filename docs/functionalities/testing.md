# Testing

Responsibility: describe unit tests and manual test procedures.

Unit tests
- Tests live under `src/test/java/reinforce/sim` and use JUnit 5.
- Run tests with:

```bash
mvn test
```

Manual testing / smoke tests
- Build the runnable artifact:

```bash
mvn -DskipTests package
java -jar target/rein-force-sim-0.1.0.jar
```

- Verify:
  - GUI launches and shows a grid, start (blue), goal (green), and agent (red).
  - Press `Stop` and `Play` to pause/resume.
  - Press `Restart` to generate a new environment.
  - Observe agent respawn on collision and success on reaching goal.

Automated test recommendations
- Add deterministic tests by seeding RNG or exposing constructors that accept a `Random` instance.
