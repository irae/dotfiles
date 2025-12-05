# Load order: .zshenv → .zprofile → .zshrc → .zlogin → .zlogout
# ~/.zshenv - env for headless process, login shell, interactive shell (Sublime Text, launchd processes, etc)
# ~/.zprofile - interactive shell - specific for when there is a prompt
# ~/.zshrc - login shell - child `zsh` process won't load this

# echo ".zshrc PATH start: ${PATH}"

# History settings
HISTFILE=~/.zsh_history       # File to store history
HISTSIZE=10000                # Number of commands to keep in memory
SAVEHIST=10000                # Number of commands to save in HISTFILE
setopt APPEND_HISTORY         # Append history instead of overwriting
setopt SHARE_HISTORY          # Share history across sessions
setopt INC_APPEND_HISTORY     # Add commands to history immediately
setopt HIST_IGNORE_DUPS       # Ignore duplicate commands
setopt HIST_IGNORE_SPACE      # Ignore commands starting with a space
setopt HIST_REDUCE_BLANKS     # Remove extra blanks from commands

# Shell enhancements
eval "$(starship init zsh)"
autoload -Uz compinit && compinit
if [ -s "/opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh" ]; then
    source /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh
fi
if [ -s "/usr/local/Cellar/git-extras/7.2.0/share/git-extras/git-extras-completion.zsh" ]; then
    source /usr/local/Cellar/git-extras/7.2.0/share/git-extras/git-extras-completion.zsh
fi

# echo ".zshrc PATH 1: ${PATH}"

function nvm_use(){
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version
        nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

        if [ "$nvmrc_node_version" = "N/A" ]; then
          nvm install
        elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
          nvm use
        fi
    fi
}

# precmd_functions+=(nvm_use)

if [ -s "/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl" ]; then
    alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
fi

if command -v subl.exe >/dev/null 2>&1; then
    alias subl=subl.exe
fi

alias ksdiff="/Applications/Kaleidoscope.app/Contents/MacOS/ksdiff"
alias ls="ls -Gh"

function deps {
    jq '. | with_entries( select(.key|contains("ependencies")) )' package.json
}

# Docker
if [ -s "/Users/irae/.docker/cli-plugins/docker-init" ]; then
    source /Users/irae/.docker/cli-plugins/docker-init || true 
fi

if command -v brew >/dev/null 2>&1; then
    # Multiple Homebrews on Apple Silicon
    if [ "$(arch)" = "arm64" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # echo ".zshrc PATH brew arm: ${PATH}"
    else
        eval "$(/usr/local/bin/brew shellenv)"
        # echo ".zshrc PATH brew intel: ${PATH}"
    fi
fi

# echo ".zshrc PATH end: ${PATH}"
# pnpm
export PNPM_HOME="/Users/irae/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
bindkey -e


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

