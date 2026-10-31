# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# Load Omarchy's Bash defaults when present; otherwise use the fallback below.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
fi

if [[ -r "$OMARCHY_PATH/default/bash/rc" ]]; then
  source "$OMARCHY_PATH/default/bash/rc"
else
  if command -v eza >/dev/null 2>&1; then
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lsa='ls -a'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='lt -a'
  fi

  if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
    alias cd='zd'
    zd() {
      if (( $# == 0 )); then
        builtin cd ~ || return
      elif [[ -d $1 ]]; then
        builtin cd "$1" || return
      else
        if ! z "$@"; then
          echo 'Error: Directory not found'
          return 1
        fi

        printf '\U000F17A9 '
        pwd
      fi
    }
  fi

  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'

  if [[ ${TERM:-} != dumb ]] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash --print-full-init)"
  fi

  if command -v fzf >/dev/null 2>&1; then
    if [[ -r /usr/share/fzf/key-bindings.bash ]]; then
      source /usr/share/fzf/key-bindings.bash
    elif [[ -r /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
      source /usr/share/doc/fzf/examples/key-bindings.bash
    fi
  fi
fi

export PATH="$HOME/.bin:$HOME/.local/bin:$PATH"

if [[ -r "$HOME/.deno/env" ]]; then
  source "$HOME/.deno/env"
fi
if [[ -r "$HOME/.local/share/bash-completion/completions/deno.bash" ]]; then
  source "$HOME/.local/share/bash-completion/completions/deno.bash"
fi

export PATH="$HOME/.grok/bin:$PATH"
if [[ -r "$HOME/.grok/completions/bash/grok.bash" ]]; then
  source "$HOME/.grok/completions/bash/grok.bash"
fi

if [[ -f "$HOME/.bash_aliases" ]]; then
  source "$HOME/.bash_aliases"
fi

# Merge Bash history across panes/windows instead of last-to-close wins.
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=50000
shopt -s histappend
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND="history -a; history -c; history -r${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Zed detaches by default; --foreground keeps it attached to this shell.
alias zed='zeditor'
