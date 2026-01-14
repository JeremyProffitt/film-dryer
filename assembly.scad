// Film Dryer Fan System - Assembly View
// Shows both parts together with filters for visualization
// DO NOT PRINT THIS FILE - print fan_base.scad and filter_cap.scad separately

/* [View Options] */
show_fan_base = true;
show_filter_cap = true;
show_filters = true;
show_fans = true;
exploded_view = true;
explode_distance = 30; // mm

/* [Colors] */
base_color = "SteelBlue";
cap_color = "Orange";
filter_color = "WhiteSmoke";
fan_color = "DimGray";

// Shared dimensions (must match individual files)
base_width = 310;
base_height = 30;
lip_height = 10;
lip_thickness = 4;
recess_depth = base_height - 5; // 25mm

filter_width = 298.45;
filter_depth = 298.45;
filter_height = 19.05;

fan_size = 80;
fan_gap = 8;
fan_offset = (fan_size + fan_gap) / 2;
fan_opening = 76;

corner_inset = 25.4;

// Filter cap dimensions
cap_wall = 5;
interior_width = filter_width + 2;
interior_depth = filter_depth + 2;
exterior_width = interior_width + (2 * cap_wall);
exterior_depth = interior_depth + (2 * cap_wall);
total_filter_height = (filter_height * 2) + 2;
cap_height = total_filter_height + 3 + 5;
skirt_height = lip_height + 5;

// Grid settings
grid_holes = 8;
grid_bar_width = 4;

$fn = 32;

// Visualization of an 80mm fan
module fan_model() {
    color(fan_color) {
        difference() {
            linear_extrude(25)
                offset(r = 5) offset(r = -5)
                    square([fan_size, fan_size], center = true);
            cylinder(h = 30, d = fan_opening - 5, center = true);
        }
        cylinder(h = 22, d = 25, center = true);
        for (i = [0:6]) {
            rotate([0, 0, i * (360/7)])
                translate([18, 0, 0])
                    cube([20, 2, 18], center = true);
        }
    }
}

// Visualization of a filter
module filter_model() {
    color(filter_color, 0.8)
        cube([filter_width, filter_depth, filter_height], center = true);
}

// Fan base visualization
module fan_base_visual() {
    color(base_color) {
        difference() {
            // Main plate
            linear_extrude(base_height)
                offset(r = 3) offset(r = -3)
                    square([base_width, base_width], center = true);

            // Deep fan recesses and openings
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * fan_offset, y * fan_offset, 0]) {
                        // Deep recess
                        translate([0, 0, base_height - recess_depth])
                            linear_extrude(recess_depth + 1)
                                offset(r = 5) offset(r = -5)
                                    square([82, 82], center = true);
                        // Through hole
                        cylinder(h = base_height * 3, d = fan_opening, center = true);
                    }
                }
            }

            // Corner mounting holes
            hole_pos = base_width/2 - corner_inset;
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * hole_pos, y * hole_pos, 0]) {
                        cylinder(h = base_height * 3, d = 5, center = true);
                        translate([0, 0, base_height - 5])
                            cylinder(h = 6, d = 10);
                    }
                }
            }
        }

        // Lip
        translate([0, 0, base_height])
            difference() {
                linear_extrude(lip_height)
                    offset(r = 3) offset(r = -3)
                        square([base_width, base_width], center = true);
                translate([0, 0, -1])
                    linear_extrude(lip_height + 2)
                        offset(r = 3) offset(r = -3)
                            square([base_width - 2*lip_thickness, base_width - 2*lip_thickness], center = true);
            }
    }
}

// Filter cap visualization
module filter_cap_visual() {
    color(cap_color) {
        // Frame walls
        difference() {
            linear_extrude(cap_height)
                offset(r = 3) offset(r = -3)
                    square([exterior_width, exterior_depth], center = true);
            translate([0, 0, -1])
                linear_extrude(cap_height + 2)
                    square([interior_width - 10, interior_depth - 10], center = true);
        }

        // Top grid with smaller holes
        grid_z = cap_height - 15;
        usable = interior_width - 20;
        hole_size = (usable - (grid_holes + 1) * grid_bar_width) / grid_holes;
        step = hole_size + grid_bar_width;

        translate([0, 0, grid_z]) {
            difference() {
                linear_extrude(15)
                    offset(r = 3) offset(r = -3)
                        square([exterior_width, exterior_depth], center = true);

                start = -usable/2 + grid_bar_width + hole_size/2;
                for (ix = [0:grid_holes-1]) {
                    for (iy = [0:grid_holes-1]) {
                        translate([start + ix * step, start + iy * step, -1])
                            cube([hole_size, hole_size, 17], center = true);
                    }
                }
            }
        }

        // Bottom skirt
        skirt_interior = base_width - (2 * lip_thickness) + 0.5;
        translate([0, 0, -skirt_height])
            difference() {
                linear_extrude(skirt_height)
                    offset(r = 3) offset(r = -3)
                        square([skirt_interior + 10, skirt_interior + 10], center = true);
                translate([0, 0, cap_wall])
                    linear_extrude(skirt_height)
                        square([skirt_interior, skirt_interior], center = true);
            }
    }
}

// Complete assembly
module assembly() {
    explode = exploded_view ? explode_distance : 0;

    // Fan base
    if (show_fan_base)
        fan_base_visual();

    // Fans sitting in deep recesses
    if (show_fans) {
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * fan_offset, y * fan_offset, base_height - recess_depth + 12.5])
                    fan_model();
            }
        }
    }

    // Filter cap (above base)
    cap_base_z = base_height + lip_height;
    if (show_filter_cap)
        translate([0, 0, cap_base_z + cap_height/2 + skirt_height/2 + explode])
            filter_cap_visual();

    // Filters inside cap
    if (show_filters) {
        filter_z = cap_base_z + 5 + explode;
        translate([0, 0, filter_z + filter_height/2])
            filter_model();
        translate([0, 0, filter_z + filter_height + 2 + filter_height/2])
            filter_model();
    }
}

// Render
assembly();

// Info
echo("=== ASSEMBLY INFO ===");
echo("Blue: Fan base - 4x 80mm fans in 25mm deep recesses, corner mounting holes");
echo("Gray: 80mm computer fans (shown in recesses)");
echo("Orange: Filter cap - 8x8 grid, holds 2 stacked filters");
echo("White: Furnace filters 11.75x11.75x0.75 inches (x2 stacked)");
echo("");
echo("Airflow: Air enters top through filters -> fans blow down into box");
