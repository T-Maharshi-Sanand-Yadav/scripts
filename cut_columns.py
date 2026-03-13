# dynamic_column_cutter.py

def detect_delimiter(line):
    if ',' in line:
        return ','
    elif '\t' in line:
        return '\t'
    else:
        return ' '  # default: space

input_file = input("Enter the input file name (e.g., input.txt): ").strip()
output_file = input("Enter the output file name (or leave blank to print): ").strip()
column_input = input("Enter column numbers to extract (comma-separated, e.g., 1,3,5): ").strip()

# Convert to 0-based indices
columns_to_extract = [int(i) - 1 for i in column_input.split(',') if i.strip().isdigit()]

with open(input_file, 'r') as fin:
    first_line = fin.readline()
    delimiter = detect_delimiter(first_line)
    fin.seek(0)  # go back to beginning

    output_lines = []
    for line in fin:
        if not line.strip():
            continue
        tokens = line.strip().split(delimiter)
        selected = [tokens[i] for i in columns_to_extract if i < len(tokens)]
        output_lines.append(delimiter.join(selected))

# Print or write to file
if output_file:
    with open(output_file, 'w') as fout:
        fout.write('\n'.join(output_lines) + '\n')
    print(f"[?] Output saved to {output_file}")
else:
    print("\n--- Extracted Output ---\n")
    print('\n'.join(output_lines))

