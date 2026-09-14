# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

export PATH="$HOME/.bin:$PATH"

export NVM_DIR="$HOME/.config/nvm"
# Omarchy turns command hashing off for mise, but nvm runs `hash -r` as it
# loads and complains when hashing is off. Turn it on for the load only.
set -h
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
set +h
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# zeditor's normal launch path forks/detaches before creating its window;
# on this machine that detach loses the window entirely (process runs,
# loads the project, never maps a Wayland surface). --foreground skips the
# detach and the window shows up. Bug found 2026-08-31 on zed 1.16.2 /
# omazed 2.1.0, ~3 days after both were upgraded from 1.14.2 / 2.0.1.
# If you're reading this because zed opens fine without --foreground now,
# the bug is probably fixed upstream — drop the alias.
alias zed="zeditor --foreground"

# Merge bash history across panes/windows instead of last-to-close wins
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
