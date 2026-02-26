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
call mvnw.cmd -DskipTests -Drevision=%TAG% package
set "RC=%errorlevel%"

rem If build succeeded, copy the produced JAR to the repository root
if "%RC%" == "0" (
  set "JAR=target\rein-force-sim-%TAG%.jar"
  if exist "%JAR%" (
    copy /Y "%JAR%" "rein-force-sim-%TAG%.jar" >nul
  ) else (
    rem fallback: copy any matching jar
    for %%f in (target\rein-force-sim-*.jar) do (
      copy /Y "%%f" "rein-force-sim-%TAG%.jar" >nul
      goto :copied
    )
  )
)
:copied
popd
exit /b %RC%
