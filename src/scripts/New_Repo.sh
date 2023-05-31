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
  local repo_name=$1
  local github_user=$2
  local visibility=$3

  # Create a new repository using GitHub CLI
  gh repo create "$repo_name" --$visibility

  # Initialize a new Git repository
  git init

  # Add all files to the repository
  git add .

  # Commit the changes
  git commit -m "first commit"

  # Rename the branch to main
  git branch -M main

  # Add the remote origin
  git remote add origin "https://github.com/$github_user/$repo_name.git"

  # Push the changes to the remote repository
  git push -u origin main
}

# Prompt for the repository name
read -p "Enter the repository name: " repo_name
echo

# Prompt for the GitHub username
read -p "Enter your GitHub username: " github_user
echo

# Prompt for the repository visibility (private or public)
read -p "Enter the repository visibility (private/public) [private]: " visibility
visibility=${visibility:-private}
echo

# Convert visibility to lowercase
visibility=$(echo "$visibility" | tr '[:upper:]' '[:lower:]')

# Validate the repository visibility
if [[ "$visibility" != "private" && "$visibility" != "public" ]]; then
  echo "Invalid repository visibility: $visibility"
  exit 1
fi

# Get the operating system
os=$(get_os)

# Execute the appropriate commands based on the operating system
case "$os" in
  "Linux"|"Windows")
    # Check if GitHub CLI is installed
    if command -v gh >/dev/null 2>&1; then
      # Execute the Git commands
      send_git_commands "$repo_name" "$github_user" "$visibility"
    else
      echo "GitHub CLI is not installed. Please install GitHub CLI (gh) and try again."
    fi
    ;;
  *)
    echo "Unsupported operating system: $os"
    ;;
esac

