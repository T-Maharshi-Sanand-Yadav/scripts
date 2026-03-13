#!/bin/bash
###############################################################################
# Script: extract_cells.sh
# Author: Maharshi Sanand Yadav
# Description:
#   This script extracts individual cell blocks from a Liberty (.lib) file.
#   Each "cell (<cellname>) { ... }" is saved into its own .lib file inside
#   a folder called extracted_cells/
#
# Usage:
#   ./extract_cells.sh /full/path/to/input.lib
#
# Output:
#   - extracted_cells/           <- directory containing all <cellname>.lib files
#   - cell_list.txt              <- list of all cell names extracted (in cwd)
###############################################################################

# Function to print usage info
print_usage() {
    echo "Usage: $0 /path/to/input.lib"
    echo "Example: ./extract_cells.sh ./fast.lib"
    exit 1
}

# Check if user passed an argument
if [ $# -ne 1 ]; then
    echo "Error: Missing input .lib file"
    print_usage
fi

# Assign input file from user argument
libfile="$1"

# Check if file exists
if [ ! -f "$libfile" ]; then
    echo "Error: File '$libfile' not found."
    print_usage
fi

# Output directory and cell list file
outdir="extracted_cells"
celllist="cell_list.txt"

# Create the output directory if it doesn't exist
mkdir -p "$outdir"

# Clear old cell list file
> "$celllist"

# Use awk to parse the .lib file and extract each cell into its own .lib file
awk -v outdir="$outdir" -v celllist="$celllist" '
# Detect the beginning of a cell block (supports leading whitespace)
$0 ~ /^[[:space:]]*cell[[:space:]]*\(/ {
    # Extract cell name using regex
    match($0, /cell[[:space:]]*\(([^\)]+)\)/, arr)
    cellname = arr[1]
    # Define output file path for this cell
    outfile = outdir "/" cellname ".lib"
    # Print log message
    print "Extracting: " cellname " -> " outfile
    # Record cell name to list
    print cellname >> celllist
    # Set flag to start collecting lines
    in_cell = 1
}

# Detect end of cell block and stop writing to file
/^}/ && in_cell {
    print >> outfile
    close(outfile)
    in_cell = 0
    next
}

# While inside a cell block, write each line to output file
in_cell {
    print >> outfile
}
' "$libfile"

echo "Extraction completed."
echo "Cell files saved in: $outdir/"
echo "Cell list saved in: $celllist"

