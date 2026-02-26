Param(
  [Parameter(Mandatory=$true)][string]$UploadUrl,
  [Parameter(Mandatory=$true)][string]$AssetPath,
  [Parameter(Mandatory=$true)][string]$AssetName
)

if (-not $env:GITHUB_TOKEN) {
  Write-Error "GITHUB_TOKEN is required"
  exit 1
}

$cleanUrl = if ($UploadUrl -match '\{') { $UploadUrl.Split('{')[0] } else { $UploadUrl }
Write-Host "Uploading $AssetPath as $AssetName to $cleanUrl"

$uri = "$cleanUrl?name=$AssetName"
$headers = @{ Authorization = "Bearer $env:GITHUB_TOKEN" }

try {
  Invoke-RestMethod -Method Post -Uri $uri -InFile $AssetPath -Headers $headers -ContentType "application/zip"
  Write-Host "Upload completed: $AssetName"
} catch {
  Write-Error "Upload failed: $($_.Exception.Message)"
  throw
}
