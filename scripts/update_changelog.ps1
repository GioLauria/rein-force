param()
Set-StrictMode -Version Latest

$repoRoot = git rev-parse --show-toplevel
Set-Location $repoRoot
$out = 'CHANGELOG.md'

$header = @'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to Semantic
Versioning.

'@

[System.IO.File]::WriteAllText($out, $header + "`n")

$tags = git tag --list 'v*' --sort=version:refname | ForEach-Object { $_ }

if ($tags.Count -gt 0) {
  # list tags newest-first so the first tag visible is the latest
  for ($i = $tags.Count - 1; $i -ge 0; $i--) {
    $t = $tags[$i]
    Add-Content $out "## [$t]`n`n"
    if ($i -gt 0) {
      $prev = $tags[$i-1]
      $commits = git log --pretty=format:%s "$prev..$t" 2>$null
    } else {
      $commits = git log --pretty=format:%s --reverse "$t" 2>$null
    }
    if (-not $commits) { Add-Content $out "- No changes recorded.`n`n" }
    else { $commits | ForEach-Object { if ($_ -ne '') { Add-Content $out "- $_`n" } } ; Add-Content $out "`n" }
  }
  $latestTag = $tags[-1]
} else {
  $latestTag = $null
}

# Now append Unreleased section (commits since latest tag)
Add-Content $out "## [Unreleased]`n"
if ($latestTag) {
  $commits = git log --pretty=format:%s "$latestTag..HEAD" 2>$null
} else {
  $commits = git log --pretty=format:%s --reverse HEAD 2>$null
}

if (-not $commits) {
  Add-Content $out "- Placeholder for upcoming changes.`n`n"
} else {
  $commits | ForEach-Object { if ($_ -ne '') { Add-Content $out "- $_`n" } }
  Add-Content $out "`n"
}

Write-Output "Updated $out"
