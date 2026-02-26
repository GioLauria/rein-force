Param(
  [Parameter(Mandatory=$true)][string]$UploadUrl,
  [Parameter(Mandatory=$true)][string]$AssetPath,
  [Parameter(Mandatory=$true)][string]$AssetName
)

if (-not $env:GITHUB_TOKEN) {
  Write-Error "GITHUB_TOKEN is required"
  exit 1
}

$cleanUrl = $UploadUrl -replace '\{.*\}',''
$cleanUrl = $cleanUrl.Trim()
if ($cleanUrl.EndsWith('/')) { $cleanUrl = $cleanUrl.TrimEnd('/') }

## URL-encode the asset name for safe query usage
$encodedName = [System.Uri]::EscapeDataString($AssetName)

Write-Host "Uploading $AssetPath as $AssetName to $cleanUrl"

$uri = "$cleanUrl?name=$encodedName"
$headers = @{ Authorization = "Bearer $env:GITHUB_TOKEN" }

Write-Host "Raw UploadUrl: <$UploadUrl>"
Write-Host "Clean UploadUrl: <$cleanUrl>"

# Basic sanity check
if (-not ($cleanUrl -match '^https?://')) {
  Write-Error "UploadUrl does not look like a valid HTTPS URL: <$cleanUrl>"
  exit 1
}

# Build the final upload URI safely using UriBuilder (handles trailing slashes and existing query)
try {
  $baseUri = [System.Uri]::new($cleanUrl)
} catch {
  Write-Error "Clean upload URL is invalid: <$cleanUrl> -- $($_.Exception.Message)"
  throw
}

$builder = New-Object System.UriBuilder($baseUri)
$currentQuery = $builder.Query
if ($currentQuery -and $currentQuery.StartsWith('?')) { $currentQuery = $currentQuery.Substring(1) }
if ([string]::IsNullOrEmpty($currentQuery)) {
  $builder.Query = "name=$encodedName"
} else {
  $builder.Query = "$currentQuery&name=$encodedName"
}

$uri = $builder.Uri.AbsoluteUri
Write-Host "Final upload URI: $uri"

try {
  # validate URI object
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
