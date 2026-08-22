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

## Omarchy dotfiles

Omarchy quattro loads Hyprland config from Lua. It has no user hook for window
rules, so the chain is:

```
hyprland.lua → require("hypr.apps") → apps.lua → apps/*.lua
```

`hyprland.lua` is a user file, so the extra `require` line is supported.
`apps.lua` is mine — Omarchy ships no user equivalent. It uses explicit
`require` calls, because Omarchy's `require_all` helper finds files with
`find -type f`, which does not match the symlinks stow creates.

Run `omarchy_lint` to check the chain. It only reads files. It also runs after
every `omarchy update`, through the hook in
`omarchy/.config/omarchy/hooks/post-update.d/`.

A major Omarchy release can change all of this. Expect to redo it then.

## Linux keyboard

[linux-keyb.md](linux-keyb.md) — typing Portuguese and code on one US-layout keyboard. How macOS, Windows and Linux each solve it, and a comparison of the Linux options.

## rethinkdb-python macOS bugs

After `pipx install/upgrade/reinstall rethinkdb`, run `patch-rethinkdb-python` to fix unreported upstream bugs (`--help` crash, dump/restore/export/import crashing with "cannot pickle '_thread._local' object" on macOS; see the script's comments).
