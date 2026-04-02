#!/usr/bin/env python3
# -*- coding: utf-8 -*-

###############################################################################
# Script: compare_excel.py
# Description:
#   Compare two Excel (.xlsx) files using gvimdiff with REAL text extraction
#
# Author:
#   T Maharshi Sanand Yadav
#
# Usage:
#   python3 compare_excel.py file1.xlsx file2.xlsx
###############################################################################

import sys
import zipfile
import xml.etree.ElementTree as ET
import subprocess


# -------------------------------
# Load Shared Strings (IMPORTANT)
# -------------------------------
def load_shared_strings(z):
    shared_strings = []
    try:
        with z.open("xl/sharedStrings.xml") as f:
            tree = ET.parse(f)
            root = tree.getroot()

            ns = {'a': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}

            for si in root.findall(".//a:si", ns):
                text_parts = []
                for t in si.findall(".//a:t", ns):
                    text_parts.append(t.text if t.text else "")
                shared_strings.append("".join(text_parts))
    except:
        pass

    return shared_strings


# -------------------------------
# Extract Excel Sheet Data
# -------------------------------
def extract_matrix(xlsx_file):
    with zipfile.ZipFile(xlsx_file) as z:

        shared_strings = load_shared_strings(z)

        with z.open("xl/worksheets/sheet1.xml") as f:
            tree = ET.parse(f)
            root = tree.getroot()

            ns = {'a': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}

            matrix = []

            for row in root.findall(".//a:row", ns):
                row_data = []

                for c in row.findall("a:c", ns):
                    cell_type = c.attrib.get("t")
                    v = c.find("a:v", ns)

                    value = ""

                    if v is not None:
                        if cell_type == "s":  # Shared string
                            idx = int(v.text)
                            value = shared_strings[idx]
                        else:
                            value = v.text

                    row_data.append(value)

                matrix.append(row_data)

    return matrix


# -------------------------------
# Write aligned text (UTF-8 safe)
# -------------------------------
def write_text(matrix, filename):
    col_widths = []

    # Find max width per column
    for row in matrix:
        for i, val in enumerate(row):
            val = str(val)
            if i >= len(col_widths):
                col_widths.append(len(val))
            else:
                col_widths[i] = max(col_widths[i], len(val))

    # Write file with UTF-8 encoding
    with open(filename, "w", encoding="utf-8") as f:
        for row in matrix:
            line = ""
            for i, val in enumerate(row):
                val = str(val)
                line += val.ljust(col_widths[i] + 2)
            f.write(line.rstrip() + "\n")


# -------------------------------
# Main Function
# -------------------------------
def main():
    if len(sys.argv) != 3:
        print("Usage: python3 compare_excel.py file1.xlsx file2.xlsx")
        sys.exit(1)

    file1 = sys.argv[1]
    file2 = sys.argv[2]

    print("?? Extracting REAL Excel text...")

    m1 = extract_matrix(file1)
    m2 = extract_matrix(file2)

    f1 = "excel_diff_1.txt"
    f2 = "excel_diff_2.txt"

    write_text(m1, f1)
    write_text(m2, f2)

    print("?? Opening gvimdiff...")

    try:
        subprocess.call(["gvimdiff", f1, f2])
    except Exception:
        print("?? gvimdiff not found, using vimdiff...")
        subprocess.call(["vimdiff", f1, f2])


# -------------------------------
# Entry
# -------------------------------
if __name__ == "__main__":
    main()