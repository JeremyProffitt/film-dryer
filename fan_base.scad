// Film Dryer Fan Base
// Mounts 4x 80mm computer fans in 2x2 configuration
// Fans sit in recesses and blow air downward into box
// Designed to fit Bambu Labs H2D (max 350x320x325mm)

/* [Main Dimensions] */
base_width = 310; // mm - overall width
base_depth = 310; // mm - overall depth
base_height = 30; // mm - base thickness
wall_thickness = 4; // mm

/* [Fan Specifications] */
fan_size = 80; // mm - 80mm fan
fan_thickness = 25; // mm - standard fan depth
fan_hole_spacing = 71.5; // mm - mounting hole center-to-center
fan_screw_diameter = 4.3; // mm - for M4 screws
fan_opening_diameter = 76; // mm - airflow opening
fan_corner_radius = 5; // mm - rounded corners on fans
fan_gap = 8; // mm - gap between fans

/* [Fan Recess] */
recess_depth = 5; // mm - how deep fans sit into base
recess_clearance = 1; // mm - extra space around fan

/* [Flange Specifications] */
flange_width = 20; // mm
flange_length = 40; // mm
flange_thickness = 4; // mm
flange_hole_diameter = 5; // mm

/* [Cap Interface] */
lip_height = 10; // mm - raised rim for cap to fit over
lip_thickness = 4; // mm

/* [Calculated] */
fan_recess_size = fan_size + (2 * recess_clearance);
fan_offset = (fan_size + fan_gap) / 2;

$fn = 48;

// Single fan mount with recess and screw holes
module fan_cutout() {
    // Through hole for airflow
    cylinder(h = base_height * 3, d = fan_opening_diameter, center = true);

    // Recess for fan body (top side)
    translate([0, 0, base_height - recess_depth])
        linear_extrude(recess_depth + 1)
            offset(r = fan_corner_radius)
                offset(r = -fan_corner_radius)
                    square([fan_recess_size, fan_recess_size], center = true);

    // Screw holes
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

// Single mounting flange with holes
module flange() {
    difference() {
        cube([flange_length, flange_width, flange_thickness], center = true);

        // Two mounting holes
        hole_spacing = flange_length * 0.6;
        for (x = [-1, 1]) {
            translate([x * hole_spacing / 2, 0, 0])
                cylinder(h = flange_thickness + 2, d = flange_hole_diameter, center = true);
        }
    }
}

// All 8 flanges around perimeter
module all_flanges() {
    flange_inset = base_width / 4;
    flange_offset = base_width / 2 + flange_width / 2 - 2;

    // Front and back
    for (i = [-1, 1]) {
        // Front
        translate([i * flange_inset, -flange_offset, flange_thickness / 2])
            flange();
        // Back
        translate([i * flange_inset, flange_offset, flange_thickness / 2])
            flange();
    }

    // Left and right
    for (i = [-1, 1]) {
        // Left
        translate([-flange_offset, i * flange_inset, flange_thickness / 2])
            rotate([0, 0, 90])
                flange();
        // Right
        translate([flange_offset, i * flange_inset, flange_thickness / 2])
            rotate([0, 0, 90])
                flange();
    }
}

// Raised lip for cap interface
module cap_lip() {
    difference() {
        // Outer rim
        linear_extrude(lip_height)
            offset(r = 3)
                offset(r = -3)
                    square([base_width, base_depth], center = true);

        // Inner cutout
        translate([0, 0, -1])
            linear_extrude(lip_height + 2)
                offset(r = 3)
                    offset(r = -3)
                        square([base_width - 2*lip_thickness, base_depth - 2*lip_thickness], center = true);
    }
}

// Main base plate
module base_plate() {
    linear_extrude(base_height)
        offset(r = 3)
            offset(r = -3)
                square([base_width, base_depth], center = true);
}

// Complete fan base
module fan_base() {
    union() {
        // Base with fan cutouts
        difference() {
            base_plate();
            all_fan_cutouts();
        }

        // Lip on top
        translate([0, 0, base_height])
            cap_lip();

        // Flanges on bottom
        all_flanges();
    }
}

// Render
fan_base();

// Debug output
echo("=== FAN BASE DIMENSIONS ===");
echo(str("Base: ", base_width, " x ", base_depth, " x ", base_height, " mm"));
echo(str("Total height with lip: ", base_height + lip_height, " mm"));
echo(str("Fan opening: ", fan_opening_diameter, " mm diameter"));
echo(str("Fan recess: ", fan_recess_size, " x ", fan_recess_size, " x ", recess_depth, " mm"));
echo(str("Fan spacing: ", fan_offset * 2, " mm center-to-center"));
