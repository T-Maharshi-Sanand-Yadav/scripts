# Define the output report file
set report_file "check_design_report.rpt"
 
# Clear the report file and add a header
set rpt_fh [open $report_file "w"]
puts $rpt_fh "=========================== Cadence Genus Check Design Report ==========================="
close $rpt_fh
 
# Procedure to run check_design with a switch and append output or error to report
proc run_check_design {switch} {
    set temp_file "temp_check_design_output.txt"
    set rpt_file "check_design_report.rpt"
 
    # Build the command string
    set cmd "check_design $switch"
 
    # Try to run check_design and capture output or error
    if {[catch {
        redirect $temp_file "$cmd"
    } errMsg]} {
        # Log error message
        set rpt_fh [open $rpt_file "a"]
        puts $rpt_fh "=========================== check_design $switch ==========================="
        puts $rpt_fh "ERROR: Failed to run check_design $switch"
        puts $rpt_fh "DETAILS: $errMsg\n"
        close $rpt_fh
    } else {
        # Log successful output
        set rpt_fh [open $rpt_file "a"]
        puts $rpt_fh "=========================== check_design $switch ==========================="
        set temp_fh [open $temp_file r]
        set result [read $temp_fh]
        close $temp_fh
        puts $rpt_fh $result
        puts $rpt_fh "\n"
        close $rpt_fh
        file delete $temp_file
    }
}
 
# List of valid switches
set switches {
    -assigns
    -constant
    -lib_lef_consistency
    -logical_only
    -long_module_name
    -multiple_driver
    -only_user_hierarchy
    -physical_only
    -preserved
    -report_scan_pins
    -skip_scan_pins
    -status
    -unloaded
    -unloaded_comb
    -unresolved
    -vname
    -threshold_fanout
    -through_tie_cell
    -undriven
    -all
}
 
# Run check_design for each switch
foreach switch $switches {
    run_check_design $switch
}
 
puts "? All check_design reports saved to check_design_report.rpt"
