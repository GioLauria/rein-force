@echo off
REM Windows pre-commit hook: compile project using mvnw or mvn
setlocal
SET ROOT=%~dp0..
cd /d %ROOT%

IF EXIST mvnw.cmd (
  set MVN=mvnw.cmd
) ELSE (
  set MVN=mvn
)

echo [pre-commit] Running quick build check with %MVN%
%MVN% -q -DskipTests package
IF %ERRORLEVEL% NEQ 0 (
  echo [pre-commit] Build failed — aborting commit
  exit /b 1
)

echo [pre-commit] Build OK
endlocal
exit /b 0
