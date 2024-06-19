# Dotfiles (Via Chezmoi)

```bash
# Install
chezmoi init https://github.com/jo-m/dotfiles.git
$EDITOR ~/.config/chezmoi/chezmoi.toml
chezmoi apply --dry-run --verbose
chezmoi apply
```

## VSCode extensions

```bash
code --list-extensions | sort > vscode/extensions.txt
```
