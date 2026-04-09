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
  - `plan-orchestrator` - 計画立案・タスク分解・セキュリティレビュー。新しい課題の最初の窓口
  - `orchestrator` - 承認済み計画の遂行管理。MCP git tools でコミット・プッシュ
  - `quick-orchestrator` - 単一タスクを素早く解決する。MCP git tools でコミット
  - `implementer` - コーディング・設定・テスト作成（git操作はしない）
  - `investigator` - 問題調査・根本原因特定
  - `system-designer` - アーキテクチャ設計・技術選定
  - `istp-reviewer` - ISTP型（実践的）レビュアー。実用性・実装品質の観点でレビュー
  - `intj-reviewer` - INTJ型（戦略的）レビュアー。設計整合性・長期保守性の観点でレビュー
  - `entp-reviewer` - ENTP型（創造的）レビュアー。代替案・トレードオフ・リスクの観点でレビュー
- `skills/` - Skill definitions:
  - `notify` - 通知パターン
  - `review` - レビュー委譲パターン
  - `investigation` - 調査委譲パターン
  - `agent-delegation` - 【廃止済み】サブエージェント選択ガイド（各エージェントの description に移行済み）
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
