#!/usr/bin/env bash
set -euo pipefail

# Determine revision (latest v* tag or short commit) so builds embed the same
# revision used for releases. This mirrors `scripts/build_with_tag.sh` behavior.
TAG=""
if TAG=$(git describe --tags --abbrev=0 2>/dev/null); then
  :
else
  if TAG=$(git rev-parse --short HEAD 2>/dev/null); then
    :
  else
    TAG="unknown"
  fi
fi

echo "Building with revision=$TAG"

# Build using Maven Wrapper if present, passing -Drevision so the artifact
# (and any generated resources) reflect the chosen revision.
if [ -x ./mvnw ]; then
  ./mvnw -q -DskipTests -Drevision="$TAG" package
else
  mvn -q -DskipTests -Drevision="$TAG" package
fi

# Locate the first JAR produced under target/ and run it so script works
# regardless of artifact version string in the filename.
JAR=$(ls target/*.jar 2>/dev/null | head -n1 || true)
if [ -z "$JAR" ]; then
  echo "No JAR found in target/" >&2
  exit 1
fi

if [ "${1:-}" = "detach" ]; then
  nohup java -jar "$JAR" > /dev/null 2>&1 &
  disown || true
  echo "Started in background"
else
  java -jar "$JAR"
fi
