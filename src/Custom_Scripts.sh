#!/bin/bash

# Directory containing the script
script_directory="$(dirname "$(command -v "$0")")"

# Directory containing the scripts
scripts_directory="$script_directory/scripts"

# Array to store the script filenames
script_files=()

# Check if the scripts directory exists
if [ -d "$scripts_directory" ]; then
  # Iterate over the .sh files in the directory
  for script_file in "$scripts_directory"/*.sh; do
    # Check if the file is a regular file
    if [ -f "$script_file" ]; then
      # Check if the file is executable
      if [ -x "$script_file" ]; then
        # Add the script filename to the array
        script_files+=("$script_file")
      else
        echo "Skipping non-executable script: $script_file"
      fi
    fi
  done

  # Check if any executable scripts were found
  if [ ${#script_files[@]} -gt 0 ]; then
    echo "Available scripts:"
    # Iterate over the script filenames
    for i in "${!script_files[@]}"; do
      script_file="${script_files[$i]}"
      # Display the script number and filename
      echo "$((i+1)). ${script_file##*/}"
    done
    echo

    # Prompt for the script number to execute
    read -p "Enter the number of the script to execute (or 'q' to quit): " choice
    echo

    # Check if the choice is a valid number
    if [[ $choice =~ ^[0-9]+$ ]]; then
      # Subtract 1 from the choice to get the array index
      index=$((choice-1))
      # Check if the index is within the range of script_files array
      if [[ $index -ge 0 && $index -lt ${#script_files[@]} ]]; then
        script_to_execute="${script_files[$index]}"
        # Execute the selected script
        "$script_to_execute"
      else
        echo "Invalid choice: $choice"
      fi
    elif [[ "$choice" == "q" ]]; then
      echo "Exiting the script."
      exit 0
    else
      echo "Invalid choice: $choice"
    fi
  else
    echo "No executable scripts found in the $scripts_directory directory."
  fi
else
  echo "Scripts directory not found: $scripts_directory"
fi

