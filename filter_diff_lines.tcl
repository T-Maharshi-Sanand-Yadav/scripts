# filter_diff_lines.tcl

# Procedure to normalize and compare files
proc normalize_and_compare {file1 file2} {
    # Read and normalize file1
    set f1 [open $file1 r]
    set lines1 [split [read $f1] "\n"]
    close $f1
    set unique1 [lsort -unique [regexp -all -inline {[^\s]+} $lines1]]

    # Read and normalize file2
    set f2 [open $file2 r]
    set lines2 [split [read $f2] "\n"]
    close $f2
    set unique2 [lsort -unique [regexp -all -inline {[^\s]+} $lines2]]

    # Create sets for comparison
    set set1 [array set a {}]
    foreach line $unique1 {
        set a($line) 1
    }

    # Filter and display lines from file2 that are not in file1
    foreach line $unique2 {
        if {![info exists a($line)]} {
            puts $line
        }
    }
}

# Show usage if sourced or incorrect usage
if {[info exists argv0] && $argv0 eq [info script]} {
    if {[llength $argv] != 2} {
        puts "Usage: tclsh filter_diff_lines.tcl input1.txt input2.txt"
        puts "This script removes all lines from input2.txt that are also present in input1.txt."
        exit 1
    } else {
        # Check encoding
        puts "Checking encoding of files..."
        exec file -i [lindex $argv 0]
        exec file -i [lindex $argv 1]

        # Normalize and compare files
        normalize_and_compare [lindex $argv 0] [lindex $argv 1]
    }
} else {
    puts "Usage: tclsh filter_diff_lines.tcl input1.txt input2.txt"
    puts "This script removes all lines from input2.txt that are also present in input1.txt."
}

