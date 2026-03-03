# dotfiles Project Overview

## Purpose

NixOS/Home Manager based dotfiles repository managing multiple hosts (Raspberry Pi, Mini PCs, Dev Server, WSL).

## Tech Stack

- **Nix**: Primary configuration language (NixOS + Home Manager)
- **Flake**: Uses flake.nix for reproducible builds

## Structure

- `nix/` - Main Nix configurations
  - `nix/home/` - Home Manager configurations
    - `nix/home/base/cli/` - CLI tool configurations (copilot-cli, git, zsh, tmux, neovim, etc.)
  - `nix/hosts/` - Host-specific configurations
  - `nix/modules/` - Reusable Nix modules
  - `nix/vars/` - Variables
- `bin/` - Scripts
- `k8s/` - Kubernetes configurations
- `.ichi-h/` - Task tracking files

## Copilot CLI Configuration

Located at `nix/home/base/cli/copilot-cli/`:

- `default.nix` - Installs copilot binary and symlinks config files to `~/.copilot/`
- `copilot-instructions.md` - Main instructions (language settings, serena usage)
- `agents/` - Custom agent definitions:
  - `orchestrator` - バックログ解決の進行管理。MCP git tools でコミット・プッシュ
  - `quick-orchestrator` - バックログ不要の小さい課題を素早く解決。MCP git tools でコミット
  - `task-manager` - タスク管理（完了更新・次タスク特定）
  - `backlog-manager` - バックログの作成・更新・管理
  - `implementer` - コーディング・設定・テスト作成（git操作はしない）
  - `investigator` - 問題調査・根本原因特定
  - `security-reviewer` - セキュリティ脆弱性検出・レビュー
  - `system-designer` - アーキテクチャ設計・技術選定
  - `tester` - 静的解析・テスト・ビルド実行
- `skills/` - Skill definitions:
  - `backlog-management` - バックログ管理方法
  - `investigation` - 調査委譲パターン
  - `agent-delegation` - サブエージェント選択ガイド
- `mcp-config.json` - MCP server configuration
  - `serena` MCP server
  - `git` MCP server (`mcp-server-git`) - git操作専用

## Project-Level Skills

Located at `.github/copilot/skills/`:

- `testing/SKILL.md` - dotfiles にはテスト・lint・ビルド対象が存在しないため tester はスキップ報告のみ

## Git Operations Policy

- orchestrator / quick-orchestrator は bash ではなく MCP git tools を使用して git 操作を行う
  - orchestrator tools: `git/git_status`, `git/git_diff_staged`, `git/git_add`, `git/git_commit`, `git/git_push`
  - quick-orchestrator tools: `git/git_status`, `git/git_diff_staged`, `git/git_add`, `git/git_commit`
- implementer は git 操作を行わない（orchestrator の責務）

## Conventions

- Language: Responses in Kansai dialect (関西弁), artifacts in standard Japanese
- Use serena for all tasks
- Use `nix develop -c ...` for running commands in Nix projects
