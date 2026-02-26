@echo off
rem Use latest tag as revision; fallback to short commit if no tag
setlocal
set "TAG="

for /f "delims=" %%t in ('git describe --tags --abbrev=0 2^>nul') do set "TAG=%%t"
if not defined TAG (
  for /f "delims=" %%c in ('git rev-parse --short HEAD 2^>nul') do set "TAG=%%c"
)

if not defined TAG set "TAG=unknown"

echo Building with revision=%TAG%

rem Ensure we run the Maven wrapper from the repository root (script is in /scripts)
pushd "%~dp0.."

rem Build using default Maven output directory (`target/`)
call mvnw.cmd -DskipTests -Drevision=%TAG% package
set "RC=%errorlevel%"

popd
exit /b %RC%
exit /b %RC%
