# ==============================================================================
# Liberty Comparison Script for Cadence Genus
# Usage:
#   source compare_libs.tcl <lib1.lib> <lib2.lib>
# Example:
#   source compare_libs.tcl /path/to/slow.lib /path/to/fast.lib
# ==============================================================================

# Check usage
if {[llength $argv] != 2} {
    puts "Usage: source compare_libs.tcl <lib1.lib> <lib2.lib>"
    return
}

# Get input libs
set lib1_path [lindex $argv 0]
set lib2_path [lindex $argv 1]

# Extract library names (remove path and extension)
set lib1_name [file rootname [file tail $lib1_path]]
set lib2_name [file rootname [file tail $lib2_path]]

# Read libraries
puts "\n?? Reading libraries..."
read_lib $lib1_path
read_lib $lib2_path

# Get library handles
set lib1 [get_libs $lib1_name]
set lib2 [get_libs $lib2_name]

# Output report
set report_file "compare_${lib1_name}_vs_${lib2_name}.rpt"
set fp [open $report_file "w"]

puts $fp "=== Liberty Cell Comparison ==="
puts $fp "Library 1: $lib1_path"
puts $fp "Library 2: $lib2_path"
puts $fp "Generated on [clock format [clock seconds]]\n"

# Get cell lists
set cells1 [get_lib_cells -lib $lib1]
set cells2 [get_lib_cells -lib $lib2]

# Compare cell names
puts $fp "Cells only in $lib1_name:"
foreach cell $cells1 {
    if {[lsearch -exact $cells2 $cell] == -1} {
        puts $fp "  $cell"
    }
}

puts $fp "\nCells only in $lib2_name:"
foreach cell $cells2 {
    if {[lsearch -exact $cells1 $cell] == -1} {
        puts $fp "  $cell"
    }
}

# Compare pins for common cells
puts $fp "\n=== Pin Differences in Common Cells ==="
foreach cell $cells1 {
    if {[lsearch -exact $cells2 $cell] != -1} {
        set pins1 [get_lib_pins -lib $lib1 "$cell/*"]
        set pins2 [get_lib_pins -lib $lib2 "$cell/*"]

        set only_in_1 ""
        foreach pin $pins1 {
            if {[lsearch -exact $pins2 $pin] == -1} {
                append only_in_1 "$pin\n"
            }
        }

        set only_in_2 ""
        foreach pin $pins2 {
            if {[lsearch -exact $pins1 $pin] == -1} {
                append only_in_2 "$pin\n"
            }
        }

        if { $only_in_1 != "" || $only_in_2 != "" } {
            puts $fp "\nCell: $cell"
            if { $only_in_1 != "" } {
                puts $fp "  Pins only in $lib1_name:\n$only_in_1"
            }
            if { $only_in_2 != "" } {
                puts $fp "  Pins only in $lib2_name:\n$only_in_2"
            }
        }
    }
}

close $fp
puts "\n? Comparison done! Report written to: $report_file"

