#!/bin/bash

# Function to detect the operating system
get_os() {
  case "$(uname -s)" in
    Linux*)   echo "Linux";;
    Darwin*)  echo "Mac";;
    CYGWIN*)  echo "Windows";;
    MINGW*)   echo "Windows";;
    *)        echo "Unknown";;
  esac
}

# Function to send Git commands
send_git_commands() {
  git checkout --orphan latest_branch
  git add .
  git commit -m "refreshed commits"
  git branch -D main
  git branch -m main
  git push -f origin main
}

# Get the operating system
os=$(get_os)

# Execute the appropriate commands based on the operating system
case "$os" in
  "Linux")
    send_git_commands
    ;;
  "Windows")
    # Check if Git is installed
    if command -v git >/dev/null 2>&1; then
      # Execute the Git commands
      send_git_commands
    else
      echo "Git is not installed. Please install Git and try again."
    fi
    ;;
  *)
    echo "Unsupported operating system: $os"
    ;;
esac

