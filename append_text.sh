#!/bin/bash

# Ask for input file with tab completion
read -e -p "Enter the input file name (e.g., l0.txt): " file

# Ask for text to append
read -p "Enter the text to append at the end of each line: " append_text

# Check if file exists
if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found!"
    exit 1
fi

# Build output filename (inputname_updated)
filename="${file%.*}"
extension="${file##*.}"

if [[ "$filename" == "$file" ]]; then
    # no extension case
    output="${file}_updated"
else
    output="${filename}_updated.${extension}"
fi

# Process file
sed "s/$/${append_text}/" "$file" > "$output"

echo "Done! Created '$output' with '${append_text}' appended to each line."

