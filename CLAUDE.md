# CLAUDE.md

Chezmoi dotfiles repository for Linux (NixOS and Ubuntu). Manages shell configs, editor settings, GNOME desktop customization, and utility scripts.

## Chezmoi File Naming Conventions

- `dot_*` → creates dotfile (e.g., `dot_bashrc` → `~/.bashrc`)
- `private_*` → private file (restrictive permissions)
- `executable_*` → executable script (+x)
- `*.tmpl` → template file (uses Go text/template)
- `empty_*` → creates empty file
- `symlink_*` → creates symlink
- `run_onchange_*` → runs script when content changes

## Directory Structure

- `bin/` - Utility scripts installed to ~/bin
- `dconf/` - GNOME settings (not applied by chezmoi, use `dconf load / < dconf/dconf.ini`)
- `private_dot_config/` - ~/.config files (fish, git, vscode, etc.)
- `symlinked/` - Symlinked configs (vscode settings shared between Code and Codium)

## Template Variables

Defined in `.chezmoi.toml.tmpl`, prompted during `chezmoi init`:
- `.name` - Full name
- `.email` - Personal email
- `.work_email` - Work email
- `.work_git_dir` - Work git directory path

Access in templates: `{{ .name }}`, `{{ .email }}`

## Key Configuration Files

- `dot_gitconfig.tmpl` - Git config with work/personal separation
- `private_dot_config/private_fish/` - Fish shell (main shell)
- `private_dot_config/git/gitignore_global` - Global gitignore
- `symlinked/vscode/settings.json` - VS Code/Codium settings

## Machine-Specific Overrides

These files are created empty and won't be overwritten:
- `~/.config/git/gitconfig_work_localhost` - Local git config
- `~/.config/fish/conf.d/localhost.fish` - Local fish config
- `~/.config/cspell/dicts/localhost.txt` - Local spell dictionary

## Common Commands

```bash
chezmoi apply           # Apply dotfiles to home directory
chezmoi diff            # Preview changes
chezmoi edit <file>     # Edit a managed file
chezmoi add <file>      # Add file to chezmoi management
chezmoi data            # View template data
```

## Ignored from Chezmoi Apply

See `.chezmoiignore`.

## GNOME Settings

The `dconf/` directory contains GNOME desktop settings.
Those are not managed by chezmoi, but manually via scripts:

```bash
dconf load / < dconf/dconf.ini
python3 dconf/dump.py > dconf/dconf.ini
```
