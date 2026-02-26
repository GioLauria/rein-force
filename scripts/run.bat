@echo off
REM Build using Maven Wrapper if available, otherwise system Maven
IF EXIST mvnw.cmd (
  call mvnw.cmd -q -DskipTests package
) ELSE (
  mvn -q -DskipTests package
)

REM If first argument is "detach", start without blocking using javaw
IF "%1"=="detach" (
  start "" javaw -jar target\rein-force-sim-0.1.0.jar
) ELSE (
  java -jar target\rein-force-sim-0.1.0.jar
)

EXIT /B %ERRORLEVEL%
