# Smoke tests on Windows; no external test framework required.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = Split-Path $PSScriptRoot -Parent
$installer = Join-Path $root 'install.ps1'
$temp = Join-Path ([IO.Path]::GetTempPath()) ('skills-test-' + [guid]::NewGuid().ToString('N'))
$origin = Join-Path $temp 'origin'
$sources = Join-Path $temp 'sources with spaces'
$destination = Join-Path $temp 'discovery with spaces'

function Git {
    & git.exe @args
    if ($LASTEXITCODE -ne 0) { throw "Git failed: $args" }
}
function Assert($Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
}

try {
    New-Item -ItemType Directory -Path $origin -Force | Out-Null
    Git init -b main $origin
    Git -C $origin config user.name 'Skill Test'
    Git -C $origin config user.email 'test@example.invalid'
    foreach ($folder in @('low-debt-coding', 'low-debt-learning', 'no-bb', 'official-first-search')) {
        Copy-Item -LiteralPath (Join-Path $root $folder) -Destination $origin -Recurse
    }
    Copy-Item -LiteralPath (Join-Path $root 'INSTALL.md') -Destination $origin
    Git -C $origin add .
    Git -C $origin commit -m 'Initial fixture'
    # file:// exercises Git's transport instead of a local hardlinked clone.
    $repository = ([uri]($origin + [IO.Path]::DirectorySeparatorChar)).AbsoluteUri
    $options = @{ SkillsDir = $destination; SourceRoot = $sources; Repository = $repository }

    & $installer -Skill low-debt-coding @options
    $codingLink = Join-Path $destination 'low-debt-coding'
    $codingSource = Join-Path $sources 'low-debt-coding'
    Assert ((Get-Item -LiteralPath $codingLink).LinkType -eq 'Junction') 'Expected a directory junction.'
    Assert (Test-Path -LiteralPath (Join-Path $codingLink 'SKILL.md')) 'Installed skill is unreadable.'
    Assert (-not (Test-Path -LiteralPath (Join-Path $codingSource 'low-debt-learning'))) 'Unselected skill was checked out.'
    Assert (@(Get-ChildItem -LiteralPath $destination).Count -eq 1) 'More than one skill was enabled.'
    Assert (Test-Path -LiteralPath (Join-Path $codingSource 'INSTALL.md')) 'Update instructions are missing.'

    # Repeated installation succeeds without replacing or updating the checkout.
    $before = Git -C $codingSource rev-parse HEAD
    & $installer -Skill low-debt-coding @options
    Assert ((Git -C $codingSource rev-parse HEAD) -eq $before) 'Reinstall changed the installed revision.'

    # An existing ordinary directory must not be replaced.
    $conflict = Join-Path $destination 'low-debt-learning'
    New-Item -ItemType Directory -Path $conflict | Out-Null
    Set-Content -LiteralPath (Join-Path $conflict 'keep.txt') -Value 'user content'
    $refused = $false
    try { & $installer -Skill low-debt-learning @options } catch { $refused = $true }
    Assert $refused 'Existing destination was not refused.'
    Assert ((Get-Content -LiteralPath (Join-Path $conflict 'keep.txt')) -eq 'user content') 'Existing content changed.'
    Assert (-not (Test-Path -LiteralPath (Join-Path $sources 'low-debt-learning'))) 'Conflict triggered unnecessary cloning.'

    # Public name differs from the repository folder for anti-overcaution.
    & $installer -Skill anti-overcaution @options
    $antiSource = Join-Path $sources 'anti-overcaution'
    Assert (Test-Path -LiteralPath (Join-Path $destination 'anti-overcaution\SKILL.md')) 'Public-name mapping failed.'
    Assert (-not (Test-Path -LiteralPath (Join-Path $antiSource 'low-debt-coding'))) 'Second checkout is not selective.'
    $antiBefore = Git -C $antiSource rev-parse HEAD

    # Publish a change to both skills, then update only coding.
    Add-Content -LiteralPath (Join-Path $origin 'low-debt-coding\SKILL.md') -Value "`nTest update"
    Add-Content -LiteralPath (Join-Path $origin 'no-bb\SKILL.md') -Value "`nTest update"
    Git -C $origin add .
    Git -C $origin commit -m 'Update fixture'
    Git -C $codingSource pull --ff-only
    Assert ((Git -C $codingSource rev-parse HEAD) -ne $before) 'Selected checkout did not update.'
    Assert ((Get-Content -LiteralPath (Join-Path $codingLink 'SKILL.md') -Raw).Contains('Test update')) 'Junction did not expose updated content.'
    Assert ((Git -C $antiSource rev-parse HEAD) -eq $antiBefore) 'Updating one skill updated another.'
    Assert (-not ((Get-Content -LiteralPath (Join-Path $destination 'anti-overcaution\SKILL.md') -Raw).Contains('Test update'))) 'Other skill content changed.'
    Assert (-not (Git -C $codingSource status --porcelain)) 'Installed checkout is unexpectedly dirty.'
    Write-Host 'PASS: selective installation, junctions, idempotence, conflict protection, name mapping, independent updates.'
} finally {
    # Remove only test junctions before recursively removing test-owned directories.
    if (Test-Path -LiteralPath $destination) {
        Get-ChildItem -LiteralPath $destination -Force | Where-Object { $_.LinkType -eq 'Junction' } | ForEach-Object {
            [IO.Directory]::Delete($_.FullName)
        }
    }
    if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
}
