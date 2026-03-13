get_ports -filter {direction == in}
get_ports -filter {direction == out}
get_ports -filter {direction == inout}


report_timing -lint > lint.rpt

check_design

#check_timing_intent


report_timing -from [all_inputs] -to [all_registers]  -max_paths 10000 > 1.timing_report_in2reg.rpt  
report_timing -from [all_registers] -to [all_registers]  -max_paths 10000 > 2.timing_report_reg2reg.rpt 
report_timing -from [all_registers] -to [all_outputs]  -max_paths 10000 > 3.timing_report_reg2out.rpt 
report_timing -from [all_inputs] -to [all_outputs]  -max_paths 10000 > 4.timing_report_in2out.rpt 

#redirect timing_report_in2reg.rpt {source timing_report.tcl}
#redirect timing_report_reg2reg.rpt {source timing_report.tcl}
#redirect timing_report_reg2out.rpt {source timing_report.tcl}
#redirect timing_report_in2out.rpt {source timing_report.tcl}


source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/grep_timing_report | grep -i "VIOLATED"
source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/grep_timing_report | grep -v "VIOLATED"



echo "1.timing_report_in2reg.rpt ="
cat 1.timing_report_in2reg.rpt | grep "Path " | wc

echo "2.timing_report_reg2reg.rpt ="
cat 2.timing_report_reg2reg.rpt | grep "Path " | wc

echo "3.timing_report_reg2out.rpt ="
cat 3.timing_report_reg2out.rpt | grep "Path " | wc

echo "4.timing_report_in2out.rpt ="
cat 4.timing_report_in2out.rpt | grep "Path " | wc



echo "======================================================================================"
echo "1.timing_report_in2reg.rpt ="
echo "======================================================================================"
cat 1.timing_report_in2reg.rpt | grep "Path "


echo "======================================================================================"
echo "2.timing_report_reg2reg.rpt ="
echo "======================================================================================"
cat 2.timing_report_reg2reg.rpt | grep "Path "


echo "======================================================================================"
echo "3.timing_report_reg2out.rpt ="
echo "======================================================================================"
cat 3.timing_report_reg2out.rpt | grep "Path "


echo "======================================================================================"
echo "4.timing_report_in2out.rpt ="
echo "======================================================================================"
cat 4.timing_report_in2out.rpt | grep "Path "


echo "======================================================================================"
echo "Done"
echo "======================================================================================"



report_area > area.rpt
report_power > power.rpt
report_gates > gate_count.rpt
report_qor > qor.rpt
report_summary > summary.rpt
report_utilization > utilization.rpt
report_dp > datapath.rpt

write_design

source ../scripts/genus_commands_to_be_run_after_synthesis/report_port_sha256 > report_port_delay_driver_load.rpt

check_floorplan
check_placement



