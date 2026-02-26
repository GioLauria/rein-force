#!/usr/bin/env bash
set -euo pipefail

TAG=${1:-unknown}
RELEASE_DIR=release

echo "Build release package (linux) for tag=$TAG"

# ensure wrapper is executable
if [ -f mvnw ]; then chmod +x mvnw || true; fi

# build artifact
if [ -f mvnw ]; then
  ./mvnw -DskipTests package
elif [ -f mvnw.cmd ]; then
  ./mvnw.cmd -DskipTests package
else
  mvn -DskipTests package
fi

rm -rf image "$RELEASE_DIR"
mkdir -p image/app image/bin

echo "Creating runtime image with jlink"
"$JAVA_HOME/bin/jlink" --add-modules java.base,java.desktop --compress=2 --no-header-files --no-man-pages --output image/runtime

echo "Copying jar"
cp target/*.jar image/app/rein-force-sim.jar

cat > image/bin/run.sh <<'SH'
#!/usr/bin/env sh
DIR="$(cd "$(dirname "$0")/.." && pwd)"
"$DIR/runtime/bin/java" -jar "$DIR/app/rein-force-sim.jar" "$@"
SH
chmod +x image/bin/run.sh

mkdir -p "$RELEASE_DIR"
ARCHIVE="$RELEASE_DIR/rein-force-${TAG}-linux.zip"
echo "Creating archive $ARCHIVE"
cd image
zip -r ../"$ARCHIVE" .
cd - >/dev/null

echo "ARCHIVE=$ARCHIVE"
