# Michubil's Skills

面向 coding agent 的可复用技能：减少无效工作、技术债和认知负担。
采用标准 `SKILL.md` 格式，不绑定 Pi；支持 Codex、Pi，以及支持此格式的其他工具。

## 按需选择

| Skill 名称 | 目录 | 用途 |
| --- | --- | --- |
| `low-debt-coding` | [low-debt-coding](low-debt-coding/SKILL.md) | 现代技术基线、合理复用、减少过度防御和长期技术债 |
| `low-debt-learning` | [low-debt-learning](low-debt-learning/SKILL.md) | 用较低认知负担学习当前适用的知识 |
| `anti-overcaution` | [no-bb](no-bb/SKILL.md) | 聚焦实际问题，减少无意义顾虑，直接推进任务 |
| `official-first-search` | [official-first-search](official-first-search/SKILL.md) | 技术查证优先采用适用版本的官方资料 |

这些 skill 可以独立使用，不要求成套安装。它们是模型指令，不是强制执行的检查器。

## 让 agent 安装一个 skill

复制下面这段话给朋友的 agent，把 skill 名换成需要的名字即可：

> 请阅读 https://github.com/Michubil/skills/blob/main/INSTALL.md ，按实际操作系统，只安装 low-debt-coding。使用文档中的独立稀疏 Git 工作区和目录链接方式，不安装其他 skill。检查当前 agent 的技能发现目录，不覆盖已有同名文件；执行完成后报告实际路径和结果。

如果 GitHub 页面不能正常读取，使用原文地址：
<https://raw.githubusercontent.com/Michubil/skills/main/INSTALL.md>。

### Windows 11 手动安装

安装 Git for Windows 后，在 PowerShell 执行：

```powershell
$installer = Join-Path $env:TEMP 'michubil-skills-install.ps1'
Invoke-WebRequest -UseBasicParsing `
  -Uri 'https://raw.githubusercontent.com/Michubil/skills/main/install.ps1' `
  -OutFile $installer
Get-Content -LiteralPath $installer
# 阅读脚本后执行；只安装这一个 skill：
powershell.exe -NoProfile -ExecutionPolicy Bypass -File $installer -Skill low-debt-coding
```

默认启用位置：`~/.agents/skills/low-debt-coding`，Codex 和 Pi 均支持。
Windows 使用目录联接（Junction），通常不需要管理员权限或开发者模式。
原生 Windows 和 WSL 分别按各自环境安装。

Linux/macOS、其他 agent 的自定义目录及卸载方法见 [INSTALL.md](INSTALL.md)。

## 让 agent 更新这一个 skill

以后给 agent 发：

> 请按 https://github.com/Michubil/skills/blob/main/INSTALL.md 更新已安装的 low-debt-coding。只更新这个 skill 的工作区，先确认来源和本地改动，用 Git fast-forward 更新；不要覆盖、stash 或 reset 我的修改。报告实际更新结果。

默认源目录是 `~/.local/share/michubil-skills/low-debt-coding`。
更新操作本质是检查工作区后运行 `git pull --ff-only`，没有后台更新器。
每个 skill 使用独立工作区，更新一个不会顺带更新另一个。
不要直接修改安装后的正文；需要长期定制时使用 fork。

### 为什么不是下载一个 Markdown 文件？

复制下载可以使用，但没有建立持续更新关系。本仓库的安装方式保留 Git 来源和版本，
让 agent 能判断安装位置、检查修改并更新。稀疏工作区只展开选中的 skill 和根目录说明，
不会启用其他 skill；Git 仍会获取必要的仓库元数据。

## 调用

- Codex：通过 `/skills` 选择，或在提示中使用 `$low-debt-coding`。
- Pi：`/skill:low-debt-coding`；安装或更新后可执行 `/reload`。
- 其他工具：按其 skill 发现、调用和重载机制使用，不保证通用安装路径适用。

Codex 未显示新 skill 时重启。不要同时保留多个同名安装副本。

## 维护与发布

此仓库是发布源。修改对应目录下的 `SKILL.md`，检查后提交并推送到 `main`，
用户按需拉取更新。不要将个人凭据、绝对机器路径或其他工具的私人配置加入仓库。
仓库根目录的 [AGENTS.md](AGENTS.md) 约束仓库维护工作；不会为了更新功能向每个
skill 正文添加额外指令，也不会让模型每次执行普通任务都检查更新。

Windows 安装和独立更新由 GitHub Actions 的 Windows 测试验证。

## 许可证

[MIT](LICENSE)
