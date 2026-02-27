@echo off
REM Run changelog updater after each commit (Windows hook entrypoint)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\scripts\post_commit_update_changelog.ps1"
exit /b 0
