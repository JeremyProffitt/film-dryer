// Film Dryer Inside Mount Plate
// Bottom plate that mounts from inside the box
// Same footprint and mounting holes as fan_base

/**
 * Coordinate System:
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * Origin: Center of the base plate, at ground level
 */

/**
 * ===========================================
 * COMPONENT INDEX
 * ===========================================
 *
 * | Component           | Origin [X,Y,Z]                  | Size [W,D,H]                                      | Attaches To       |
 * |---------------------|---------------------------------|---------------------------------------------------|-------------------|
 * | base_plate          | [-base_width_mm/2, -base_depth_mm/2, 0] | [base_width_mm, base_depth_mm, plate_height_mm]   | (ground)          |
 * | fan_cutout          | [0, 0, -1]                      | [cutout_size_mm, cutout_size_mm, plate_height_mm+2] | (subtractive)     |
 * | corner_mounting_hole| varies (8 positions)            | cylinder d=mounting_hole_diameter_mm              | (subtractive)     |
 * | inside_mount        | centered                        | [base_width_mm, base_depth_mm, plate_height_mm]   | fan_base (below)  |
 *
 */

// ===========================================
// DIMENSIONS (all values in millimeters)
// ===========================================

// --- Filter Specifications ---
// Actual filter size: 11.75" x 11.75" x 0.75"
filter_width_mm = 298.45;       // Filter width
filter_depth_mm = 298.45;       // Filter depth
filter_clearance_mm = 2;        // Gap around filters for easy insertion
wall_thickness_mm = 5;          // Must match filter_cap

// --- Calculated from Filter Size ---
interior_width_mm = filter_width_mm + filter_clearance_mm;
interior_depth_mm = filter_depth_mm + filter_clearance_mm;
base_width_mm = interior_width_mm + (2 * wall_thickness_mm);   // Overall width (matches fan_base)
base_depth_mm = interior_depth_mm + (2 * wall_thickness_mm);   // Overall depth (matches fan_base)

// --- Main Plate Dimensions ---
plate_height_mm = 10;           // Plate thickness

// --- Corner Mounting Holes ---
corner_inset_mm = 30;           // 1 inch from corner (matches fan_base)
// #10 screw: shaft ~4.8mm, head ~9.5mm
mounting_hole_diameter_mm = 5.0;    // Clearance for #10 screw shaft
mounting_head_diameter_mm = 10.0;   // Clearance for #10 screw head
mounting_head_depth_mm = 5.0;       // Recess depth for screw head

// --- Fan Cutout ---
// Cutout for airflow - covers all 4 fans
fan_size_mm = 80;               // 80mm fan
fan_gap_mm = 8;                 // Gap between fans
fan_offset_mm = (fan_size_mm + fan_gap_mm) / 2;  // 44mm
// Cutout size to encompass all 4 fan openings
cutout_size_mm = 2 * fan_offset_mm + fan_size_mm + 10;  // ~182mm
cutout_corner_radius_mm = 10;   // Rounded corners on cutout

$fn = 96; // Higher value for smoother curves

// ===========================================
// CONNECTION INTERFACES
// ===========================================

// Top center of the inside mount plate (for connecting to filter frame)
function inside_mount_top_center() = [0, 0, plate_height_mm];

// Bottom center of the inside mount plate (for connecting to fan_base)
function inside_mount_bottom_center() = [0, 0, 0];

// Mounting hole positions (for alignment with fan_base)
function inside_mount_hole_positions() =
    let(hole_offset = base_width_mm/2 - corner_inset_mm)
    concat(
        // 4 corner holes
        [for (x = [-1, 1], y = [-1, 1]) [x * hole_offset, y * hole_offset, 0]],
        // 4 side middle holes
        [for (y = [-1, 1]) [0, y * hole_offset, 0]],
        [for (x = [-1, 1]) [x * hole_offset, 0, 0]]
    );

// ===========================================
// MODULES
// ===========================================

/**
 * Rounded Square for Cutout
 *
 * POSITION:
 *   Origin: Centered at [0, 0] in 2D
 *
 * BOUNDING BOX:
 *   Size: [size, size] (2D)
 *
 * ALIGNMENT:
 *   Centered on origin
 *
 * PARAMETERS:
 *   size - Width/height of the square
 *   radius - Corner radius
 */
module rounded_square(size, radius) {
    offset(r = radius)
        offset(r = -radius)
            square([size, size], center = true);
}

/**
 * Corner Mounting Hole with Head Recess
 *
 * POSITION:
 *   Origin: Centered on hole axis at Z=0
 *
 * BOUNDING BOX:
 *   Min: [-mounting_head_diameter_mm/2, -mounting_head_diameter_mm/2, -plate_height_mm*1.5]
 *   Max: [mounting_head_diameter_mm/2, mounting_head_diameter_mm/2, plate_height_mm*1.5]
 *   Size: [mounting_head_diameter_mm, mounting_head_diameter_mm, plate_height_mm*3]
 *
 * ALIGNMENT:
 *   Centered on XY, extends through plate in Z
 *
 * CONNECTS TO:
 *   - base_plate: Subtractive element
 *   - fan_base mounting holes (aligned)
 */
module corner_mounting_hole() {
    // Through hole for screw shaft
    cylinder(h = plate_height_mm * 3, d = mounting_hole_diameter_mm, center = true);

    // Recess for screw head (from top)
    translate([0, 0, plate_height_mm - mounting_head_depth_mm])
        cylinder(h = mounting_head_depth_mm + 1, d = mounting_head_diameter_mm);
}

/**
 * All Mounting Holes - Corners and Side Midpoints
 *
 * POSITION:
 *   Origin: Centered on plate center
 *
 * BOUNDING BOX:
 *   8 holes distributed at corner_inset_mm from edges
 *
 * ALIGNMENT:
 *   Matches fan_base hole pattern exactly
 *
 * CONNECTS TO:
 *   - base_plate: Subtractive elements
 *   - fan_base: Holes align with fan_base mounting holes
 */
module all_mounting_holes() {
    hole_offset = base_width_mm/2 - corner_inset_mm;

    // 4 corner holes
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * hole_offset, y * hole_offset, 0])
                corner_mounting_hole();
        }
    }

    // 4 side middle holes (same offset from edge)
    // Top and bottom sides
    for (y = [-1, 1]) {
        translate([0, y * hole_offset, 0])
            corner_mounting_hole();
    }
    // Left and right sides
    for (x = [-1, 1]) {
        translate([x * hole_offset, 0, 0])
            corner_mounting_hole();
    }
}

/**
 * Fan Area Cutout with Rounded Corners
 *
 * POSITION:
 *   Origin: Centered at [0, 0, 0]
 *
 * BOUNDING BOX:
 *   Min: [-cutout_size_mm/2, -cutout_size_mm/2, 0]
 *   Max: [cutout_size_mm/2, cutout_size_mm/2, plate_height_mm+2]
 *   Size: [cutout_size_mm, cutout_size_mm, plate_height_mm+2]
 *
 * ALIGNMENT:
 *   Centered on plate center, extends through plate thickness
 *
 * CONNECTS TO:
 *   - base_plate: Subtractive element creating airflow opening
 */
module fan_cutout() {
    linear_extrude(plate_height_mm + 2)
        rounded_square(cutout_size_mm, cutout_corner_radius_mm);
}

/**
 * Base Plate - Main Solid Body
 *
 * POSITION:
 *   Origin: Center of plate at Z=0
 *
 * BOUNDING BOX:
 *   Min: [-base_width_mm/2, -base_depth_mm/2, 0]
 *   Max: [base_width_mm/2, base_depth_mm/2, plate_height_mm]
 *   Size: [base_width_mm, base_depth_mm, plate_height_mm]
 *
 * ALIGNMENT:
 *   X: Centered on origin
 *   Y: Centered on origin
 *   Z: Bottom at Z=0, top at Z=plate_height_mm
 *
 * CONNECTS TO:
 *   - fan_cutout: Central opening for airflow
 *   - all_mounting_holes: 8 screw holes for attachment
 */
module base_plate() {
    linear_extrude(plate_height_mm)
        square([base_width_mm, base_depth_mm], center = true);
}

/**
 * Complete Inside Mount Plate
 *
 * POSITION:
 *   Origin: Center of plate at Z=0
 *
 * BOUNDING BOX:
 *   Min: [-base_width_mm/2, -base_depth_mm/2, 0]
 *   Max: [base_width_mm/2, base_depth_mm/2, plate_height_mm]
 *   Size: [base_width_mm, base_depth_mm, plate_height_mm]
 *
 * ALIGNMENT:
 *   Centered on XY plane, sitting on Z=0
 *
 * CONNECTS TO:
 *   - fan_base: Mounts below, holes align for #10 screws
 *   - filter frame: Sits on top, provides seal around filter
 */
module inside_mount() {
    difference() {
        base_plate();
        translate([0, 0, -1])
            fan_cutout();
        all_mounting_holes();
    }
}

// ===========================================
// DEBUG / VISUALIZATION
// ===========================================

// Render coordinate axes at origin (length = 50mm)
module debug_axes(length = 50) {
    color("red")   translate([0,0,0]) cylinder(h=length, r=1, $fn=16);  // Z
    color("green") rotate([0,90,0]) cylinder(h=length, r=1, $fn=16);    // X
    color("blue")  rotate([-90,0,0]) cylinder(h=length, r=1, $fn=16);   // Y
}

// Show bounding box for a component (transparent)
module debug_bounds(min_pt, max_pt) {
    color("yellow", 0.2)
        translate(min_pt)
            cube([max_pt[0] - min_pt[0], max_pt[1] - min_pt[1], max_pt[2] - min_pt[2]]);
}

// Color-coded assembly for visual debugging
module assembly_colored() {
    color([0.6, 0.8, 1.0]) inside_mount();
}

// Exploded view - separates components along Z axis
module assembly_exploded(separation = 30) {
    // Single component design - show internal structure
    color([0.6, 0.8, 1.0, 0.7]) base_plate();
    translate([0, 0, -separation])
        color([1.0, 0.4, 0.4, 0.5]) fan_cutout();
}

// ===========================================
// ASSEMBLY
// ===========================================

/**
 * Main Assembly
 *
 * Combines all components in their final positions.
 * Use assembly_colored() or assembly_exploded() for debugging.
 */
module assembly() {
    inside_mount();
}

// Default render
color([0.6, 0.8, 1.0]) // Light blue
assembly();

// Debug output
echo("=== INSIDE MOUNT DIMENSIONS ===");
echo(str("Plate: ", base_width_mm, " x ", base_depth_mm, " x ", plate_height_mm, " mm"));
echo(str("Fan cutout: ", cutout_size_mm, " x ", cutout_size_mm, " mm with ", cutout_corner_radius_mm, " mm corner radius"));
echo(str("Mounting holes: 8 total (4 corners + 4 side midpoints), ", corner_inset_mm, " mm from edges"));
