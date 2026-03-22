#!/usr/bin/env python3

import re
import sys
import os

# Regex to capture direction, optional type, optional width, and names
port_regex = re.compile(
    r'\b(input|output|inout)\b\s*'
    r'(?:wire|reg|logic)?\s*'
    r'(\[[^\]]+\])?\s*'
    r'(.+)'
)

def extract_ports(file):

    inputs = []
    outputs = []
    inouts = []

    with open(file, "r") as f:
        for line in f:

            line = line.strip()

            # Skip empty lines and comments
            if not line or line.startswith("//"):
                continue

            match = port_regex.search(line)

            if match:

                direction, width, names = match.groups()

                # Split multiple ports
                ports = re.split(r',', names)

                for name in ports:

                    name = name.strip()
                    name = name.rstrip(',;')

                    # Skip empty entries
                    if not name:
                        continue

                    # Skip invalid entries like "[7:0]"
                    if re.match(r'^\[.*\]$', name):
                        continue

                    # Format: [7:0] data_in (industry style)
                    entry = f"{width} {name}".strip() if width else name

                    if direction == "input":
                        inputs.append(entry)

                    elif direction == "output":
                        outputs.append(entry)

                    else:
                        inouts.append(entry)

    return inputs, outputs, inouts


def print_ports(title, plist):

    print(f"{title} ({len(plist)}):")

    if not plist:
        print("  None")
        return

    for p in plist:
        print(" ", p)


def main():

    if len(sys.argv) != 2:
        print("Usage: extract_ports <file.v/.sv>")
        sys.exit(1)

    file = sys.argv[1]

    # Support both .v and .sv
    if not (file.endswith(".v") or file.endswith(".sv")):
        print("ERROR: Please provide a .v or .sv file")
        sys.exit(1)

    if not os.path.isfile(file):
        print(f"ERROR: File '{file}' not found")
        sys.exit(1)

    inputs, outputs, inouts = extract_ports(file)

    print("\n========== PORT SUMMARY ==========\n")

    print_ports("Inputs", inputs)
    print()

    print_ports("Outputs", outputs)
    print()

    print_ports("Inouts", inouts)

    print("\n=================================\n")


if __name__ == "__main__":
    main()