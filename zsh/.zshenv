# Load order: .zshenv -> .zprofile -> .zshrc -> .zlogin -> .zlogout
# ~/.zshenv   - every zsh invocation, including scripts and editor-launched shells
# ~/.zprofile - login shells; session-level setup
# ~/.zshrc    - interactive shells; prompt, completion, aliases, and shell UX

# Multiple Homebrews on Apple Silicon or Intel
if [ -s "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="/opt/homebrew/bin:$PATH"
elif [ -s "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# NVM (paths and vars here, completion on .zshrc)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# bun (paths and vars here, completion on .zshrc)
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Docker Desktop CLI (command path belongs in .zshenv)
export DOCKER_DESKTOP_BIN="/Applications/Docker.app/Contents/Resources/bin"
if [ -d "$DOCKER_DESKTOP_BIN" ]; then
    case ":$PATH:" in
      *":$DOCKER_DESKTOP_BIN:"*) ;;
      *) export PATH="$DOCKER_DESKTOP_BIN:$PATH" ;;
    esac
fi

# Created by `pipx` on 2026-05-21 21:54:43
export PATH="$PATH:/Users/irae/.local/bin"

export PNPM_HOME="/Users/irae/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac