#!/usr/bin/env python3
"""
Usage:
    python3 extract_metal_layers.py <lef_file_path>

Description:
    This script extracts metal layer properties from a LEF file, including:
    - Direction
    - Width
    - Pitch X
    - Pitch Y
    - Area
    - Resistance
    - Capacitance
    - Thickness

Output:
    - metal_layers.txt: Detailed metal layer information

Author: MAHARSHI SANAND YADAV
"""

import sys

def print_usage():
    print(__doc__)

def extract_metal_layers(lef_path, output_path):
    """Extracts metal layer properties from the LEF file."""
    with open(lef_path, "r") as f:
        lines = f.readlines()

    metal_layers = []
    layer = {}
    inside_layer = False

    for line in lines:
        line = line.strip()

        # Detect start of a layer block
        if line.startswith("LAYER"):
            layer_name = line.split()[1]
            layer = {
                "Layer": layer_name,
                "Direction": "",
                "Width": "",
                "Pitch X": "",
                "Pitch Y": "",
                "Area": "",
                "Resistance": "",
                "Capacitance": "",
                "Thickness": ""
            }
            inside_layer = True

        # Identify routing layers
        elif "TYPE ROUTING" in line and inside_layer:
            layer["Type"] = "ROUTING"

        # Extract layer properties
        elif line.startswith("DIRECTION") and inside_layer:
            layer["Direction"] = line.split()[1]
        elif line.startswith("WIDTH") and inside_layer:
            layer["Width"] = line.split()[1]
        elif line.startswith("AREA") and inside_layer:
            layer["Area"] = line.split()[1]
        elif line.startswith("PITCH") and inside_layer:
            parts = line.split()[1:]
            layer["Pitch X"] = parts[0]
            if len(parts) > 1:
                layer["Pitch Y"] = parts[1]
        elif line.startswith("RESISTANCE") and inside_layer:
            layer["Resistance"] = line.split()[2]
        elif line.startswith("CAPACITANCE") and inside_layer:
            layer["Capacitance"] = line.split()[2]
        elif line.startswith("THICKNESS") and inside_layer:
            layer["Thickness"] = line.split()[1]

        # End of layer block
        elif line.startswith("END") and inside_layer:
            if layer.get("Type") == "ROUTING":
                metal_layers.append(layer)
            inside_layer = False

    # Write extracted data to output file
    with open(output_path, "w") as f:
        for layer in metal_layers:
            f.write(f"Metal Layer: {layer['Layer']}\n")
            f.write(f"  Direction:   {layer['Direction']}\n")
            f.write(f"  Width:       {layer['Width']}\n")
            f.write(f"  Pitch X:     {layer['Pitch X']}\n")
            f.write(f"  Pitch Y:     {layer['Pitch Y']}\n")
            f.write(f"  Area:        {layer['Area']}\n")
            f.write(f"  Resistance:  {layer['Resistance']}\n")
            f.write(f"  Capacitance: {layer['Capacitance']}\n")
            f.write(f"  Thickness:   {layer['Thickness']}\n\n")

    print(f"? Metal layer details written to {output_path}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print_usage()
        sys.exit(1)

    lef_path = sys.argv[1]
    extract_metal_layers(lef_path, "metal_layers.txt")

