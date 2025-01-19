#!/bin/bash
# This script prints the full path of a given file

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

FILE="$1"
if [ -f "$FILE" ]; then
    echo "Full path: $(realpath "$FILE")"
else
    echo "File not found: $FILE"
fi