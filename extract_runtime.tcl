# ============================================
# Pretty Print Runtime Summary from Innovus Log
# ============================================
if {$argc != 1} {
    puts "Usage: tclsh extract_runtime.tcl <log_file>"
    exit 1
}

set logfile [lindex $argv 0]

if {![file exists $logfile]} {
    puts "ERROR: File $logfile does not exist."
    exit 1
}

set fid [open $logfile r]
set lines [split [read $fid] "\n"]
close $fid

# Print formatted table header
puts "================ Filtered Runtime Lines ================"
puts [format "%-20s | %-6s | %-6s | %-9s | %-12s" "Step" "CPU" "Real" "Memory" "Session CPU"]
puts [string repeat "-" 65]

foreach line $lines {
    # Match lines like: **stepName ... cpu = 0:00:14, real = 0:00:15, mem = 1095.9M, totSessionCpu=0:01:48 **
    if {[regexp {^\*\*(\S+).*cpu\s*=\s*([0-9:]+),\s*real\s*=\s*([0-9:]+),\s*mem\s*=\s*([0-9.]+M)(?:,\s*totSessionCpu\s*=\s*([0-9:]+))?} $line -> step cpu real mem session]} {
        if {$session eq ""} {
            set session "-"
        }
        puts [format "%-20s | %-6s | %-6s | %-9s | %-12s" $step $cpu $real $mem $session]
    }
}
puts "========================================================"

