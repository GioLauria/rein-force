Param()
try {
    $repoRoot = (git rev-parse --show-toplevel).Trim()
    Set-Location $repoRoot
    if (-not (Test-Path CHANGELOG.md)) { exit 0 }
    $hash = git rev-parse --short HEAD
    if (Select-String -Path CHANGELOG.md -Pattern $hash -Quiet) { exit 0 }
    $title = git log -1 --pretty=format:%s
    $body = git log -1 --pretty=format:%B
    $entry = "{0} ({1}`n`n" -f $title, $hash
    if ($body) {
        $bodyLines = $body -split "`n"
        foreach ($line in $bodyLines) { $entry += "> $line`n" }
        $entry += "`n"
    }
    $content = Get-Content CHANGELOG.md -Raw
    $pattern = '## \[Unreleased\]'
    if ($content -match $pattern) {
        $parts = $content -split $pattern, 2
        $new = $parts[0] + $pattern + "`n`n" + $entry + $parts[1]
        Set-Content -Path CHANGELOG.md -Value $new -Encoding UTF8
        git add CHANGELOG.md
        try { git commit -m "chore(changelog): add $hash to Unreleased" -q } catch { }
    }
} catch {
    # best-effort, never fail a commit because of changelog update
}
