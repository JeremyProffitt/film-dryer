// Film Dryer Fan Base
// Mounts 4x 80mm computer fans in 2x2 configuration
// Fans sit in deep recesses and blow air downward into box
// Designed to fit Bambu Labs H2D (max 350x320x325mm)

/**
 * Coordinate System:
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * Origin: Center of base plate, at ground level (centered design)
 */

/**
 * ===========================================
 * COMPONENT INDEX
 * ===========================================
 *
 * | Component            | Origin [X,Y,Z]      | Size [W,D,H]                        | Attaches To       |
 * |----------------------|---------------------|-------------------------------------|-------------------|
 * | base_plate           | [-W/2, -D/2, 0]     | [310.45, 310.45, 30]                | (ground)          |
 * | cap_lip              | [-W/2, -D/2, 30]    | [310.45, 310.45, 25] (hollow)       | base_plate top    |
 * | fan_cutout (x4)      | [+/-44, +/-44, 0]   | [85, 85, 25] recess + 76 dia hole   | base_plate        |
 * | corner_mounting_hole | [+/-125.2, +/-125.2, 0] | 5mm dia through, 10mm head      | base_plate        |
 * | fan_base (assembly)  | [-W/2, -D/2, 0]     | [310.45, 310.45, 55]                | complete unit     |
 *
 * Note: W = base_width_mm = 310.45, D = base_depth_mm = 310.45
 *       fan_offset_mm = 44mm (center-to-center of 2x2 fan grid)
 */

// ===========================================
// DIMENSIONS (all values in millimeters)
// ===========================================

/* [Filter Specifications] */
// Actual filter size: 11.75" x 11.75" x 0.75"
filter_width_mm = 298.45; // mm
filter_depth_mm = 298.45; // mm
filter_clearance_mm = 2; // mm - gap around filters for easy insertion
wall_thickness_mm = 5; // mm - must match filter_cap

/* [Calculated from Filter Size] */
interior_width_mm = filter_width_mm + filter_clearance_mm;
interior_depth_mm = filter_depth_mm + filter_clearance_mm;
base_width_mm = interior_width_mm + (2 * wall_thickness_mm); // mm - overall width
base_depth_mm = interior_depth_mm + (2 * wall_thickness_mm); // mm - overall depth

/* [Main Dimensions] */
base_height_mm = 30; // mm - base plate thickness

/* [Fan Specifications] */
fan_size_mm = 80; // mm - 80mm fan
fan_hole_spacing_mm = 71.5; // mm - mounting hole center-to-center
fan_screw_diameter_mm = 3.8; // mm - clearance for #6 screw shaft
fan_screw_head_diameter_mm = 7.0; // mm - flat head #6 screw head diameter (82 deg)
fan_screw_countersink_depth_mm = 2.2; // mm - depth of countersink cone
fan_opening_diameter_mm = 76; // mm - airflow opening
fan_corner_radius_mm = 5; // mm - rounded corners on fans
fan_gap_mm = 8; // mm - gap between fans

/* [Fan Recess] */
// Recess depth = base_height_mm - 5mm (fans sit deep, only 5mm of base below)
recess_depth_mm = base_height_mm - 5; // 25mm deep
fan_recess_size_mm = 85; // mm - 85x85mm square cutout for 80mm fans with gap

/* [Corner Mounting Holes] */
corner_inset_mm = 30; // mm - 1 inch from corner
// #10 screw: shaft ~4.8mm, head ~9.5mm
mounting_hole_diameter_mm = 5.0; // mm - clearance for #10 screw shaft
mounting_head_diameter_mm = 10.0; // mm - clearance for #10 screw head
mounting_head_depth_mm = 5.0; // mm - recess depth for screw head

/* [Cap Interface] */
lip_height_mm = 25; // mm - raised rim for cap to fit over
lip_thickness_mm = 20; // mm

/* [Calculated] */
fan_offset_mm = (fan_size_mm + fan_gap_mm) / 2;

$fn = 96; // Higher value for smoother curves

// ===========================================
// CONNECTION INTERFACES
// ===========================================

// Top surface center of base plate (where cap_lip sits)
function base_plate_top_center() = [0, 0, base_height_mm];

// Top of lip (highest point of assembly)
function cap_lip_top_center() = [0, 0, base_height_mm + lip_height_mm];

// Fan grid positions (2x2 configuration, returns list of [x,y] offsets)
function fan_positions() = [
    [-fan_offset_mm, -fan_offset_mm],
    [-fan_offset_mm,  fan_offset_mm],
    [ fan_offset_mm, -fan_offset_mm],
    [ fan_offset_mm,  fan_offset_mm]
];

// Mounting hole positions (8 total: 4 corners + 4 side midpoints)
function mounting_hole_positions() = let(
    hole_offset = base_width_mm/2 - corner_inset_mm
) [
    // 4 corners
    [-hole_offset, -hole_offset],
    [-hole_offset,  hole_offset],
    [ hole_offset, -hole_offset],
    [ hole_offset,  hole_offset],
    // 4 side midpoints
    [0, -hole_offset],
    [0,  hole_offset],
    [-hole_offset, 0],
    [ hole_offset, 0]
];

// ===========================================
// MODULES
// ===========================================

/**
 * Single Fan Cutout
 *
 * POSITION:
 *   Origin: Centered at [0, 0, 0] (translate to desired position)
 *
 * BOUNDING BOX:
 *   Min: [-42.5, -42.5, 0]
 *   Max: [42.5, 42.5, base_height_mm]
 *   Size: [85, 85, 30] (recess) + through hole
 *
 * ALIGNMENT:
 *   X: Centered on origin
 *   Y: Centered on origin
 *   Z: Starts at Z=0, recess from top
 *
 * CONNECTS TO:
 *   - base_plate: subtracted from base plate to create fan mounting
 */
module fan_cutout() {
    // Deep square recess for fan body (from top, going down)
    // 85x85mm square with sharp corners
    translate([0, 0, base_height_mm - recess_depth_mm])
        linear_extrude(recess_depth_mm + 1)
            square([fan_recess_size_mm, fan_recess_size_mm], center = true);

    // Through hole for airflow (all the way through remaining 5mm)
    cylinder(h = base_height_mm * 3, d = fan_opening_diameter_mm, center = true);

    // Screw holes for fan mounting with countersunk heads
    hole_offset = fan_hole_spacing_mm / 2;
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * hole_offset, y * hole_offset, 0]) {
                // Through hole for screw shaft
                cylinder(h = base_height_mm * 3, d = fan_screw_diameter_mm, center = true);
                // Countersink cone at bottom for flat head screw
                translate([0, 0, -1])
                    cylinder(h = fan_screw_countersink_depth_mm + 1,
                             d1 = fan_screw_head_diameter_mm,
                             d2 = fan_screw_diameter_mm);
            }
        }
    }
}

/**
 * All Fan Cutouts (2x2 Grid)
 *
 * POSITION:
 *   Origin: Centered at [0, 0, 0]
 *
 * BOUNDING BOX:
 *   Min: [-fan_offset_mm - 42.5, -fan_offset_mm - 42.5, 0]
 *   Max: [fan_offset_mm + 42.5, fan_offset_mm + 42.5, base_height_mm]
 *   Size: [fan_offset_mm*2 + 85, fan_offset_mm*2 + 85, 30]
 *
 * ALIGNMENT:
 *   X: Centered on base plate
 *   Y: Centered on base plate
 *   Z: Full height of base plate
 *
 * CONNECTS TO:
 *   - base_plate: subtracted to create 4 fan mounting positions
 */
module all_fan_cutouts() {
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * fan_offset_mm, y * fan_offset_mm, 0])
                fan_cutout();
        }
    }
}

/**
 * Corner Mounting Hole
 *
 * POSITION:
 *   Origin: Centered at [0, 0, 0] (translate to desired position)
 *
 * BOUNDING BOX:
 *   Min: [-5, -5, 0]
 *   Max: [5, 5, base_height_mm]
 *   Size: [10, 10, 30] (head diameter)
 *
 * ALIGNMENT:
 *   X: Centered on origin
 *   Y: Centered on origin
 *   Z: Through full height with head recess from top
 *
 * CONNECTS TO:
 *   - base_plate: subtracted for mounting screw clearance
 */
module corner_mounting_hole() {
    // Through hole for screw shaft
    cylinder(h = base_height_mm * 3, d = mounting_hole_diameter_mm, center = true);

    // Recess for screw head (from top)
    translate([0, 0, base_height_mm - mounting_head_depth_mm])
        cylinder(h = mounting_head_depth_mm + 1, d = mounting_head_diameter_mm);
}

/**
 * All Mounting Holes (8 total)
 *
 * POSITION:
 *   Origin: Centered at [0, 0, 0]
 *   Holes at: corners and side midpoints, corner_inset_mm from edges
 *
 * BOUNDING BOX:
 *   Holes distributed at base_width_mm/2 - corner_inset_mm from center
 *
 * ALIGNMENT:
 *   X: Symmetric about center
 *   Y: Symmetric about center
 *   Z: Through full height
 *
 * CONNECTS TO:
 *   - base_plate: subtracted for 8 mounting positions
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
 * Cap Lip (Raised Rim)
 *
 * POSITION:
 *   Origin: Centered at [0, 0, 0] (translate to top of base_plate)
 *
 * BOUNDING BOX:
 *   Min: [-base_width_mm/2, -base_depth_mm/2, 0]
 *   Max: [base_width_mm/2, base_depth_mm/2, lip_height_mm]
 *   Size: [base_width_mm, base_depth_mm, lip_height_mm] (hollow)
 *
 * ALIGNMENT:
 *   X: Centered, matches base_plate width
 *   Y: Centered, matches base_plate depth
 *   Z: Sits on top of base_plate at Z = base_height_mm
 *
 * CONNECTS TO:
 *   - base_plate: bottom surface flush with base_plate top surface
 *   - filter_cap: provides interface for cap to fit over
 */
module cap_lip() {
    difference() {
        // Outer rim - square corners
        linear_extrude(lip_height_mm)
            square([base_width_mm, base_depth_mm], center = true);

        // Inner cutout - square corners
        translate([0, 0, -1])
            linear_extrude(lip_height_mm + 2)
                square([base_width_mm - 2*lip_thickness_mm, base_depth_mm - 2*lip_thickness_mm], center = true);
    }
}

/**
 * Base Plate (Main Platform)
 *
 * POSITION:
 *   Origin: Centered at [0, 0, 0]
 *
 * BOUNDING BOX:
 *   Min: [-base_width_mm/2, -base_depth_mm/2, 0]
 *   Max: [base_width_mm/2, base_depth_mm/2, base_height_mm]
 *   Size: [base_width_mm, base_depth_mm, base_height_mm]
 *
 * ALIGNMENT:
 *   X: Centered on origin
 *   Y: Centered on origin
 *   Z: Bottom at Z=0, top at Z=base_height_mm
 *
 * CONNECTS TO:
 *   - (ground): bottom surface at Z=0
 *   - cap_lip: top surface at Z=base_height_mm
 */
module base_plate() {
    linear_extrude(base_height_mm)
        square([base_width_mm, base_depth_mm], center = true);
}

/**
 * Fan Base (Complete Assembly)
 *
 * POSITION:
 *   Origin: Centered at [0, 0, 0]
 *
 * BOUNDING BOX:
 *   Min: [-base_width_mm/2, -base_depth_mm/2, 0]
 *   Max: [base_width_mm/2, base_depth_mm/2, base_height_mm + lip_height_mm]
 *   Size: [base_width_mm, base_depth_mm, base_height_mm + lip_height_mm]
 *         [310.45, 310.45, 55]
 *
 * ALIGNMENT:
 *   X: Centered on origin
 *   Y: Centered on origin
 *   Z: Bottom at Z=0, top at Z=55mm
 *
 * CONNECTS TO:
 *   - (ground): bottom surface for mounting
 *   - filter_cap: lip provides interface for cap attachment
 */
module fan_base() {
    union() {
        // Base with fan cutouts and corner holes
        difference() {
            base_plate();
            all_fan_cutouts();
            all_mounting_holes();
        }

        // Lip on top
        translate([0, 0, base_height_mm])
            cap_lip();
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
    color("gray")      base_plate();
    color("blue")      translate([0, 0, base_height_mm]) cap_lip();
}

// Exploded view - separates components along Z axis
module assembly_exploded(separation = 30) {
    translate([0, 0, 0])
        difference() {
            base_plate();
            all_fan_cutouts();
            all_mounting_holes();
        }
    translate([0, 0, separation]) cap_lip();
}

// Debug: show fan base with bounding box
module debug_fan_base() {
    fan_base();
    debug_bounds(
        [-base_width_mm/2, -base_depth_mm/2, 0],
        [base_width_mm/2, base_depth_mm/2, base_height_mm + lip_height_mm]
    );
    debug_axes();
}

// ===========================================
// MAIN ASSEMBLY
// ===========================================

/**
 * Main Assembly
 *
 * Combines all components in their final positions.
 * Use assembly_colored() or assembly_exploded() for debugging.
 * Use debug_fan_base() to see bounding box and axes.
 */
module assembly() {
    fan_base();
}

// Render
color([0.6, 0.8, 1.0]) // Light blue
assembly();

// Debug output
echo("=== FAN BASE DIMENSIONS ===");
echo(str("Base: ", base_width_mm, " x ", base_depth_mm, " x ", base_height_mm, " mm"));
echo(str("Total height with lip: ", base_height_mm + lip_height_mm, " mm"));
echo(str("Fan recess: ", fan_recess_size_mm, " x ", fan_recess_size_mm, " mm square (sharp corners)"));
echo(str("Fan recess depth: ", recess_depth_mm, " mm (", base_height_mm - recess_depth_mm, " mm base remaining)"));
echo(str("Mounting holes: 8 total (4 corners + 4 side midpoints), ", corner_inset_mm, " mm from edges"));
echo(str("Mounting hole: ", mounting_hole_diameter_mm, " mm shaft, ", mounting_head_diameter_mm, " mm head recess"));
