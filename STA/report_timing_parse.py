import sys
import os
import re

if len(sys.argv) != 2:
    print("Usage: python parse_sta_rpt.py <input_file.rpt>")
    sys.exit(1)

input_file = sys.argv[1]
base, ext = os.path.splitext(input_file)
output_file = f"{base}_updated{ext}"

with open(input_file, "r") as f_in, open(output_file, "w") as f_out:
    # Header with fixed width for remaining columns
    f_out.write(
        f"{'Row':<4}  {'Path_Number':<12}  {'Startpoint':<70}  {'Endpoint':<70}  "
        f"{'Path_Group':<20}  {'Analysis_View':<18}  {'Slack_Time':<10}  {'Slack_Status':<10}\n"
    )

    row_number = 1
    path_number = startpoint = endpoint = path_group = analysis_view = slack_time = slack_status = ""

    for line in f_in:
        line = line.strip()
        if not line:
            continue

        # Detect Path line
        path_match = re.match(r"Path\s+(\d+):", line)
        if path_match:
            path_number = path_match.group(1)
            slack_status = "VIOLATED" if "VIOLATED" in line else ("MET" if "MET" in line else "")
            continue

        # Beginpoint
        if line.startswith("Beginpoint:"):
            temp = line.replace("Beginpoint:", "").strip()
            startpoint = re.split(r"\s*\(\^|\s*\(v|\s*checked with", temp)[0].strip()
            continue

        # Endpoint
        if line.startswith("Endpoint:"):
            temp = line.replace("Endpoint:", "").strip()
            endpoint = re.split(r"\s*\(\^|\s*\(v|\s*checked with", temp)[0].strip()
            continue

        # Path Groups
        if line.startswith("Path Groups:"):
            path_group = re.sub(r"[{}]", "", line.replace("Path Groups:", "").strip())
            continue

        # Analysis View
        if line.startswith("Analysis View:"):
            analysis_view = line.replace("Analysis View:", "").strip()
            continue

        # Slack Time
        if "Slack Time" in line:
            match = re.search(r"([-+]?\d*\.\d+|\d+)", line)
            if match:
                slack_time = match.group(1)
                path_group = path_group or "-"
                analysis_view = analysis_view or "-"
                slack_status = slack_status or "VIOLATED"

                # Write the row with improved spacing for remaining columns
                f_out.write(
                    f"{row_number:<4}  "
                    f"{path_number:<12}  "
                    f"{startpoint:<70}  "
                    f"{endpoint:<70}  "
                    f"{path_group:<20}  "
                    f"{analysis_view:<18}  "
                    f"{slack_time:<10}  "
                    f"{slack_status:<10}\n"
                )
                row_number += 1
                # Reset for next path
                startpoint = endpoint = path_group = analysis_view = slack_time = slack_status = ""

print(f"Parsing complete! Output saved to {output_file}")

