# dotfiles

# packages I would miss

```bash
# mac
brew install stow git-delta git-extras jq ripgrep
# arch
sudo pacman -Sy stow git-delta git-extras jq ripgrep
# debian / ubuntu / etc
sudo apt install -y stow git-delta git-extras jq ripgrep
```

```
git clone [repo] ~/.dotfiles
cd ~/.dotfiles
stow git
stow zsh
stow bin
```
