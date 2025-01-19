#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <filename1> <filename2> ..."
  exit 1
fi

# Iterate through all provided arguments
for FILE in "$@"; do
  if [ -f "$FILE" ]; then
    echo "Full path of '$FILE': $(realpath "$FILE")"
  else
    echo "File not found: $FILE"
  fi
done