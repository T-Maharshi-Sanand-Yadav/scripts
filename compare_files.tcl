#!/usr/bin/env tclsh

# Normalize lines: remove leading/trailing whitespace, blank lines, and sort uniquely
proc normalize_lines {filename} {
    set f [open $filename r]
    fconfigure $f -translation binary
    set raw_data [read $f]
    close $f

    # Normalize line endings to Unix-style
    set raw_data [string map {"\r\n" "\n" "\r" "\n"} $raw_data]
    set raw_lines [split $raw_data "\n"]

    set cleaned_lines {}
    foreach line $raw_lines {
        set trimmed [string trim $line]
        if {$trimmed ne ""} {
            lappend cleaned_lines $trimmed
        }
    }

    return [lsort -unique $cleaned_lines]
}

# Check encoding using the 'file' command
proc check_encoding {filename} {
    set cmd "file --mime-encoding $filename"
    set result [exec {*}$cmd]
    puts "Encoding of $filename: $result"
}

# Sanitize file names for use in output file names
proc sanitize_filename {filename} {
    return [string map {"/" "_" "\\" "_" " " "_"} [file tail $filename]]
}

# Compare two files after normalization
proc compare_files {file1 file2} {
    # Check encodings
    check_encoding $file1
    check_encoding $file2

    # Normalize and sort lines
    set unique1 [normalize_lines $file1]
    set unique2 [normalize_lines $file2]

    # Generate output file names
    set base1 [sanitize_filename $file1]
    set base2 [sanitize_filename $file2]
    set sameFileName "same_${base1}_${base2}.txt"
    set diffFileName "different_${base1}_${base2}.txt"

    # Open output files
    set sameFile [open $sameFileName w]
    set diffFile [open $diffFileName w]

    # Create sets for comparison
    array set a {}
    foreach line $unique1 {
        set a($line) 1
    }

    array set b {}
    foreach line $unique2 {
        set b($line) 1
    }

    # Compare and write results
    foreach line $unique1 {
        if {[info exists b($line)]} {
            puts $sameFile $line
        } else {
            puts $diffFile "[file tail $file1]: $line"
        }
    }

    foreach line $unique2 {
        if {![info exists a($line)]} {
            puts $diffFile "[file tail $file2]: $line"
        }
    }

    close $sameFile
    close $diffFile

    puts "Comparison complete."
    puts "Same lines written to: $sameFileName"
    puts "Differences written to: $diffFileName"
}

# Entry point
if {[info exists argv0] && $argv0 eq [info script]} {
    if {[llength $argv] != 2} {
        puts "Usage: tclsh compare_files.tcl file1.txt file2.txt"
        exit 1
    } else {
        compare_files [lindex $argv 0] [lindex $argv 1]
    }
} else {
    puts "Usage: tclsh compare_files.tcl file1.txt file2.txt"
}

