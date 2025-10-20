# Load order: .zshenv → .zprofile → .zshrc → .zlogin → .zlogout
# ~/.zshenv - env for headless process, login shell, interactive shell (Sublime Text, launchd processes, etc)
# ~/.zprofile - interactive shell - specific for when there is a prompt
# ~/.zshrc - login shell - child `zsh` process won't load this

# echo ".zshenv PATH start: ${PATH}"

export PATH="/Users/irae/.bin:$PATH"

# Using only arm buid here because Sublime will use this file
[ -s "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -s "/usr/local/bin/brew" ] && eval "$(/usr/local/bin/brew shellenv)"

# Multiple Homebrews on Apple Silicon
# if [ "$(arch)" = "arm64" ]; then
#     eval "$(/opt/homebrew/bin/brew shellenv)"
#     echo ".zshenv PATH brew arm: ${PATH}"
# else
#     eval "$(/usr/local/bin/brew shellenv)"
#     echo ".zshenv PATH brew intel: ${PATH}"
# fi

# NVM (duplicated between .zshenv and .zprofile, with different commented lines)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# echo ".zshenv PATH end: ${PATH}"
