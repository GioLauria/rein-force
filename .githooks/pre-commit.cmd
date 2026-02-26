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

echo [pre-commit] Running full package build with %MVN% (this may run tests)
%MVN% package
IF %ERRORLEVEL% NEQ 0 (
  echo [pre-commit] Build failed (exit %ERRORLEVEL%) — aborting commit
  endlocal
  exit /b %ERRORLEVEL%
)

echo [pre-commit] Build OK
endlocal
exit /b 0
