#!/usr/bin/env bash
set -euo pipefail

# Find the latest annotated tag (fallback to HEAD if none)
TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "$(git rev-parse --short HEAD)")
echo "Building with revision=$TAG"
./mvnw -DskipTests -Drevision="$TAG" package
