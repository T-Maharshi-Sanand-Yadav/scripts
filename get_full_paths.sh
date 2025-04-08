#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <file_or_directory1> <file_or_directory2> ..."
  exit 1
fi

# Iterate through all provided arguments
for ITEM in "$@"; do
  if [ -e "$ITEM" ]; then
    echo "$(realpath "$ITEM")"
  else
    echo "Not found: $ITEM"
  fi
done
