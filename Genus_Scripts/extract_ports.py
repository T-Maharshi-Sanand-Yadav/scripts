#!/usr/bin/env python3

import re
import sys
import os

port_regex = re.compile(
    r'\b(input|output|inout)\b\s*'
    r'(?:wire|reg)?\s*'
    r'(\[[^\]]+\])?\s*'
    r'([a-zA-Z_][a-zA-Z0-9_]*)'
)

def extract_ports(verilog_file):
    inputs, outputs, inouts = [], [], []

    with open(verilog_file, "r") as f:
        for line in f:
            line = line.strip()

            if not line or line.startswith("//"):
                continue

            m = port_regex.search(line)
            if m:
                direction, width, name = m.groups()
                width = width if width else "[0:0]"

                if direction == "input":
                    inputs.append(f"{name} {width}")
                elif direction == "output":
                    outputs.append(f"{name} {width}")
                else:
                    inouts.append(f"{name} {width}")

    return inputs, outputs, inouts


def main():

    if len(sys.argv) != 2:
        print("Usage: extract_ports <verilog_file.v>")
        sys.exit(1)

    verilog_file = sys.argv[1]

    if not verilog_file.endswith(".v"):
        print("ERROR: Please provide a .v file")
        sys.exit(1)

    if not os.path.isfile(verilog_file):
        print(f"ERROR: File '{verilog_file}' not found")
        sys.exit(1)

    inputs, outputs, inouts = extract_ports(verilog_file)

    print("\n========== PORT SUMMARY ==========\n")

    print("Inputs:")
    for i in inputs:
        print(" ", i)

    print("\nOutputs:")
    for o in outputs:
        print(" ", o)

    print("\nInouts:")
    print(" ", "None" if not inouts else inouts)

    print("\n=================================\n")


if __name__ == "__main__":
    main()

