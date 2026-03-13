set filename "report_commands.tcl"
set fileId [open $filename r]
set cmds [split [read $fileId] "\n"]
close $fileId

foreach cmd $cmds {
    set cmd_trimmed [string trim $cmd]
    if {$cmd_trimmed eq ""} { continue }

    puts "\n-----------------------------"
    puts "Running $cmd_trimmed..."
    puts "-----------------------------"

    # Try to execute the command and catch errors
    if {[catch {eval $cmd_trimmed} err]} {
        puts "Error executing '$cmd_trimmed': $err"
    }

    puts "\n"
}

