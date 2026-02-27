param(
  [Parameter(Mandatory=$true)][string]$Tag
)

Set-StrictMode -Version Latest

Set-Location (git rev-parse --show-toplevel)

& .\scripts\update_changelog.ps1

# commit changelog if changed
if (-not (git diff --quiet -- CHANGELOG.md)) {
  git add CHANGELOG.md
  git commit -m "chore(release): update CHANGELOG for $Tag"
}

# extract the changelog section for this tag (header may include date)
$tmp = [System.IO.Path]::GetTempFileName()
$content = Get-Content CHANGELOG.md -Raw
$pattern = "(?ms)^## \[" + [Regex]::Escape($Tag) + "\](?:\s*-.*)?\s*(.*?)^## \[|(?ms)^## \[" + [Regex]::Escape($Tag) + "\](?:\s*-.*)?\s*(.*)$"
$m = [Regex]::Match($content, $pattern)
if ($m.Success) {
    $section = $m.Groups[1].Value
    if ([string]::IsNullOrWhiteSpace($section)) { $section = $m.Groups[2].Value }
    if ([string]::IsNullOrWhiteSpace($section)) { $section = "Release $Tag" }
} else {
    $section = "Release $Tag"
}

[System.IO.File]::WriteAllText($tmp, $section.Trim() + "`n")

# ensure annotated tag exists (replace if existing) using changelog section as message
if (git rev-parse -q --verify "refs/tags/$Tag" 2>$null) {
  git tag -f -a $Tag -F $tmp
} else {
  git tag -a $Tag -F $tmp
}

# push commit (if any) and force-update tag on remote
try {
  git push
} catch {
  Write-Host "git push failed (non-fatal)"
}

git push origin --force "refs/tags/$Tag"

Remove-Item $tmp -ErrorAction SilentlyContinue
