@echo off
REM Determine revision (latest v* tag or short commit) and pass to mvn
setlocal
set "TAG="

for /f "delims=" %%t in ('git describe --tags --abbrev=0 2^>nul') do set "TAG=%%t"
if not defined TAG (
  for /f "delims=" %%c in ('git rev-parse --short HEAD 2^>nul') do set "TAG=%%c"
)
if not defined TAG set "TAG=unknown"

echo Building with revision=%TAG%

REM Build using Maven Wrapper if available, otherwise system Maven
IF EXIST mvnw.cmd (
  call mvnw.cmd -q -DskipTests -Drevision=%TAG% package
) ELSE (
  mvn -q -DskipTests -Drevision=%TAG% package
)

REM Find produced JAR
set "JAR="
for %%f in (target\*.jar) do (
  set "JAR=%%f"
  goto :gotJar
)
:gotJar
if not defined JAR (
  echo No JAR found in target\
  endlocal
  exit /b 1
)

REM If first argument is "detach", start without blocking using javaw
IF "%1"=="detach" (
  start "" javaw -jar "%JAR%"
) ELSE (
  java -jar "%JAR%"
)

endlocal
EXIT /B %ERRORLEVEL%
