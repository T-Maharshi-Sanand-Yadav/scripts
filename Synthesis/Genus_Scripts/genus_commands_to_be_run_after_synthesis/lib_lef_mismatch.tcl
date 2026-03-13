redirect lib_lef_mismatch.rpt {
# === Get all logical cells from loaded libraries ===
set logical_cells [get_lib_cells *]

# === Get all leaf instances in the design ===
set leaf_instances [get_leaf_cells *]

# === Extract reference cell names from instances (LEF cells) ===
set lef_cells {}
foreach inst $leaf_instances {
    set ref_cell [get_attribute $inst ref_name]
    set lef_cells($ref_cell) 1
}

# === Check for LEF cells with no corresponding libcells ===
set checked_refs {}
puts "=== LEF cells with no corresponding libcells ==="
foreach inst $leaf_instances {
    set ref_cell [get_attribute $inst ref_name]
    if {[info exists checked_refs($ref_cell)]} {
        continue
    }
    set checked_refs($ref_cell) 1
    if {[lsearch -exact $logical_cells $ref_cell] == -1} {
        puts "LEF cell with no corresponding libcell: $ref_cell"
    }
}

# === Check for libcells with no corresponding LEF cells ===
puts "\n=== Libcells with no corresponding LEF cells (used in design) ==="
foreach libcell $logical_cells {
    if {![info exists lef_cells($libcell)]} {
        puts "Libcell with no corresponding LEF cell: $libcell"
    }
}

}
