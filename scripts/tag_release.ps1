param(
  [Parameter(Mandatory=$true)][string]$Tag
)

Set-StrictMode -Version Latest

Set-Location (git rev-parse --show-toplevel)

.
\scripts\update_changelog.ps1

git add CHANGELOG.md
git commit -m "chore(release): update CHANGELOG for $Tag"
git tag -a $Tag -m "Release $Tag"
git push
git push origin $Tag
