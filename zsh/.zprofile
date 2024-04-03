# Load order: .zshenv → .zprofile → .zshrc → .zlogin → .zlogout
# ~/.zshenv - env for headless process, login shell, interactive shell (Sublime Text, launchd processes, etc)
# ~/.zprofile - interactive shell - specific for when there is a prompt
# ~/.zshrc - login shell - child `zsh` process won't load this

# NVM (duplicated between .zshenv and .zprofile, with different commented lines)
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
