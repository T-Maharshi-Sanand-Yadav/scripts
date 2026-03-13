# remove_trailing_spaces.tcl

# Check for input file
if {[llength $argv] != 1} {
    puts "Usage: tclsh remove_trailing_spaces.tcl input_file.txt"
    exit 1
}

set inputFile [lindex $argv 0]
set outputFile "cleaned_$inputFile"

# Open input and output files
set in [open $inputFile r]
set out [open $outputFile w]

# Process each line
while {[gets $in line] >= 0} {
    # Remove trailing whitespace using regsub
    regsub {\s+$} $line "" cleanedLine
    puts $out $cleanedLine
}

close $in
close $out

puts "Trailing spaces removed. Output saved to '$outputFile'."

