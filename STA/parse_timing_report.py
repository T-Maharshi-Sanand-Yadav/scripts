#!/usr/bin/env python3
###############################################################################
# Script: parse_sta_paths.py
# Description:
#   Parses Genus timing reports containing multiple timing paths.
#   Extracts summary for each path.
#
# Usage:
#   python parse_sta_paths.py report.rpt
###############################################################################

import sys
import re

if len(sys.argv) != 2:
    print("Usage: python parse_sta_paths.py <report.rpt>")
    sys.exit(1)

file = sys.argv[1]

with open(file) as f:
    data = f.read()


# ---------------------------------------------------------
# Split report into path blocks
# ---------------------------------------------------------

paths = re.split(r'\n(?=Path\s+\d+:)', data)

print("\n================ Timing Path Summary ================\n")

for block in paths:

    path = re.search(r'Path\s+(\d+):\s+(\w+)', block)
    startpoint = re.search(r'Startpoint:\s+\(\w\)\s+(.+)', block)
    endpoint = re.search(r'Endpoint:\s+\(\w\)\s+(.+)', block)
    group = re.search(r'Group:\s+(\S+)', block)
    slack = re.search(r'Slack:=\s+(-?\d+)', block)
    datapath = re.search(r'Data Path:-\s+(\d+)', block)

    if path:
        print(f"Path Number : {path.group(1)}")
        print(f"Status      : {path.group(2)}")

        if group:
            print(f"Group       : {group.group(1)}")

        if startpoint:
            print(f"Startpoint  : {startpoint.group(1)}")

        if endpoint:
            print(f"Endpoint    : {endpoint.group(1)}")

        if datapath:
            print(f"Data Path   : {datapath.group(1)} ps")

        if slack:
            print(f"Slack       : {slack.group(1)} ps")

        print("----------------------------------------------------")

print("\n=====================================================\n")