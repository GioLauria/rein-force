param()
Set-StrictMode -Version Latest

$repoRoot = (git rev-parse --show-toplevel).Trim()
Set-Location $repoRoot
$out = 'CHANGELOG.md'

$header = @'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to Semantic
Versioning.

'@

[System.IO.File]::WriteAllText($out, $header + "`n")

$tags = @(git tag --list 'v*' --sort=version:refname 2>$null)

function Write-CommitBlock($block) {
    $b = $block -replace '^[\r\n]+', '' -replace '[\r\n]+$',''
    if (-not $b) { return }
    $lines = $b -split "[\r\n]+"
    $subject = $lines | Where-Object { $_ -and $_.Trim() -ne '' } | Select-Object -First 1
    if (-not $subject) { return }
    Add-Content $out ("- {0}" -f $subject)
    $bodyLines = $lines[1..($lines.Length-1)] 2>$null
    if ($bodyLines) {
        Add-Content $out ""
        foreach ($ln in $bodyLines) {
            Add-Content $out ("> {0}" -f $ln)
        }
        Add-Content $out ""
    }
}

if ($tags.Count -gt 0) {
    for ($i = $tags.Count - 1; $i -ge 0; $i--) {
        $t = $tags[$i]
        Add-Content $out "## [$t]`n`n"
        if ($i -gt 0) { $prev = $tags[$i-1]; $range = "$prev..$t" } else { $range = "$t" }
        # use full commit body and sentinel to split entries
        $raw = git log --pretty=format:%B"<<COMMIT>>" $range 2>$null || $null
        if (-not $raw) { Add-Content $out "- No changes recorded.`n`n" } else {
            $blocks = $raw -split '<<COMMIT>>'
            foreach ($blk in $blocks) { Write-CommitBlock $blk }
            Add-Content $out ""
        }
    }
    $latestTag = $tags[-1]
} else {
    $latestTag = $null
}

# Unreleased
Add-Content $out "## [Unreleased]`n"
if ($latestTag) { $range = "$latestTag..HEAD" } else { $range = "HEAD" }
$raw = git log --pretty=format:"%B%x1e" $range 2>$null || $null
if (-not $raw) {
    Add-Content $out "- Placeholder for upcoming changes.`n`n"
} else {
    # split on ASCII RS (0x1E)
    $sep = [char]30
    $blocks = $raw -split [regex]::Escape($sep)
    foreach ($blk in $blocks) { Write-CommitBlock $blk }
    Add-Content $out ""
}

Write-Output "Updated $out"
