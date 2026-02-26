#!/usr/bin/env bash
set -euo pipefail

# Build using Maven Wrapper if present
if [ -x ./mvnw ]; then
  ./mvnw -q -DskipTests package
else
  mvn -q -DskipTests package
fi

if [ "${1:-}" = "detach" ]; then
  nohup java -jar target/rein-force-sim-0.1.0.jar > /dev/null 2>&1 &
  disown || true
  echo "Started in background"
else
  java -jar target/rein-force-sim-0.1.0.jar
fi
