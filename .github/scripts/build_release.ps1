Param(
  [string]$Tag = $env:GITHUB_REF_NAME
)

Write-Host "Build release package (windows) for tag=$Tag"

# build
if (Test-Path mvnw.cmd) {
  & ./mvnw.cmd -DskipTests package
} else {
  mvn -DskipTests package
}

Remove-Item -Recurse -Force image,release -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path image\app,image\bin | Out-Null

Write-Host "Creating runtime image with jlink"
& "$env:JAVA_HOME\bin\jlink.exe" --add-modules java.base,java.desktop --compress=2 --no-header-files --no-man-pages --output image\runtime

Write-Host "Copying jar"
Copy-Item -Path target\*.jar -Destination image\app\rein-force-sim.jar

$runBat = @"
@echo off
set DIR=%~dp0\..
%DIR%\runtime\bin\java -jar %DIR%\app\rein-force-sim.jar %*
"@

Set-Content -Path image\bin\run.bat -Value $runBat -Encoding ASCII

Write-Host "Creating zip"
Compress-Archive -Path image\* -DestinationPath release\rein-force-${Tag}-windows.zip -Force

Write-Host "ARCHIVE=release\rein-force-${Tag}-windows.zip"
