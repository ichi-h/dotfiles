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
- `agents/` - Custom agent definitions (orchestrator, task-manager, investigator, security-reviewer)
- `skills/` - Skill definitions (backlog-management)
- `mcp-config.json` - MCP server configuration

## Conventions

- Language: Responses in Kansai dialect (関西弁), artifacts in standard Japanese
- Use serena for all tasks
- Use `nix develop -c ...` for running commands in Nix projects
