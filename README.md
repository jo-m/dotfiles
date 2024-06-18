# Chezmoi config

```bash
# Install
chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git

# Set config values
mkdir -p ~/.config/chezmoi/
cp ~/.local/share/chezmoi/chezmoi.toml.sample ~/.config/chezmoi/chezmoi.toml
$EDITOR ~/.config/chezmoi/chezmoi.toml
```
