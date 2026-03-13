#!/usr/bin/env python3
"""
extract_spacing.py

Usage:
    python3 extract_spacing.py <lef_file_path> [output_file_path]

Description:
    This script extracts SPACINGTABLE information from a LEF (Library Exchange Format) file.
    It identifies each layer and captures the spacing table associated with it, then writes
    the extracted information to the specified output file.

Arguments:
    <lef_file_path>        Path to the input LEF file.
    [output_file_path]     (Optional) Path to the output file. Defaults to 'spacing_info.txt' in the current directory.

Example:
    python3 extract_spacing.py /home/user/gsclib045.fixed2.lef
    python3 extract_spacing.py /home/user/gsclib045.fixed2.lef output.txt
"""

import sys
import os

def print_usage():
    """Prints usage instructions for the script."""
    print("\nUsage:")
    print("  python3 extract_spacing.py <lef_file_path> [output_file_path]\n")
    print("Description:")
    print("  Extracts SPACINGTABLE information from a LEF file and writes it to an output file.")
    print("  If no output file is specified, it defaults to 'spacing_info.txt' in the current directory.\n")
    print("Arguments:")
    print("  <lef_file_path>        Path to the input LEF file.")
    print("  [output_file_path]     (Optional) Output file path. Default: ./spacing_info.txt\n")
    print("Example:")
    print("  python3 extract_spacing.py /home/user/gsclib045.fixed2.lef")
    print("  python3 extract_spacing.py /home/user/gsclib045.fixed2.lef output.txt\n")

def extract_spacing(lef_path, output_path):
    """Extracts spacing table information from a LEF file and writes it to an output file."""
    try:
        with open(lef_path, "r") as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"\n? Error: File '{lef_path}' not found.\n")
        return

    spacing_info = []
    inside_layer = False
    inside_spacing_table = False
    current_layer = ""

    # Process each line in the LEF file
    for line in lines:
        line = line.strip()

        # Detect the start of a new layer
        if line.startswith("LAYER"):
            current_layer = line.split()[1]
            inside_layer = True

        # Detect the end of the current layer
        elif line.startswith("END") and inside_layer:
            inside_layer = False
            inside_spacing_table = False

        # Detect the start of a spacing table within a layer
        elif "SPACINGTABLE" in line and inside_layer:
            inside_spacing_table = True
            spacing_info.append(f"\nLayer: {current_layer}")
            spacing_info.append("SPACINGTABLE")

        # Collect lines within the spacing table block
        elif inside_spacing_table:
            formatted_line = "    " + line  # Indent for readability
            spacing_info.append(formatted_line)
            if ";" in line:
                inside_spacing_table = False  # End of SPACINGTABLE block

    # Write the extracted spacing information to the output file
    with open(output_path, "w") as f:
        for line in spacing_info:
            f.write(line + "\n")

    print(f"\n? Spacing information successfully written to '{output_path}'\n")

# Entry point of the script
if __name__ == "__main__":
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print_usage()
    else:
        lef_path = sys.argv[1]
        output_path = sys.argv[2] if len(sys.argv) == 3 else os.path.join(os.getcwd(), "spacing_info.txt")
        extract_spacing(lef_path, output_path)

