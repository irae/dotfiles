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
## Adding a new config/script

From the dotfiles directory:

```bash
# Subdirectory structure is mirrored (e.g., .bin/ in home → bin/.bin/ in dotfiles)
mv ../[subdir]/[name] [package]/[subdir]/
git add [package]/[subdir]/[name]
git commit -m "Add [name]"
stow [package]
```
For example:

```bash
mv ../.bin/branch-overview bin/.bin/
git add bin/.bin/branch-overview
git commit -m "Add branch-overview"
stow bin
```

That's it. Four steps, relative to the dotfiles folder, no fluff.
