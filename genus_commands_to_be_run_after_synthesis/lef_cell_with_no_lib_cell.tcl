redirect lef_cell_with_no_lib_cell.rpt {
# Get all leaf instances in the design
set leaf_instances [get_leaf_cells *]

# Get all logical cell names from loaded libraries
set logical_cells [get_lib_cells *]

# Create a set to track already checked reference cells
set checked_refs {}

# Compare reference cells of leaf instances to logical cells
foreach inst $leaf_instances {
    set ref_cell [get_attribute $inst ref_name]

    # Avoid checking the same ref_cell multiple times
    if {[info exists checked_refs($ref_cell)]} {
        continue
    }
    set checked_refs($ref_cell) 1

    # Check if the reference cell exists in the logical cell list
    if {[lsearch -exact $logical_cells $ref_cell] == -1} {
        puts "LEF cell with no corresponding libcell: $ref_cell"
    }
}
}
