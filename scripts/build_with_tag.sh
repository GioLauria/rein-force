#!/usr/bin/env bash
set -euo pipefail

# Use latest tag as revision; fallback to short commit if no tag, default to 'unknown'
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

# Run the Maven wrapper from the repository root (script lives in /scripts)
pushd "$(dirname "$0")/.." >/dev/null

# Build using default Maven output directory (target/)
./mvnw -DskipTests -Drevision="$TAG" package
RC=$?
popd >/dev/null
exit $RC
