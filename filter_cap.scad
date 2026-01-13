// Film Dryer Filter Cap
// Holds 2x 12x12x1 furnace filters (actual 11.75x11.75x0.75 inches)
// Fits over fan base assembly
// Designed to fit Bambu Labs H2D (max 350x320x325mm)

/* [Filter Specifications] */
// Actual filter dimensions (11.75 x 11.75 x 0.75 inches)
filter_width = 298.45; // mm (11.75 inches)
filter_depth = 298.45; // mm (11.75 inches)
filter_height = 19.05; // mm (0.75 inches)
num_filters = 2; // Stacked vertically
filter_tolerance = 1.5; // mm - extra space for easy filter insertion

/* [Cap Dimensions] */
wall_thickness = 3; // mm
top_frame_width = 15; // mm - width of frame around top opening

/* [Base Interface] */
// Must match fan_base.scad dimensions
base_size = 310; // mm - matches fan base
lip_inset = 5; // mm - matches fan base lip inset
lip_height = 8; // mm - matches fan base lip height
interface_tolerance = 0.5; // mm - gap for easy fit

/* [Grill Specifications] */
grill_bar_width = 3; // mm
grill_spacing = 20; // mm - space between bars

/* [Calculated Values] */
// Interior dimensions for filters
interior_width = filter_width + filter_tolerance;
interior_depth = filter_depth + filter_tolerance;
interior_height = (filter_height * num_filters) + filter_tolerance;

// Exterior dimensions
exterior_width = interior_width + (2 * wall_thickness);
exterior_depth = interior_depth + (2 * wall_thickness);
cap_height = interior_height + wall_thickness + top_frame_width;

// Interface dimensions (fits over fan base lip)
interface_width = base_size - (2 * lip_inset) + interface_tolerance;
interface_depth = base_size - (2 * lip_inset) + interface_tolerance;
interface_height = lip_height + 2; // Overlap onto lip

module top_grill() {
    // Protective grill over the top opening
    // Bars in X direction
    num_bars_x = floor(interior_width / grill_spacing);
    for (i = [1:num_bars_x-1]) {
        translate([wall_thickness + (i * grill_spacing) - grill_bar_width/2,
                   wall_thickness,
                   cap_height - top_frame_width])
            cube([grill_bar_width, interior_depth, top_frame_width]);
    }

    // Bars in Y direction
    num_bars_y = floor(interior_depth / grill_spacing);
    for (i = [1:num_bars_y-1]) {
        translate([wall_thickness,
                   wall_thickness + (i * grill_spacing) - grill_bar_width/2,
                   cap_height - top_frame_width])
            cube([interior_width, grill_bar_width, top_frame_width]);
    }
}

module filter_support_ledge() {
    // Small ledge inside to support bottom filter
    ledge_width = 5;
    ledge_height = 2;

    // Front ledge
    translate([wall_thickness, wall_thickness, wall_thickness])
        cube([interior_width, ledge_width, ledge_height]);

    // Back ledge
    translate([wall_thickness, exterior_depth - wall_thickness - ledge_width, wall_thickness])
        cube([interior_width, ledge_width, ledge_height]);

    // Left ledge
    translate([wall_thickness, wall_thickness, wall_thickness])
        cube([ledge_width, interior_depth, ledge_height]);

    // Right ledge
    translate([exterior_width - wall_thickness - ledge_width, wall_thickness, wall_thickness])
        cube([ledge_width, interior_depth, ledge_height]);
}

module cap_body() {
    difference() {
        // Main box
        cube([exterior_width, exterior_depth, cap_height]);

        // Hollow interior for filters
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([interior_width, interior_depth, cap_height]);

        // Top opening (with frame)
        translate([wall_thickness + top_frame_width/2,
                   wall_thickness + top_frame_width/2,
                   cap_height - top_frame_width - 1])
            cube([interior_width - top_frame_width,
                  interior_depth - top_frame_width,
                  top_frame_width + 2]);
    }
}

module base_interface() {
    // Skirt that fits over the lip of the fan base
    interface_offset_x = (exterior_width - interface_width) / 2;
    interface_offset_y = (exterior_depth - interface_depth) / 2;

    difference() {
        // Outer skirt
        translate([interface_offset_x - wall_thickness,
                   interface_offset_y - wall_thickness,
                   -interface_height])
            cube([interface_width + 2*wall_thickness,
                  interface_depth + 2*wall_thickness,
                  interface_height + wall_thickness]);

        // Inner cutout (fits over lip)
        translate([interface_offset_x, interface_offset_y, -interface_height - 1])
            cube([interface_width, interface_depth, interface_height + 2]);

        // Remove material that would overlap with main body interior
        translate([wall_thickness, wall_thickness, -1])
            cube([interior_width, interior_depth, wall_thickness + 2]);
    }
}

module filter_cap() {
    union() {
        // Center the cap body
        cap_body();
        filter_support_ledge();
        top_grill();
        base_interface();
    }
}

// Center the cap on the build plate for easier printing
translate([(320 - exterior_width)/2, (350 - exterior_depth)/2, interface_height])
    filter_cap();

// Print dimensions for verification
echo("=== FILTER CAP DIMENSIONS ===");
echo(str("Exterior size: ", exterior_width, " x ", exterior_depth, " mm"));
echo(str("Total height: ", cap_height + interface_height, " mm"));
echo(str("Filter cavity: ", interior_width, " x ", interior_depth, " x ", interior_height, " mm"));
echo(str("Fits filters: ", filter_width, " x ", filter_depth, " x ", filter_height, " mm (x", num_filters, ")"));
echo("");
echo("=== BUILD PLATE CHECK (H2D: 350x320x325) ===");
echo(str("Width: ", exterior_width, " mm (limit 350) - ", exterior_width <= 350 ? "OK" : "TOO BIG"));
echo(str("Depth: ", exterior_depth, " mm (limit 320) - ", exterior_depth <= 320 ? "OK" : "TOO BIG"));
echo(str("Height: ", cap_height + interface_height, " mm (limit 325) - ", (cap_height + interface_height) <= 325 ? "OK" : "TOO BIG"));
