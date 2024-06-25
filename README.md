# Dotfiles (Via Chezmoi)

```bash
# Install
chezmoi init https://github.com/jo-m/dotfiles.git
$EDITOR ~/.config/chezmoi/chezmoi.toml
chezmoi apply --dry-run --verbose
chezmoi apply

# Custom per-machine fish variable exports
# e.g. `set -x MY_ENV_VAR my_value`
$EDITOR ~/.config/fish/conf.d/exports.fish
```

## VSCode extensions

```bash
code --list-extensions | sort > vscode/extensions.txt
```

## Gnome settings

```bash
# dump
./dconf/dump.py

# load
dconf load / < dconf/dconf.ini
```

## Key bindings

- `F1` Nautilus/Files
- `F6` Dark/Light mode
- `F7` VS Code / Codium
- `F8` Quake Terminal
- `F9` Chrome
- `F10` Firefox
