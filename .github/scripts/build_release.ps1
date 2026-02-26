Param(
  [string]$Tag = $env:GITHUB_REF_NAME
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

Write-Host "Build release package (windows) for tag=$Tag"

# build
if (Test-Path mvnw.cmd) {
  Write-Host "Using mvnw.cmd"
  & ./mvnw.cmd -DskipTests package
} else {
  Write-Host "Using system mvn"
  mvn -DskipTests package
}

# ensure clean layout
if (Test-Path image) { Remove-Item -Recurse -Force image }
if (Test-Path release) { Remove-Item -Recurse -Force release }
New-Item -ItemType Directory -Path image\app,image\bin,release | Out-Null

Write-Host "Checking for jlink"
if (-not (Test-Path (Join-Path $env:JAVA_HOME "bin\jlink.exe"))) {
  Write-Warning "jlink not found at $env:JAVA_HOME\bin\jlink.exe"
  throw "jlink is required to create the runtime image. Ensure JDK includes jlink or adjust packaging."
}

Write-Host "Creating runtime image with jlink"
& "$env:JAVA_HOME\bin\jlink.exe" --add-modules java.base,java.desktop --compress=2 --no-header-files --no-man-pages --output image\runtime

Write-Host "Locating built jar in target"
$jar = Get-ChildItem -Path target -Filter *.jar -File -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $jar) {
  throw "No jar artifact found in target/. Make sure the Maven build succeeded."
}

Write-Host "Copying jar $($jar.FullName)"
Copy-Item -Path $jar.FullName -Destination image\app\rein-force-sim.jar

$runBat = @"
@echo off
set DIR=%~dp0\..
%DIR%\runtime\bin\java -jar %DIR%\app\rein-force-sim.jar %*
"@

Set-Content -Path image\bin\run.bat -Value $runBat -Encoding ASCII

Write-Host "Creating zip"
Compress-Archive -Path image\* -DestinationPath release\rein-force-${Tag}-windows.zip -Force

if (-not (Test-Path (Join-Path (Get-Location) "release\rein-force-${Tag}-windows.zip"))) {
  throw "Expected archive not found: release\rein-force-${Tag}-windows.zip"
}

Write-Host "ARCHIVE=release\rein-force-${Tag}-windows.zip"
