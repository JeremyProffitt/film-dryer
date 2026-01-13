// Film Dryer Fan System - Assembly View
// Shows both parts together for visualization
// DO NOT PRINT THIS FILE - print fan_base.scad and filter_cap.scad separately

/* [Assembly Options] */
show_fan_base = true;
show_filter_cap = true;
exploded_view = true;
explode_distance = 50; // mm - separation in exploded view

/* [Colors] */
base_color = "DodgerBlue";
cap_color = "Orange";
filter_color = "White";

// Include the individual parts
use <fan_base.scad>
use <filter_cap.scad>

/* [Shared Dimensions - must match both files] */
base_size = 310;
base_height = 35;
lip_height = 8;
lip_inset = 5;

filter_width = 298.45;
filter_depth = 298.45;
filter_height = 19.05;
wall_thickness = 3;

// Calculate cap dimensions
interior_width = filter_width + 1.5;
interior_depth = filter_depth + 1.5;
exterior_width = interior_width + (2 * wall_thickness);
exterior_depth = interior_depth + (2 * wall_thickness);

module show_filters() {
    // Show filter positions for visualization
    filter_x = (base_size - filter_width) / 2;
    filter_y = (base_size - filter_depth) / 2;
    filter_z_base = base_height + lip_height + wall_thickness + 2;

    color(filter_color, 0.5) {
        // Bottom filter
        translate([filter_x, filter_y, filter_z_base + (exploded_view ? explode_distance : 0)])
            cube([filter_width, filter_depth, filter_height]);

        // Top filter
        translate([filter_x, filter_y, filter_z_base + filter_height + 1 + (exploded_view ? explode_distance : 0)])
            cube([filter_width, filter_depth, filter_height]);
    }
}

module assembly() {
    // Fan base at origin
    if (show_fan_base) {
        color(base_color)
            fan_base();
    }

    // Filter cap positioned above base
    if (show_filter_cap) {
        cap_offset_x = (base_size - exterior_width) / 2;
        cap_offset_y = (base_size - exterior_depth) / 2;
        cap_z = base_height + (exploded_view ? explode_distance : 0);

        color(cap_color)
            translate([cap_offset_x, cap_offset_y, cap_z])
                filter_cap();
    }

    // Show filter positions
    show_filters();
}

// Render assembly
assembly();

// Assembly information
echo("=== ASSEMBLY INFORMATION ===");
echo("This file is for visualization only.");
echo("Print fan_base.scad and filter_cap.scad separately.");
echo("");
echo("=== TOTAL ASSEMBLED DIMENSIONS ===");
total_height = base_height + lip_height + (filter_height * 2) + wall_thickness + 15 + 10;
echo(str("Footprint: ", base_size + 50, " x ", base_size + 50, " mm (with flanges)"));
echo(str("Total height (assembled): ~", total_height, " mm"));
