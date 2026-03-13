redirect lib_cell_with_no_lef_cells.rpt {
# Get all logical cell names from loaded libraries
set logical_cells [get_lib_cells *]

# Get all physical (LEF) cell names from leaf instances
set leaf_instances [get_leaf_cells *]
set lef_cells {}

# Extract reference cell names from leaf instances
foreach inst $leaf_instances {
    set ref_cell [get_attribute $inst ref_name]
    set lef_cells($ref_cell) 1
}

# Compare logical cells to LEF cells
foreach libcell $logical_cells {
    if {![info exists lef_cells($libcell)]} {
        puts "Libcell with no corresponding LEF cell: $libcell"
    }
}
}
