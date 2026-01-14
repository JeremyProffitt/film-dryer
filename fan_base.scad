// Film Dryer Fan Base
// Mounts 4x 80mm computer fans in 2x2 configuration
// Fans sit in deep recesses and blow air downward into box
// Designed to fit Bambu Labs H2D (max 350x320x325mm)

/* [Main Dimensions] */
base_width = 310; // mm - overall width
base_depth = 310; // mm - overall depth
base_height = 30; // mm - base plate thickness

/* [Fan Specifications] */
fan_size = 80; // mm - 80mm fan
fan_hole_spacing = 71.5; // mm - mounting hole center-to-center
fan_screw_diameter = 4.3; // mm - for M4 screws
fan_opening_diameter = 76; // mm - airflow opening
fan_corner_radius = 5; // mm - rounded corners on fans
fan_gap = 8; // mm - gap between fans

/* [Fan Recess] */
// Recess depth = base_height - 5mm (fans sit deep, only 5mm of base below)
recess_depth = base_height - 5; // 25mm deep
fan_recess_size = 85; // mm - 85x85mm square cutout for 80mm fans with gap

/* [Corner Mounting Holes] */
corner_inset = 25.4; // mm - 1 inch from corner
// #10 screw: shaft ~4.8mm, head ~9.5mm
mounting_hole_diameter = 5.0; // mm - clearance for #10 screw shaft
mounting_head_diameter = 10.0; // mm - clearance for #10 screw head
mounting_head_depth = 5.0; // mm - recess depth for screw head

/* [Cap Interface] */
lip_height = 10; // mm - raised rim for cap to fit over
lip_thickness = 4; // mm

/* [Calculated] */
fan_offset = (fan_size + fan_gap) / 2;

$fn = 48;

// Single fan mount with deep recess and screw holes
module fan_cutout() {
    // Deep square recess for fan body (from top, going down)
    // 85x85mm square with sharp corners
    translate([0, 0, base_height - recess_depth])
        linear_extrude(recess_depth + 1)
            square([fan_recess_size, fan_recess_size], center = true);

    // Through hole for airflow (all the way through remaining 5mm)
    cylinder(h = base_height * 3, d = fan_opening_diameter, center = true);

    // Screw holes for fan mounting
    hole_offset = fan_hole_spacing / 2;
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * hole_offset, y * hole_offset, 0])
                cylinder(h = base_height * 3, d = fan_screw_diameter, center = true);
        }
    }
}

// All 4 fans in 2x2 grid
module all_fan_cutouts() {
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * fan_offset, y * fan_offset, 0])
                fan_cutout();
        }
    }
}

// Corner mounting hole with head recess
module corner_mounting_hole() {
    // Through hole for screw shaft
    cylinder(h = base_height * 3, d = mounting_hole_diameter, center = true);

    // Recess for screw head (from top)
    translate([0, 0, base_height - mounting_head_depth])
        cylinder(h = mounting_head_depth + 1, d = mounting_head_diameter);
}

// All mounting holes - corners and side midpoints
module all_mounting_holes() {
    hole_offset = base_width/2 - corner_inset;

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

// Raised lip for cap interface
module cap_lip() {
    difference() {
        // Outer rim
        linear_extrude(lip_height)
            offset(r = 3) offset(r = -3)
                square([base_width, base_depth], center = true);

        // Inner cutout
        translate([0, 0, -1])
            linear_extrude(lip_height + 2)
                offset(r = 3) offset(r = -3)
                    square([base_width - 2*lip_thickness, base_depth - 2*lip_thickness], center = true);
    }
}

// Main base plate
module base_plate() {
    linear_extrude(base_height)
        offset(r = 3) offset(r = -3)
            square([base_width, base_depth], center = true);
}

// Complete fan base
module fan_base() {
    union() {
        // Base with fan cutouts and corner holes
        difference() {
            base_plate();
            all_fan_cutouts();
            all_mounting_holes();
        }

        // Lip on top
        translate([0, 0, base_height])
            cap_lip();
    }
}

// Render
fan_base();

// Debug output
echo("=== FAN BASE DIMENSIONS ===");
echo(str("Base: ", base_width, " x ", base_depth, " x ", base_height, " mm"));
echo(str("Total height with lip: ", base_height + lip_height, " mm"));
echo(str("Fan recess: ", fan_recess_size, " x ", fan_recess_size, " mm square (sharp corners)"));
echo(str("Fan recess depth: ", recess_depth, " mm (", base_height - recess_depth, " mm base remaining)"));
echo(str("Mounting holes: 8 total (4 corners + 4 side midpoints), ", corner_inset, " mm from edges"));
echo(str("Mounting hole: ", mounting_hole_diameter, " mm shaft, ", mounting_head_diameter, " mm head recess"));
