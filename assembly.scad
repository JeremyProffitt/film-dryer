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

filter_width = 298.45;
filter_depth = 298.45;
filter_height = 19.05;

fan_size = 80;
fan_gap = 8;
fan_offset = (fan_size + fan_gap) / 2;
fan_opening = 76;

// Filter cap dimensions
cap_wall = 5;
cap_interior = filter_width + 2;
cap_exterior = cap_interior + (2 * cap_wall);
total_filter_height = (filter_height * 2) + 2;
cap_height = total_filter_height + 3 + 5;
skirt_height = lip_height + 5;

$fn = 32;

// Visualization of an 80mm fan
module fan_model() {
    color(fan_color) {
        difference() {
            // Fan housing
            linear_extrude(25)
                offset(r = 5) offset(r = -5)
                    square([fan_size, fan_size], center = true);

            // Center opening
            cylinder(h = 30, d = fan_opening - 5, center = true);
        }

        // Hub
        cylinder(h = 22, d = 25, center = true);

        // Blades
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

            // Fan openings
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * fan_offset, y * fan_offset, -1])
                        cylinder(h = base_height + 2, d = fan_opening);

                    // Recesses
                    translate([x * fan_offset, y * fan_offset, base_height - 5])
                        linear_extrude(6)
                            offset(r = 5) offset(r = -5)
                                square([82, 82], center = true);
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
                            square([base_width - 8, base_width - 8], center = true);
            }

        // Flanges
        flange_inset = base_width / 4;
        for (angle = [0, 90, 180, 270]) {
            rotate([0, 0, angle])
                for (i = [-1, 1]) {
                    translate([i * flange_inset, -base_width/2 - 8, 2])
                        cube([40, 20, 4], center = true);
                }
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
                    square([cap_exterior, cap_exterior], center = true);

            translate([0, 0, -1])
                linear_extrude(cap_height + 2)
                    square([cap_interior - 10, cap_interior - 10], center = true);
        }

        // Top grid
        grid_z = cap_height - 15;
        bar_width = 12;

        // Perimeter at top
        translate([0, 0, grid_z])
            difference() {
                linear_extrude(15)
                    offset(r = 3) offset(r = -3)
                        square([cap_exterior, cap_exterior], center = true);
                translate([0, 0, -1])
                    linear_extrude(17)
                        square([cap_interior - 20, cap_interior - 20], center = true);
            }

        // Cross bars
        spacing = cap_interior / 4;
        translate([0, 0, grid_z]) {
            for (i = [-1, 0, 1]) {
                translate([i * spacing, 0, 7.5])
                    cube([bar_width, cap_interior - 20, 15], center = true);
                translate([0, i * spacing, 7.5])
                    cube([cap_interior - 20, bar_width, 15], center = true);
            }
        }

        // Bottom skirt
        translate([0, 0, -skirt_height])
            difference() {
                linear_extrude(skirt_height)
                    offset(r = 3) offset(r = -3)
                        square([base_width + 2, base_width + 2], center = true);
                translate([0, 0, -1])
                    linear_extrude(skirt_height + 2)
                        square([base_width - 8 + 1, base_width - 8 + 1], center = true);
            }
    }
}

// Complete assembly
module assembly() {
    explode = exploded_view ? explode_distance : 0;

    // Fan base
    if (show_fan_base)
        fan_base_visual();

    // Fans sitting in recesses
    if (show_fans) {
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * fan_offset, y * fan_offset, base_height - 5 + 12.5])
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

        // Bottom filter
        translate([0, 0, filter_z + filter_height/2])
            filter_model();

        // Top filter
        translate([0, 0, filter_z + filter_height + 2 + filter_height/2])
            filter_model();
    }
}

// Render
assembly();

// Info
echo("=== ASSEMBLY INFO ===");
echo("Blue: Fan base - mounts 4x 80mm fans, attaches to box via flanges");
echo("Gray: 80mm computer fans (shown in recesses)");
echo("Orange: Filter cap - holds 2 stacked filters, sits on base lip");
echo("White: Furnace filters 11.75x11.75x0.75 inches (x2 stacked)");
echo("");
echo("Airflow: Air enters top through filters -> fans blow down into box");
