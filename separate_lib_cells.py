import re
import os
import logging

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def separate_lib_cells(input_file, output_dir):
    # Validate input file
    if not os.path.isfile(input_file):
        logging.error(f"Input file '{input_file}' does not exist or is not a file.")
        raise FileNotFoundError(f"Input file '{input_file}' not found.")

    # Create output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        logging.info(f"Created output directory: {output_dir}")
    
    # Read the entire input file
    try:
        with open(input_file, 'r') as f:
            content = f.read()
        logging.info(f"Successfully read input file: {input_file}")
    except Exception as e:
        logging.error(f"Failed to read input file: {str(e)}")
        raise
    
    # Regular expression to match cell blocks
    # Matches 'cell (name) { ... }' with nested braces
    cell_pattern = r'cell\s*\(\s*([^\s\)]+)\s*\)\s*\{([^}]+(?:\{[^}]*\})*[^}]*)\}'
    cell_matches = list(re.finditer(cell_pattern, content, re.DOTALL))
    
    if not cell_matches:
        logging.warning("No cell blocks found in the input file.")
        raise ValueError("No cell blocks found in the input file.")
    
    logging.info(f"Found {len(cell_matches)} cell blocks in the input file.")
    
    for match in cell_matches:
        cell_name = match.group(1).strip()  # Extract cell name
        cell_content = match.group(0).strip()  # Extract entire cell block: cell (name) { ... }
        logging.info(f"Processing cell: {cell_name}")
        
        # Define output file path
        output_file = os.path.join(output_dir, f"{cell_name}.lib")
        
        # Write the cell content to a new file with a basic Liberty header
        try:
            with open(output_file, 'w') as f:
                f.write(f"library ({cell_name}) {{\n")
                f.write("  delay_model : table_lookup;\n")
                f.write("  technology : cmos;\n")
                f.write("}\n\n")
                f.write(cell_content + "\n")
            logging.info(f"Created file: {output_file}")
        except Exception as e:
            logging.error(f"Failed to write output file '{output_file}': {str(e)}")
            continue
    
    if not os.listdir(output_dir):
        logging.warning("No output files were created. Check the input file format.")

def main():
    input_file = "input.lib"  # Replace with the path to your input .lib file
    output_dir = "output_cells"  # Directory where individual .lib files will be saved
    
    try:
        separate_lib_cells(input_file, output_dir)
        logging.info("Successfully separated cells into individual .lib files.")
    except FileNotFoundError as e:
        logging.error(str(e))
    except ValueError as e:
        logging.error(str(e))
    except Exception as e:
        logging.error(f"An unexpected error occurred: {str(e)}")

if __name__ == "__main__":
    main()

