param(
  [Parameter(Mandatory=$true)][string]$Tag
)

Set-StrictMode -Version Latest

Set-Location (git rev-parse --show-toplevel)

& .\scripts\update_changelog.ps1

& .\scripts\update_changelog.ps1

# Move Unreleased -> tag section, create empty Unreleased, and commit changelog
$content = Get-Content CHANGELOG.md -Raw
$unPat = '(?ms)^## \[Unreleased\]\s*(.*?)^(?=## \[|\z)'
$mUn = [Regex]::Match($content, $unPat)
$tmpMsg = [System.IO.Path]::GetTempFileName()
if ($mUn.Success) {
    $unSection = $mUn.Groups[1].Value.Trim()
} else {
    $unSection = ''
}

if ($unSection -ne '') {
    $date = (Get-Date).ToString('yyyy-MM-dd')
    $tagSection = "## [$Tag] - $date`n`n" + $unSection + "`n`n"
} else {
    $tagSection = "Release $Tag`n"
}

# Replace Unreleased with empty placeholder and insert tag section after Unreleased header
$new = [Regex]::Replace($content, '(?ms)(^## \[Unreleased\]\s*).*?(?=^## \[|\z)', "`$1`n- Placeholder for upcoming changes.`n`n" + [Regex]::Escape(""))
# Now insert the tagSection immediately after the Unreleased header block
$new = $new -replace '(?ms)(^## \[Unreleased\]\s*\n- Placeholder for upcoming changes\.[\r\n]*\n)', "`$1" + $tagSection

Set-Content -Path CHANGELOG.md -Value $new -Encoding UTF8

# commit changelog if changed
if (-not (git diff --quiet -- CHANGELOG.md)) {
  git add CHANGELOG.md
  git commit -m "chore(release): move Unreleased -> $Tag and clear Unreleased"
}

# write tag message file
[System.IO.File]::WriteAllText($tmpMsg, $tagSection.Trim() + "`n")

# ensure annotated tag exists (replace if existing) using the prepared tag message
if (git rev-parse -q --verify "refs/tags/$Tag" 2>$null) {
  git tag -f -a $Tag -F $tmpMsg
} else {
  git tag -a $Tag -F $tmpMsg
}

# push commit (if any) and force-update tag on remote
try { git push } catch { Write-Host "git push failed (non-fatal)" }

git push origin --force "refs/tags/$Tag"

Remove-Item $tmpMsg -ErrorAction SilentlyContinue
