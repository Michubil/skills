# Repository maintenance

This repository is the publication source for independent Agent Skills.

- Keep skill instructions host-neutral. Do not add Pi-only, Codex-only, or local machine paths to skill bodies.
- Preserve the existing top-level skill directories. `no-bb/SKILL.md` declares the public name `anti-overcaution`; the installer maps that name explicitly.
- Users install skills independently. Do not introduce implicit dependencies or install every skill when one is requested.
- Keep installation and update procedures in `INSTALL.md`, not in every skill's prompt. Do not trigger network update checks during ordinary skill use.
- For consumer installation or updates, read `INSTALL.md` and follow the actual host's discovery rules. Protect existing installations and local changes; never reset or stash them to force an update.
- If adding or renaming a skill, update the README table, INSTALL.md mapping, installer selection, and relevant tests together.
- Windows support targets Windows 11 with Git and Windows PowerShell 5.1 or PowerShell 7. Keep the installer dependency-free. Linux/macOS use the documented Git and symlink workflow.
- Run `tests/windows.ps1` on Windows for installer changes. Report honestly when only static or Linux Git checks were possible.
- Do not publish credentials, private configurations, or unrelated local files. Commit and push only when requested by the maintainer.
