# Windows 11 / Windows PowerShell 5.1 or PowerShell 7; requires Git.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('low-debt-coding', 'low-debt-learning', 'anti-overcaution', 'official-first-search')]
    [string]$Skill,
    [string]$SkillsDir = (Join-Path $HOME '.agents\skills'),
    [string]$SourceRoot = (Join-Path $HOME '.local\share\michubil-skills'),
    [string]$Repository = 'https://github.com/Michubil/skills.git'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Invoke-Git {
    & git @args
    if ($LASTEXITCODE -ne 0) {
        throw "Git failed (exit $LASTEXITCODE). No reset or cleanup was performed."
    }
}

Get-Command git -ErrorAction Stop | Out-Null
$folder = if ($Skill -eq 'anti-overcaution') { 'no-bb' } else { $Skill }
$checkout = Join-Path $SourceRoot $Skill
$target = Join-Path $checkout $folder
$link = Join-Path $SkillsDir $Skill

# Refuse existing installations before doing network work.
$existing = Get-Item -LiteralPath $link -Force -ErrorAction SilentlyContinue
if ($null -ne $existing) {
    $expected = [IO.Path]::GetFullPath($target).TrimEnd('\')
    $actual = if ($existing.LinkType -eq 'Junction') { [string]@($existing.Target)[0] } else { '' }
    if ($actual.TrimEnd('\') -ieq $expected -and (Test-Path -LiteralPath (Join-Path $target 'SKILL.md'))) {
        Write-Host "Already installed: $Skill"
        Write-Host "Update instructions: $(Join-Path $checkout 'INSTALL.md')"
        return
    }
    throw "Destination already exists: $link. Resolve the existing installation first; it was not overwritten."
}

New-Item -ItemType Directory -Force -Path $SourceRoot, $SkillsDir | Out-Null
if (Test-Path -LiteralPath $checkout) {
    throw "Source directory already exists: $checkout. Inspect it before retrying; it was not overwritten."
}

# Each skill has its own checkout: updating one cannot update other installed skills.
Invoke-Git clone --depth 1 --filter=blob:none --sparse --branch main --single-branch $Repository $checkout
Invoke-Git -C $checkout sparse-checkout set --cone -- $folder
if (-not (Test-Path -LiteralPath (Join-Path $target 'SKILL.md'))) {
    throw "The selected skill is missing from the repository: $folder/SKILL.md"
}

New-Item -ItemType Junction -Path $link -Target ([IO.Path]::GetFullPath($target)) | Out-Null
Write-Host "Installed only: $Skill"
Write-Host "Skill: $link"
Write-Host "Source: $checkout"
Write-Host "Update instructions: $(Join-Path $checkout 'INSTALL.md')"
Write-Host 'Restart Codex if the skill is not visible; in Pi use /reload.'
