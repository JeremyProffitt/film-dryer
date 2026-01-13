// Film Dryer Fan Base
// Mounts 4x 80mm computer fans in 2x2 configuration
// Includes flanges for mounting to box top
// Designed to fit Bambu Labs H2D (max 350x320x325mm)

/* [Main Dimensions] */
// Overall base size (fits under 12x12 filters)
base_size = 310; // mm - slightly larger than filter for walls
base_height = 35; // mm - height of base unit
wall_thickness = 3; // mm

/* [Fan Specifications] */
// 80mm computer fan dimensions
fan_size = 80; // mm
fan_hole_spacing = 71.5; // mm - center to center of mounting holes
fan_screw_diameter = 4.3; // mm - for M4 screws
fan_opening_diameter = 76; // mm - central opening for airflow
fan_spacing = 5; // mm - gap between fans

/* [Flange Specifications] */
flange_width = 25; // mm
flange_thickness = 4; // mm
flange_hole_diameter = 5; // mm - for mounting screws
flange_hole_inset = 10; // mm - distance from edge to hole center

/* [Filter Cap Interface] */
lip_height = 8; // mm - lip for cap to sit on
lip_inset = 5; // mm - how far lip is inset from edge

/* [Calculated Values] */
// 2x2 fan grid dimensions
fan_grid_size = (fan_size * 2) + fan_spacing;
fan_offset = (fan_size + fan_spacing) / 2;

module fan_mount_holes() {
    // Create 4 screw holes for one fan
    hole_offset = fan_hole_spacing / 2;
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * hole_offset, y * hole_offset, 0])
                cylinder(h = base_height + 2, d = fan_screw_diameter, $fn = 32);
        }
    }
}

module fan_opening() {
    // Central opening for airflow
    cylinder(h = base_height + 2, d = fan_opening_diameter, $fn = 64);
}

module single_fan_mount() {
    // Complete mount for one fan
    difference() {
        // Fan mount plate area is implicit in the base
        union() {}

        // Screw holes and opening will be cut from main body
    }
}

module fan_grid_cutouts() {
    // Position 4 fans in 2x2 grid
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * fan_offset, y * fan_offset, -1]) {
                fan_opening();
                fan_mount_holes();
            }
        }
    }
}

module flange() {
    // Single mounting flange with screw hole
    difference() {
        cube([flange_width, flange_width, flange_thickness]);
        translate([flange_width / 2, flange_hole_inset, -1])
            cylinder(h = flange_thickness + 2, d = flange_hole_diameter, $fn = 32);
    }
}

module flanges() {
    // Flanges on all 4 sides (2 per side, 8 total)
    flange_y_offset = base_size / 4;

    // Front flanges (extending in -Y direction)
    for (x = [-1, 1]) {
        translate([base_size/2 + x * flange_y_offset - flange_width/2, -flange_width, 0])
            flange();
    }

    // Back flanges (extending in +Y direction)
    for (x = [-1, 1]) {
        translate([base_size/2 + x * flange_y_offset - flange_width/2, base_size, 0])
            rotate([0, 0, 180])
                translate([-flange_width, 0, 0])
                    flange();
    }

    // Left flanges (extending in -X direction)
    for (y = [-1, 1]) {
        translate([-flange_width, base_size/2 + y * flange_y_offset - flange_width/2, 0])
            rotate([0, 0, 90])
                translate([0, -flange_width, 0])
                    flange();
    }

    // Right flanges (extending in +X direction)
    for (y = [-1, 1]) {
        translate([base_size, base_size/2 + y * flange_y_offset - flange_width/2, 0])
            rotate([0, 0, -90])
                flange();
    }
}

module base_body() {
    difference() {
        // Main rectangular base
        cube([base_size, base_size, base_height]);

        // Hollow out the interior (leaving walls)
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([base_size - 2*wall_thickness,
                  base_size - 2*wall_thickness,
                  base_height]);
    }
}

module lip_for_cap() {
    // Raised lip around perimeter for cap to sit on
    difference() {
        // Outer lip
        translate([lip_inset, lip_inset, base_height])
            cube([base_size - 2*lip_inset, base_size - 2*lip_inset, lip_height]);

        // Inner cutout
        translate([lip_inset + wall_thickness, lip_inset + wall_thickness, base_height - 1])
            cube([base_size - 2*lip_inset - 2*wall_thickness,
                  base_size - 2*lip_inset - 2*wall_thickness,
                  lip_height + 2]);
    }
}

module fan_base() {
    difference() {
        union() {
            base_body();
            lip_for_cap();
            flanges();

            // Add solid mounting pads for fans
            translate([base_size/2, base_size/2, 0]) {
                for (x = [-1, 1]) {
                    for (y = [-1, 1]) {
                        translate([x * fan_offset, y * fan_offset, 0]) {
                            // Mounting pad around each fan
                            cylinder(h = wall_thickness, d = fan_size + 10, $fn = 64);
                        }
                    }
                }
            }
        }

        // Cut fan openings and screw holes
        translate([base_size/2, base_size/2, 0])
            fan_grid_cutouts();
    }
}

// Render the fan base
fan_base();

// Print dimensions for verification
echo("=== FAN BASE DIMENSIONS ===");
echo(str("Base size: ", base_size, " x ", base_size, " mm"));
echo(str("Total height: ", base_height + lip_height, " mm"));
echo(str("Flange extension: ", flange_width, " mm beyond base"));
echo(str("Max footprint with flanges: ", base_size + 2*flange_width, " x ", base_size + 2*flange_width, " mm"));
echo(str("Fan grid size: ", fan_grid_size, " x ", fan_grid_size, " mm"));
