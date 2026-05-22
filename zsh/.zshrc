# Load order: .zshenv -> .zprofile -> .zshrc -> .zlogin -> .zlogout
# ~/.zshenv  - every zsh invocation, including scripts and editor-launched shells
# ~/.zprofile - login shells; session-level setup
# ~/.zshrc   - interactive shells; prompt, completion, aliases, and shell UX

# All of PATH should live in .zshenv

# History settings
HISTFILE=~/.zsh_history       # File to store history
HISTSIZE=10000                # Number of commands to keep in memory
SAVEHIST=50000                # Number of commands to save in HISTFILE
setopt APPEND_HISTORY         # Append history instead of overwriting
setopt SHARE_HISTORY          # Share history across sessions
setopt INC_APPEND_HISTORY     # Add commands to history immediately
setopt HIST_IGNORE_DUPS       # Ignore duplicate commands
setopt HIST_IGNORE_SPACE      # Ignore commands starting with a space
setopt HIST_REDUCE_BLANKS     # Remove extra blanks from commands

# Shell enhancements
eval "$(starship init zsh)"

# Completions
autoload -Uz compinit && compinit

# git-extras completion
if [ -s "/opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh" ]; then
    source /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh
fi

# Bash completions
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
[ -s "/Users/irae/.bun/_bun" ] && source "/Users/irae/.bun/_bun"

# Aliases
if [ -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ]; then
    alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
fi

if command -v subl.exe >/dev/null 2>&1; then
    alias subl=subl.exe
fi

if [ -x "/Applications/Kaleidoscope.app/Contents/MacOS/ksdiff" ]; then
    alias ksdiff="/Applications/Kaleidoscope.app/Contents/MacOS/ksdiff"
fi

if [[ "$OSTYPE" == darwin* ]]; then
    alias ls="ls -Gh"
fi

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

precmd_functions+=(nvm_use)

# usage: iso_to_epoch "2025-04-15T16:51:56.130000+00:00"
iso_to_epoch() {
  local input_date="$1"
  if [[ -z "$input_date" ]]; then
    echo "Error: Please provide a date string (e.g., 2025-04-15T16:51:56.130000+00:00)"
    return 1
  fi

  # Reformat timezone from +00:00 to +0000 for macOS date compatibility
  local normalized_date="${input_date//+00:00/+0000}"

  # Extract seconds and milliseconds
  local seconds
  seconds=$(date -j -f "%Y-%m-%dT%H:%M:%S.%6f%z" "$normalized_date" "+%s" 2>/dev/null)
  local millis="${input_date#*.}" # Get part after decimal
  millis="${millis%%+*}"         # Remove timezone
  millis="${millis:0:3}"         # Take first 3 digits for milliseconds

  if [[ -z "$seconds" ]]; then
    echo "Error: Invalid date format"
    return 1
  fi

  # Combine seconds and milliseconds
  echo "${seconds}${millis}"
}

function deps {
    jq '. | with_entries( select(.key|contains("ependencies")) )' package.json
}

if [ "$(arch)" = "i386" ]; then
    function stop {
        PIDS=( `fuser /usr/libexec/rosetta/runtime 2> /dev/null` )
        WAIT=0
        for PID in "${PIDS[@]}"; do
            COMMAND=( `ps -o command= -p $PID` )
            if [[ $COMMAND =~ (bin/nf start|firehose) ]]; then
                WAIT=5
                echo "SIGINT $COMMAND"
                kill -SIGINT $PID
            fi
        done
        sleep $WAIT
        PIDS=( `fuser /usr/libexec/rosetta/runtime 2> /dev/null` )
        WAIT=0
        for PID in "${PIDS[@]}"; do
            COMMAND=( `ps -o command= -p $PID` )
            if [[ $COMMAND =~ consider.*(node|nginx.*master) ]]; then
                WAIT=5
                echo "SIGINT $COMMAND"
                kill -SIGINT $PID
            fi
        done
        sleep $WAIT
        PIDS=( `fuser /usr/libexec/rosetta/runtime 2> /dev/null` )
        WAIT=0
        for PID in "${PIDS[@]}"; do
            COMMAND=( `ps -o command= -p $PID` )
            if [[ $COMMAND =~ (rethinkdb|mendel|Mendel) ]]; then
                WAIT=5
                echo "SIGINT $COMMAND"
                kill -SIGINT $PID
            fi
        done
        sleep $WAIT
        PIDS=( `fuser /usr/libexec/rosetta/runtime 2> /dev/null` )
        for PID in "${PIDS[@]}"; do
            COMMAND=( `ps -o command= -p $PID` )
            if [[ $COMMAND =~ (rethinkdb|node|nginx|mendel|Mendel) ]]; then
                echo "SIGKILL $COMMAND"
                kill -SIGKILL $PID
            fi
        done

    }
else
    function stop {
        WAIT=0
        ps x -o 'pid= command=' 2> /dev/null | grep -E '(bin/nf start|firehose)' | grep -vE '(grep|typescript|/Zed/)' | {
            while IFS= read -r line
            do
                WAIT=5
                PID=(`echo $line | awk 'NR==1{print $1}'`)
                echo "SIGINT $line"
                kill -SIGINT $PID
            done
        }
        sleep $WAIT
        WAIT=0
        ps x -o 'pid= command=' 2> /dev/null | grep -E '(bin/node |nginx.*master)' | grep -vE '(grep|typescript|/Zed/)' | {
            while IFS= read -r line
            do
                WAIT=5
                PID=(`echo $line | awk 'NR==1{print $1}'`)
                echo "SIGINT $line"
                kill -SIGINT $PID
            done
        }
        sleep $WAIT
        WAIT=0
        ps x -o 'pid= command=' 2> /dev/null | grep -E '(rethinkdb|mendel|Mendel Daemon)' | grep -vE '(grep|typescript|/Zed/)' | {
            while IFS= read -r line
            do
                WAIT=25
                PID=(`echo $line | awk 'NR==1{print $1}'`)
                echo "SIGINT $line"
                kill -SIGINT $PID
            done
        }
        sleep $WAIT
        WAIT=0
        ps x -o 'pid= command=' 2> /dev/null | grep -E '(rethinkdb|node|nginx|mendel|Mendel)' | grep -vE '(grep|typescript|/Zed/)' | {
            while IFS= read -r line
            do
                WAIT=5
                PID=(`echo $line | awk 'NR==1{print $1}'`)
                echo "SIGKILL $line"
                kill -SIGKILL $PID
            done
        }
        sleep $WAIT
    }
fi
