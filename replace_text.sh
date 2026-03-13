#!/bin/bash

# List all files in the current directory
echo "Here are the files in the current directory:"
ls

# Prompt the user to select a file
echo "Enter the name of the file you'd like to edit:"
read filename

# Verify the file exists
if [[ ! -f $filename ]]; then
    echo "File does not exist. Please try again."
    exit 1
fi

# Prompt for the number of replacements
echo "How many replacements do you want to perform?"
read count

# Loop to collect replacement pairs and perform substitutions
for ((i = 1; i <= count; i++)); do
    echo "Enter the text you want to replace (#$i):"
    read old_text
    echo "Enter the replacement text (#$i):"
    read new_text
    sed -i "s/$old_text/$new_text/g" "$filename"
done

# Confirmation message
echo "Performed $count replacements in '$filename'."
