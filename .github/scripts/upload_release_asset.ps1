Param(
  [Parameter(Mandatory=$true)][string]$UploadUrl,
  [Parameter(Mandatory=$true)][string]$AssetPath,
  [Parameter(Mandatory=$true)][string]$AssetName
)

if (-not $env:GITHUB_TOKEN) {
  Write-Error "GITHUB_TOKEN is required"
  exit 1
}

Write-Host "Uploading $AssetPath as $AssetName to $UploadUrl"

$uri = "$UploadUrl?name=$AssetName"
$headers = @{ Authorization = "Bearer $env:GITHUB_TOKEN" }

try {
  Invoke-RestMethod -Method Post -Uri $uri -InFile $AssetPath -Headers $headers -ContentType "application/zip"
  Write-Host "Upload completed: $AssetName"
} catch {
  Write-Error "Upload failed: $($_.Exception.Message)"
  throw
}
