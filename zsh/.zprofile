# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/irae/.docker/bin"
# End of Docker Desktop section.

# Load order: .zshenv -> .zprofile -> .zshrc -> .zlogin -> .zlogout
# ~/.zshenv  - every zsh invocation, including scripts and editor-launched shells
# ~/.zprofile - login shells; session-level setup
# ~/.zshrc   - interactive shells; prompt, completion, aliases, and shell UX

# macOS's /etc/zprofile runs path_helper before this file, which re-prepends
# /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin ahead of the PATH .zshenv built.
# Re-assert Homebrew's PATH here so it wins over system binaries (e.g. python3, pip3).
if [ -s "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -s "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
