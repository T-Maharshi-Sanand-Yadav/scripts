#!/bin/bash

# Show usage if sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo "Usage:"
  echo "  bash replace_text_in_files.sh"
  echo ""
  echo "This script replaces old text with new text in all files within a given folder."
  echo "You will be prompted to enter:"
  echo "  - Text to find"
  echo "  - Text to replace"
  echo "  - Folder path"
  echo ""
  return 0
fi

# Script runs normally if executed directly
read -p "Enter the old text to replace: " old_text
read -p "Enter the new text: " new_text
read -p "Enter the folder path: " folder_path

if [ ! -d "$folder_path" ]; then
  echo "Error: Folder does not exist."
  exit 1
fi

for file in "$folder_path"/*; do
  if [ -f "$file" ]; then
    if grep -q "$old_text" "$file"; then
      sed -i "s/${old_text}/${new_text}/g" "$file"
      echo "Updated: $file"
    else
      echo "No match in: $file"
    fi
  fi
done

