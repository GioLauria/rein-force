Param(
  [Parameter(Mandatory=$true)][string]$UploadUrl,
  [Parameter(Mandatory=$true)][string]$AssetPath,
  [Parameter(Mandatory=$true)][string]$AssetName
)

if (-not $env:GITHUB_TOKEN) {
  Write-Error "GITHUB_TOKEN is required"
  exit 1
}

## sanitize and normalize the upload URL (strip any URI template like `{?name,label}`)
$cleanUrl = $UploadUrl -replace '\{.*\}','$null'
$cleanUrl = $cleanUrl.Trim()
if ($cleanUrl.EndsWith('/')) { $cleanUrl = $cleanUrl.TrimEnd('/') }

## URL-encode the asset name for safe query usage
$encodedName = [System.Uri]::EscapeDataString($AssetName)

Write-Host "Uploading $AssetPath as $AssetName to $cleanUrl"

$uri = "$cleanUrl?name=$encodedName"
$headers = @{ Authorization = "Bearer $env:GITHUB_TOKEN" }

Write-Host "Final upload URI: $uri"

try {
  # validate URI before calling
  try { [System.Uri]::new($uri) | Out-Null } catch {
    Write-Error "Constructed upload URI is invalid: $uri`n$($_.Exception.Message)"
    throw
  }

  Invoke-RestMethod -Method Post -Uri $uri -InFile $AssetPath -Headers $headers -ContentType "application/zip"
  Write-Host "Upload completed: $AssetName"
} catch {
  Write-Error "Upload failed: $($_.Exception.Message)"
  throw
}
