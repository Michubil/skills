# Install and update individual skills

These instructions are for users and coding agents. Repository:
<https://github.com/Michubil/skills>. Branch: `main`.

## Installation model

Each selected skill has its own sparse Git checkout outside the agent's discovery directories.
Only that skill's directory is linked into the discovery directory. Root documentation and the
installer are also checked out; unrelated skill directories are not. Git still fetches repository
metadata, so this is not a promise to download zero bytes associated with other paths.

| Public skill name | Repository directory |
| --- | --- |
| `low-debt-coding` | `low-debt-coding` |
| `low-debt-learning` | `low-debt-learning` |
| `anti-overcaution` | `no-bb` |
| `official-first-search` | `official-first-search` |

`no-bb` is the existing source directory; its SKILL.md declares `anti-overcaution`.
Keep this mapping rather than renaming the author's existing managed directory.

## Windows 11: install one skill

Requires Git for Windows and Windows PowerShell 5.1 or PowerShell 7.
The default destination is `$HOME\.agents\skills`, supported by Codex and Pi.
For another agent, first identify its documented discovery directory and pass `-SkillsDir`.
Do not assume every agent supports the same path.

Download the installer to a temporary directory, inspect it, then execute it:

```powershell
$installer = Join-Path $env:TEMP 'michubil-skills-install.ps1'
Invoke-WebRequest -UseBasicParsing `
  -Uri 'https://raw.githubusercontent.com/Michubil/skills/main/install.ps1' `
  -OutFile $installer
Get-Content -LiteralPath $installer
powershell.exe -NoProfile -ExecutionPolicy Bypass -File $installer -Skill low-debt-coding
```

`Bypass` applies only to this process, not the machine's permanent execution policy.
The script creates an NTFS directory junction; administrator rights and Developer Mode
are normally unnecessary. It refuses to replace an existing installation.
Do not use it to install into a WSL agent: use the Linux instructions inside WSL instead.

Install another skill by changing `-Skill`; each invocation enables only the named skill.
Custom destination example:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File $installer `
  -Skill low-debt-coding -SkillsDir 'C:\path\to\your-agent\skills'
```

Default source checkout:
`$HOME\.local\share\michubil-skills\low-debt-coding`.

## Linux / macOS: install one skill

Requires Git with sparse-checkout support. Select a public name from the table above:

```bash
skill=low-debt-coding
folder="$skill"
[ "$skill" != anti-overcaution ] || folder=no-bb
source="$HOME/.local/share/michubil-skills/$skill"
destination="$HOME/.agents/skills/$skill"

# Refuse an existing checkout or destination, including a dangling symlink.
if [ -e "$source" ] || [ -L "$source" ] || [ -e "$destination" ] || [ -L "$destination" ]; then
  printf '%s\n' 'An installation path already exists; inspect it before proceeding.'
else
  mkdir -p "$(dirname "$source")" "$(dirname "$destination")" &&
  git clone --depth 1 --filter=blob:none --sparse --branch main --single-branch \
    https://github.com/Michubil/skills.git "$source" &&
  git -C "$source" sparse-checkout set --cone -- "$folder" &&
  test -f "$source/$folder/SKILL.md" &&
  ln -s "$source/$folder" "$destination"
fi
```

## Update one installed skill (also the agent procedure)

Do this only when the user requests an update. Do not check for updates during ordinary
coding or learning tasks. Do not add update instructions to every skill's prompt.

1. Locate the selected skill's source checkout. The default is
   `~/.local/share/michubil-skills/<public-skill-name>` on both platforms. For a custom
   installation, resolve the installed directory link instead of assuming the default.
2. Inspect origin, branch, and local changes:

   ```powershell
   $source = Join-Path $HOME '.local\share\michubil-skills\low-debt-coding'
   git -C $source remote get-url origin
   git -C $source branch --show-current
   git -C $source status --porcelain
   git -C $source rev-parse HEAD
   ```

   For an unmodified installation, origin is `https://github.com/Michubil/skills.git`,
   branch is `main`, and status output is empty. If the checkout is dirty, points to an
   unexpected remote, or uses another branch, stop and explain the concrete discrepancy.
   Do not reset, stash, overwrite, or change the user's remote to force an update.
3. Fetch and fast-forward the selected checkout:

   ```powershell
   git -C $source pull --ff-only
   ```

   Check the command's exit status. A network or merge failure is not a successful update.
4. Confirm the selected `SKILL.md` still exists and report the old and new commit IDs
   (`git -C $source rev-parse HEAD`). If unchanged, say it was already current.
   If the upstream removed or renamed the skill, report that rather than claiming success.
5. Codex detects changes automatically; restart if needed. In Pi, run `/reload`.
   Other agents may require their own reload procedure.

On Linux/macOS, the same Git commands work; define the path with:

```bash
source="$HOME/.local/share/michubil-skills/low-debt-coding"
git -C "$source" remote get-url origin
git -C "$source" branch --show-current
git -C "$source" status --porcelain
git -C "$source" rev-parse HEAD
# After confirming origin, branch, and a clean worktree:
git -C "$source" pull --ff-only
git -C "$source" rev-parse HEAD
```

Only the selected checkout updates. Other separately installed skills stay at their
current commits. Updates follow `main`; there is no background updater.
Do not directly edit managed skill files if you want frictionless updates; use a fork
for persistent customizations.

## Uninstall

Remove only the discovery link first. On Windows, after confirming the path is the
junction created by this installer, use `cmd /c rmdir "<junction-path>"` without `/s`.
On Linux/macOS, use `unlink "<symlink-path>"`. Do not recursively delete through links.
The source checkout can remain for later inspection or be deleted separately after
checking for local changes. Never delete the parent skills directory.

## Agent limitations

This document is an explicit operation guide, not an automatically loaded global skill.
Give the agent its URL or local path when requesting installation or updates. Respect
network/filesystem approval requirements of the host. If commands cannot run, report
what remains rather than claiming installation or update succeeded.
