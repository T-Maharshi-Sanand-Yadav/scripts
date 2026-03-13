#########################################################################
# Script: report_unloaded_pins.tcl
# Purpose: Report detailed net info for a known list of unloaded pins.
# Tool:    Cadence Genus
# Author:  MAHARSHI
# Usage:
#   1. Update the list of pins inside the 'set unloaded_pins' block
#   2. In Genus shell, run: source report_unloaded_pins.tcl
#   3. Output will be written to: unloaded_pins_report.log
#########################################################################

# === STEP 1: Define your list of unloaded pins ===
set unloaded_pins {
    sha256/core_csa_tree_add_337_39_cdnfadd_031_0/CO
    sha256/core_csa_tree_add_337_39_cdnfadd_031_1/CO
    sha256/core_csa_tree_add_337_39_cdnfadd_031_2/CO
    sha256/core_w_mem_inst_csa_tree_add_205_29_groupi_cdnfadd_031_0/CO
    sha256/core_w_mem_inst_csa_tree_add_205_29_groupi_cdnfadd_031_1/CO
    sha256/core_w_mem_inst_csa_tree_add_205_29_groupi_g76638/CO
    sha256/g72708__76626/CO
    sha256/g72710__76624/CO
    sha256/g72711__76622/CO
    sha256/g72713__76610/CO
    sha256/g72720__76632/CO
    sha256/g72740__76656/CO
    sha256/g72741__76630/CO
    sha256/g76060/CO
    sha256/g76062/CO
    sha256/g76064/CO
    sha256/g76066/CO
    sha256/g76068/CO
    sha256/g76094/CO
    sha256/g76096/CO
    sha256/g76098/CO
    sha256/g76100/CO
    sha256/g76102/CO
    sha256/g76104/CO
    sha256/g76106/CO
    sha256/g76108/CO
    sha256/g76110/CO
    sha256/g76112/CO
    sha256/g76114/CO
    sha256/g76116/CO
    sha256/g76118/CO
    sha256/g76120/CO
    sha256/g76122/CO
    sha256/g76124/CO
    sha256/g76126/CO
    sha256/g76128/CO
    sha256/g76130/CO
    sha256/g76132/CO
    sha256/g76134/CO
    sha256/g76136/CO
    sha256/g76138/CO
    sha256/g76140/CO
    sha256/g76178/S
    sha256/g76606/CO
    sha256/g76608/CO
    sha256/g76612/CO
    sha256/g76614/CO
    sha256/g76616/CO
    sha256/g76618/CO
    sha256/g76620/CO
    sha256/g76628/CO
    sha256/g76634/CO
    sha256/g76654/CO
    sha256/g76658/CO
}

# === STEP 2: Write reports to a log file ===
redirect unloaded_pins_report.log {
    foreach pin $unloaded_pins {
        puts "====== Reporting: $pin ======"
        report_nets -pin $pin
    }
}

# === END OF SCRIPT ===

