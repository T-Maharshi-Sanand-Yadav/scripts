# Open a log file for writing
set log_file [open "in_out_inout_ports_and_count.log" "w"]

# Input Ports
set in_ports [get_ports -filter {direction == in}]
set in_count [sizeof_collection $in_ports]
puts $log_file "Input Ports (Count: $in_count):"
foreach port $in_ports {
    puts $log_file [get_object_name $port]
}
puts $log_file "\n"

# Output Ports
set out_ports [get_ports -filter {direction == out}]
set out_count [sizeof_collection $out_ports]
puts $log_file "Output Ports (Count: $out_count):"
foreach port $out_ports {
    puts $log_file [get_object_name $port]
}
puts $log_file "\n"

# Inout Ports
set inout_ports [get_ports -filter {direction == inout}]
set inout_count [sizeof_collection $inout_ports]
puts $log_file "Inout Ports (Count: $inout_count):"
foreach port $inout_ports {
    puts $log_file [get_object_name $port]
}
puts $log_file "\n"

# Close the log file
close $log_file
