# =============================================================================================================
# Genus Post-Synthesis Analysis Script
# Purpose: Analyze design quality, timing, area, power, gates, utilization
# Author: MAHARSHI SANAND YADAV
# =============================================================================================================
source /home/vv2trainee33/logical_synthesis_apb_timer/run.tcl
source /home/vv2trainee33/logical_synthesis_sha256_fast/run.tcl

source /home/vv2trainee33/logical_synthesis_sha256_fast/sha256_fast.sdc
# =============================================================================================================
# 1. Port Categorization
# =============================================================================================================
get_ports -filter {direction == in}
get_ports -filter {direction == out}
get_ports -filter {direction == inout}

sizeof_collection [get_ports -filter {direction == in}]
sizeof_collection [get_ports -filter {direction == out}]
sizeof_collection [get_ports -filter {direction == inout}]

or

#Source this Script it will give port names as well as count
source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/in_out_inout_ports_and_count.tcl

#open this and check input/output/inout ports of your design
gedit /home/vv2trainee33/logical_synthesis_apb_timer/in_out_inout_ports_and_count.log


# =============================================================================================================
# 2. Lint Check for Timing Constraints and Design Issues
# =============================================================================================================
report_timing -lint > lint.rpt
check_design > check_design.rpt
# check_timing_intent ;# Uncomment if intentional timing constraints need to be verified

# Open and review these two files
/home/vv2trainee33/logical_synthesis_apb_timer/lint.rpt
/home/vv2trainee33/logical_synthesis_apb_timer/check_design.rpt

# =============================================================================================================
# 3. Generate Timing Reports (10 paths each)
# =============================================================================================================
report_timing -from [all_inputs]     -to [all_registers]  -max_paths 10 > 1.timing_report_in2reg.rpt
report_timing -from [all_registers]  -to [all_registers]  -max_paths 10 > 2.timing_report_reg2reg.rpt
report_timing -from [all_registers]  -to [all_outputs]    -max_paths 10 > 3.timing_report_reg2out.rpt
report_timing -from [all_inputs]     -to [all_outputs]    -max_paths 10 > 4.timing_report_in2out.rpt

# =============================================================================================================
# 4. Violation Summary from Timing Reports
# =============================================================================================================
source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/grep_timing_report | grep -i "VIOLATED"
source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/grep_timing_report | grep -v "VIOLATED"

# Source this in the path where logs got dumped, exit tool and check
source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/commands_for_report_timing.tcl
# =============================================================================================================
# 5. Summary Count of Critical Paths in Each Report
# =============================================================================================================
echo "1.timing_report_in2reg.rpt ="
cat 1.timing_report_in2reg.rpt | grep "Path " | wc

echo "2.timing_report_reg2reg.rpt ="
cat 2.timing_report_reg2reg.rpt | grep "Path " | wc

echo "3.timing_report_reg2out.rpt ="
cat 3.timing_report_reg2out.rpt | grep "Path " | wc

echo "4.timing_report_in2out.rpt ="
cat 4.timing_report_in2out.rpt | grep "Path " | wc

# =============================================================================================================
# 6. Detailed Path Dumps (Filtered)
# =============================================================================================================
echo "======================================================================================"
echo "1. Input to Register Paths"
echo "======================================================================================"
cat 1.timing_report_in2reg.rpt | grep "Path "

echo "======================================================================================"
echo "2. Register to Register Paths"
echo "======================================================================================"
cat 2.timing_report_reg2reg.rpt | grep "Path "

echo "======================================================================================"
echo "3. Register to Output Paths"
echo "======================================================================================"
cat 3.timing_report_reg2out.rpt | grep "Path "

echo "======================================================================================"
echo "4. Input to Output Paths"
echo "======================================================================================"
cat 4.timing_report_in2out.rpt | grep "Path "

# =============================================================================================================
# 7. Reports for Area, Power, Gate Count, and QoR
# =============================================================================================================
report_area > area.rpt
report_power > power.rpt
report_gates > gate_count.rpt
report_qor > qor.rpt
report_summary > summary.rpt
redirect summary.rpt {report_summary}
report_utilization > utilization.rpt
report_dp > datapath.rpt

# =============================================================================================================
# 8. Save Final Design
# =============================================================================================================
write_design

# =============================================================================================================
# 9. Port Delay, Driver, and Load Info
# =============================================================================================================
source ../scripts/genus_commands_to_be_run_after_synthesis/report_port_sha256 > report_port_delay_driver_load.rpt

# =============================================================================================================
# 10. Floorplan and Placement Checks
# =============================================================================================================
check_floorplan
check_placement

# =============================================================================================================
# 11. Write Database
# =============================================================================================================
write_db -to_file synthesized_design1.db


# =============================================================================================================
# 12. Load Database
# =============================================================================================================
read_db synthesized_design1.db


# =============================================================================================================
# 13. Launch GUI
# =============================================================================================================
gui_show


# =============================================================================================================
# 14. Fix Setup Violations
# =============================================================================================================

set_db syn_opt_effort high
help *effort*
set_db syn_opt_effort extreme
set_db syn_global_effort high


# =============================================================================================================
# 15. Retiming
# =============================================================================================================
retime -prepare
retime -min_delay

# =============================================================================================================
# 16. Steps to Optimize Only the Datapath in Genus
# =============================================================================================================
# Group the Path for Focused Optimization
group_path -name datapath_opt -from [get_pins core_w_mem_inst_w_mem_reg[1][11]/CK] -to [get_pins core_a_reg_reg[31]/D]

#Run Setup Optimization on the Grouped Path
opt_design -group datapath_opt -setup

This will:

1. Resize gates
2. Insert buffers
3. Restructure logic
4. Only within the datapath, not the clock path or unrelated logic




set_db syn_generic_effort express
set_db syn_map_effort express
set_db syn_opt_effort express

syn_generic
syn_map
syn_opt



set_dont_use [get_lib_cells *X1]
set_dont_use [get_lib_cells *X2]
set_dont_use [get_lib_cells *X4]
set_dont_use [get_lib_cells *X8]

# =============================================================================
# Check Design - THESE SHOULD BE CLEAN
# =============================================================================
Unresolved References               
Empty Modules                       
Unloaded Port(s)                    
Unloaded Sequential Pin(s)          
Unloaded Combinational Pin(s)       
Assigns                             
Undriven Port(s)                    
Undriven Leaf Pin(s)                
Undriven hierarchical pin(s)        
Multidriven Port(s)                 
Multidriven Leaf Pin(s)             
Multidriven hierarchical Pin(s)     
Multidriven unloaded net(s)         
Constant Port(s)                    
Constant Leaf Pin(s)                
Constant hierarchical Pin(s)        
Preserved leaf instance(s)          
Preserved hierarchical instance(s)  
Libcells with no LEF cell           
Physical (LEF) cells with no libcell
Subdesigns with long module name    
Physical only instance(s)           
Logical only instance(s)            
# =============================================================================================================
source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/check_design_report.tcl
# =============================================================================================================


# =============================================================================================================
# Fix Unloaded Combinational Pin(s) [check_design -unloaded_comb] [Unloaded Combinational Pin(s) ]
# =============================================================================================================
##### These are the Issues that i Faced #####
# 44 unloaded combinational pins

# 6 unloaded ports = Check Input and Output Ports in the Main RTL 
# 8 undriven ports = Check Input and Output Ports in the Main RTL

source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/report_unloaded_pins.tcl

# =============================================================================================================
# LIB VS LEF CONSISTENCY CHECKS [IN '1' and '2' if you are seeing any issue use the below mentioned scripts]
# =============================================================================================================
# 1. Libcells with no LEF cell           
# 2. Physical (LEF) cells with no libcell

source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/lef_cell_with_no_lib_cell.tcl
source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/lib_cell_with_no_lef_cells.tcl
source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/lib_lef_mismatch.tcl
source /home/vv2trainee33/scripts/genus_commands_to_be_run_after_synthesis/lib_lef_summary.tcl


# =============================================================================================================
# Lint Summary [If Found any Issues Fix SDC Constraints]
# =============================================================================================================

Lint summary
 Unconnected/logic driven clocks                                  0
 Sequential data pins driven by a clock signal                    0
 Sequential clock pins without clock waveform                     0
 Sequential clock pins with multiple clock waveforms              0
 Generated clocks without clock waveform                          0
 Generated clocks with incompatible options                       0
 Generated clocks with multi-master clock                         0
 Paths constrained with different clocks                          0
 Loop-breaking cells for combinational feedback                   0
 Nets with multiple drivers                                       0
 Timing exceptions with no effect                                 0
 Suspicious multi_cycle exceptions                                0
 Pins/ports with conflicting case constants                       0
 Inputs without clocked external delays                           0
 Outputs without clocked external delays                          0
 Inputs without external driver/transition                        0
 Outputs without external load                                    0
 Exceptions with invalid timing start-/endpoints                  0

                                                  Total:          0
# =============================================================================================================


gvimdiff physical_synthesis
sha256_slow_fast_250MHz


gvimdiff physical_synthesis/area.rpt sha256_slow_fast_250MHz/area.rpt
gvimdiff physical_synthesis/power.rpt sha256_slow_fast_250MHz/power.rpt
gvimdiff physical_synthesis/gate_count.rpt sha256_slow_fast_250MHz/gate_count.rpt
gvimdiff physical_synthesis/qor.rpt sha256_slow_fast_250MHz/qor.rpt
gvimdiff physical_synthesis/summary.rpt sha256_slow_fast_250MHz/summary.rpt
gvimdiff physical_synthesis/utilization.rpt sha256_slow_fast_250MHz/utilization.rpt
gvimdiff physical_synthesis/datapath.rpt sha256_slow_fast_250MHz/datapath.rpt

p physical_synthesis/area.rpt sha256_slow_fast_250MHz/area.rpt
p physical_synthesis/power.rpt sha256_slow_fast_250MHz/power.rpt
p physical_synthesis/gate_count.rpt sha256_slow_fast_250MHz/gate_count.rpt
p physical_synthesis/qor.rpt sha256_slow_fast_250MHz/qor.rpt
p physical_synthesis/summary.rpt sha256_slow_fast_250MHz/summary.rpt
p physical_synthesis/utilization.rpt sha256_slow_fast_250MHz/utilization.rpt
p physical_synthesis/datapath.rpt sha256_slow_fast_250MHz/datapath.rpt


/home/vv2trainee33/genus_work/physical_synthesis/area.rpt
/home/vv2trainee33/genus_work/physical_synthesis/check_design.rpt
/home/vv2trainee33/genus_work/physical_synthesis/check_timing_intent.rpt
/home/vv2trainee33/genus_work/physical_synthesis/datapath.rpt
/home/vv2trainee33/genus_work/physical_synthesis/gate_count.rpt
/home/vv2trainee33/genus_work/physical_synthesis/power.rpt
/home/vv2trainee33/genus_work/physical_synthesis/qor.rpt
/home/vv2trainee33/genus_work/physical_synthesis/summary.rpt
/home/vv2trainee33/genus_work/physical_synthesis/utilization.rpt


/home/vv2trainee33/genus_work/sha256_slow_fast_250MHz/area.rpt
/home/vv2trainee33/genus_work/sha256_slow_fast_250MHz/check_design.rpt
/home/vv2trainee33/genus_work/sha256_slow_fast_250MHz/check_timing_intent.rpt
/home/vv2trainee33/genus_work/sha256_slow_fast_250MHz/datapath.rpt
/home/vv2trainee33/genus_work/sha256_slow_fast_250MHz/gate_count.rpt
/home/vv2trainee33/genus_work/sha256_slow_fast_250MHz/power.rpt
/home/vv2trainee33/genus_work/sha256_slow_fast_250MHz/qor.rpt
/home/vv2trainee33/genus_work/sha256_slow_fast_250MHz/utilization.rpt
