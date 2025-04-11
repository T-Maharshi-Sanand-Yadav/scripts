#!/usr/bin/env python3

import re
import sys
import os

def print_usage():
    print("Usage:")
    print("  python3 update_area_from_lef.py <lef_file> <lib_file>")
    print("Or make it executable and run directly:")
    print("  ./update_area_from_lef.py <lef_file> <lib_file>\n")

def extract_lef_areas(lef_path):
    areas = {}
    with open(lef_path, 'r') as f:
        lines = f.readlines()

    cell_name = None
    for line in lines:
        if line.startswith("MACRO"):
            cell_name = line.split()[1]
        elif "SIZE" in line and cell_name:
            match = re.search(r"SIZE\s+([\d\.]+)\s+BY\s+([\d\.]+)", line)
            if match:
                x = float(match.group(1))
                y = float(match.group(2))
                areas[cell_name] = x * y
                cell_name = None
    return areas

def update_lib_areas(lib_path, lef_areas, output_path):
    with open(lib_path, 'r') as f:
        lib_lines = f.readlines()

    updated_lines = []
    current_cell = None
    updated_count = 0
    skipped_cells = set()

    for line in lib_lines:
        cell_match = re.match(r'\s*cell\s*\(\s*(\w+)\s*\)\s*{', line)
        if cell_match:
            current_cell = cell_match.group(1)

        if 'area :' in line:
            if current_cell in lef_areas:
                area_val = lef_areas[current_cell]
                line = f"    area : {area_val:.6f};\n"
                updated_count += 1
            else:
                skipped_cells.add(current_cell)

        updated_lines.append(line)

    with open(output_path, 'w') as f:
        f.writelines(updated_lines)

    print(f"\n✅ Updated .lib written to: {output_path}")
    print(f"📌 Total cells updated: {updated_count}")
    if skipped_cells:
        print(f"⚠️ Skipped cells (not found in LEF): {', '.join(sorted(skipped_cells))}")

# === Entry Point ===
if __name__ == "__main__":
    if len(sys.argv) != 3:
        print_usage()
        sys.exit(1)

    lef_file = sys.argv[1]
    lib_file = sys.argv[2]

    if not os.path.exists(lef_file):
        print(f"❌ LEF file not found: {lef_file}")
        sys.exit(1)
    if not os.path.exists(lib_file):
        print(f"❌ LIB file not found: {lib_file}")
        sys.exit(1)

    base_name, ext = os.path.splitext(lib_file)
    output_lib = f"{base_name}_updated{ext}"

    lef_areas = extract_lef_areas(lef_file)
    update_lib_areas(lib_file, lef_areas, output_lib)
