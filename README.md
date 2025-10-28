# Dotfiles (Chezmoi)

This assumes the system setup as per https://github.com/jo-m/nixos/.
Stock Ubuntu is also possible, see below.

## Install

```bash
# Install
chezmoi init https://github.com/jo-m/dotfiles.git
$EDITOR ~/.config/chezmoi/chezmoi.toml
chezmoi apply --dry-run --verbose
chezmoi apply

# Custom host specific config.
$EDITOR ~/.config/fish/conf.d/localhost.fish # e.g. `set -x MY_ENV_VAR my_value`
$EDITOR ~/.config/git/gitconfig_work_localhost
$EDITOR ~/.config/cspell/dicts/localhost.txt
```

## VSCode extensions

```bash
code --list-extensions | sort > symlinked/vscode/extensions.txt
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

## Ubuntu setup

Currently, Ubuntu 24.04 LTS.

```bash
sudo apt-get install git fish curl wget tmux ripgrep fzf fonts-powerline
sudo snap install chezmoi --classic
chsh -s /usr/bin/fish

# Fisher https://github.com/jorgebucaran/fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | \
    source && fisher install jorgebucaran/fisher
# z https://github.com/jethrokuan/z
fisher install jethrokuan/z

# Now, you can follow the "Install" steps at the top.
```

## Tar chezmoi config on a machine for export

```bash
chezmoi cd
tar cvjf ~/Downloads/chezmoi.tar.gz --strip-components=1 ../chezmoi/
```

## Cheatsheet

```bash
nix-shell -p typst typstyle
typstyle -i cheatsheet.typ
typst compile cheatsheet.typ
open cheatsheet.pdf
```
