#!/bin/bash
# Generate STL and preview images for Film Dryer parts
# Output files are gitignored - GitHub Actions pipeline generates them

OPENSCAD="openscad"
OUTPUT_DIR="build"

echo "Creating output directories..."
mkdir -p "${OUTPUT_DIR}/stl"
mkdir -p "${OUTPUT_DIR}/images"

# Process all SCAD files
for scad_file in *.scad; do
    # Skip if no .scad files found
    [ -e "$scad_file" ] || continue

    # Get filename without extension
    name="${scad_file%.scad}"

    echo ""
    echo "=== Processing ${name} ==="

    echo "  Building STL..."
    ${OPENSCAD} -o "${OUTPUT_DIR}/stl/${name}.stl" "${scad_file}"

    echo "  Rendering front view..."
    ${OPENSCAD} -o "${OUTPUT_DIR}/images/${name}_front.png" \
        --camera=0,0,0,55,0,45,0 \
        --autocenter --viewall \
        --imgsize=1024,1024 \
        --colorscheme=Tomorrow \
        "${scad_file}"

    echo "  Rendering rear view..."
    ${OPENSCAD} -o "${OUTPUT_DIR}/images/${name}_rear.png" \
        --camera=0,0,0,55,0,225,0 \
        --autocenter --viewall \
        --imgsize=1024,1024 \
        --colorscheme=Tomorrow \
        "${scad_file}"

    echo "  Done with ${name}"
done

echo ""
echo "=== Build Complete ==="
echo ""
echo "STL files:"
ls -1 "${OUTPUT_DIR}/stl/"*.stl 2>/dev/null || echo "  No STL files generated"
echo ""
echo "Image files:"
ls -1 "${OUTPUT_DIR}/images/"*.png 2>/dev/null || echo "  No images generated"
