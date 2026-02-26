@echo off
rem Use latest tag as revision; fallback to short commit if no tag
setlocal enabledelayedexpansion
for /f "delims=" %%t in ('git describe --tags --abbrev=0 2^>nul') do set TAG=%%t
if not defined TAG (
  for /f "delims=" %%c in ('git rev-parse --short HEAD') do set TAG=%%c
)

echo Building with revision=%TAG%
call mvnw.cmd -DskipTests -Drevision=%TAG% package
