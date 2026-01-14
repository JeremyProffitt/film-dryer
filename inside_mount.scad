// Film Dryer Inside Mount Plate
// Bottom plate that mounts from inside the box
// Same footprint and mounting holes as fan_base

/* [Main Dimensions] */
base_width = 310; // mm - overall width (matches fan_base)
base_depth = 310; // mm - overall depth (matches fan_base)
plate_height = 10; // mm - plate thickness

/* [Corner Mounting Holes] */
corner_inset = 30; // mm - 1 inch from corner (matches fan_base)
// #10 screw: shaft ~4.8mm, head ~9.5mm
mounting_hole_diameter = 5.0; // mm - clearance for #10 screw shaft
mounting_head_diameter = 10.0; // mm - clearance for #10 screw head
mounting_head_depth = 5.0; // mm - recess depth for screw head

/* [Fan Cutout] */
// Cutout for airflow - covers all 4 fans
fan_size = 80; // mm - 80mm fan
fan_gap = 8; // mm - gap between fans
fan_offset = (fan_size + fan_gap) / 2; // 44mm
// Cutout size to encompass all 4 fan openings
cutout_size = 2 * fan_offset + fan_size + 10; // ~182mm
cutout_corner_radius = 10; // mm - rounded corners on cutout

$fn = 96; // Higher value for smoother curves

// Rounded square for cutout
module rounded_square(size, radius) {
    offset(r = radius)
        offset(r = -radius)
            square([size, size], center = true);
}

// Corner mounting hole with head recess
module corner_mounting_hole() {
    // Through hole for screw shaft
    cylinder(h = plate_height * 3, d = mounting_hole_diameter, center = true);

    // Recess for screw head (from top)
    translate([0, 0, plate_height - mounting_head_depth])
        cylinder(h = mounting_head_depth + 1, d = mounting_head_diameter);
}

// All mounting holes - corners and side midpoints (matches fan_base)
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

// Fan area cutout with rounded corners
module fan_cutout() {
    linear_extrude(plate_height + 2)
        rounded_square(cutout_size, cutout_corner_radius);
}

// Main plate
module base_plate() {
    linear_extrude(plate_height)
        square([base_width, base_depth], center = true);
}

// Complete inside mount plate
module inside_mount() {
    difference() {
        base_plate();
        translate([0, 0, -1])
            fan_cutout();
        all_mounting_holes();
    }
}

// Render
color([0.6, 0.8, 1.0]) // Light blue
inside_mount();

// Debug output
echo("=== INSIDE MOUNT DIMENSIONS ===");
echo(str("Plate: ", base_width, " x ", base_depth, " x ", plate_height, " mm"));
echo(str("Fan cutout: ", cutout_size, " x ", cutout_size, " mm with ", cutout_corner_radius, " mm corner radius"));
echo(str("Mounting holes: 8 total (4 corners + 4 side midpoints), ", corner_inset, " mm from edges"));
