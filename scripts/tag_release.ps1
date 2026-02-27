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

# ensure annotated tag exists (replace if existing)
if (git rev-parse -q --verify "refs/tags/$Tag" 2>$null) {
  git tag -f -a $Tag -m "Release $Tag"
} else {
  git tag -a $Tag -m "Release $Tag"
}

# push commit (if any) and force-update tag on remote
try {
  git push
} catch {
  Write-Host "git push failed (non-fatal)"
}

git push origin --force "refs/tags/$Tag"
