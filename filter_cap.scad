// Film Dryer Filter Cap
// Holds 2x 12x12x1 furnace filters (11.75" x 11.75" x 0.75" actual)
// Filters slide in from the top, rest on support ledges
// Open top with protective frame for air intake
// Designed to fit Bambu Labs H2D (max 350x320x325mm)

/* [Filter Specifications] */
// Actual filter size: 11.75" x 11.75" x 0.75"
filter_width = 298.45; // mm
filter_depth = 298.45; // mm
filter_height = 19.05; // mm (0.75 inches)
num_filters = 2; // stacked vertically
filter_clearance = 2; // mm - gap around filters for easy insertion

/* [Frame Dimensions] */
wall_thickness = 5; // mm
frame_bar_width = 15; // mm - width of top frame bars
corner_post_size = 20; // mm - size of corner structural posts

/* [Support Ledges] */
ledge_width = 8; // mm - how far ledge extends into frame
ledge_thickness = 3; // mm

/* [Base Interface] */
// Must match fan_base.scad
base_width = 310; // mm
lip_height = 10; // mm
lip_thickness = 4; // mm
interface_gap = 0.5; // mm - clearance for fit

/* [Calculated] */
interior_width = filter_width + filter_clearance;
interior_depth = filter_depth + filter_clearance;
total_filter_height = (filter_height * num_filters) + filter_clearance;

exterior_width = interior_width + (2 * wall_thickness);
exterior_depth = interior_depth + (2 * wall_thickness);
cap_height = total_filter_height + ledge_thickness + 5; // 5mm above filters

// Interface skirt dimensions (fits over fan base lip)
skirt_interior = base_width - (2 * lip_thickness) + interface_gap;
skirt_height = lip_height + 5;

module corner_post(height) {
    cube([corner_post_size, corner_post_size, height]);
}

// Four corner posts
module corner_posts() {
    // Front-left
    translate([-exterior_width/2, -exterior_depth/2, 0])
        corner_post(cap_height);

    // Front-right
    translate([exterior_width/2 - corner_post_size, -exterior_depth/2, 0])
        corner_post(cap_height);

    // Back-left
    translate([-exterior_width/2, exterior_depth/2 - corner_post_size, 0])
        corner_post(cap_height);

    // Back-right
    translate([exterior_width/2 - corner_post_size, exterior_depth/2 - corner_post_size, 0])
        corner_post(cap_height);
}

// Walls between corner posts
module side_walls() {
    wall_length = exterior_width - (2 * corner_post_size);

    // Front wall
    translate([-wall_length/2, -exterior_depth/2, 0])
        cube([wall_length, wall_thickness, cap_height]);

    // Back wall
    translate([-wall_length/2, exterior_depth/2 - wall_thickness, 0])
        cube([wall_length, wall_thickness, cap_height]);

    // Left wall
    translate([-exterior_width/2, -wall_length/2, 0])
        cube([wall_thickness, wall_length, cap_height]);

    // Right wall
    translate([exterior_width/2 - wall_thickness, -wall_length/2, 0])
        cube([wall_thickness, wall_length, cap_height]);
}

// Filter support ledges (filters rest on these)
module filter_ledges() {
    ledge_length = interior_width - 20; // Leave gaps at corners

    // Bottom ledge for first filter (at bottom of interior)
    z_bottom = ledge_thickness;

    // Front ledge
    translate([-ledge_length/2, -interior_depth/2, 0])
        cube([ledge_length, ledge_width, z_bottom]);

    // Back ledge
    translate([-ledge_length/2, interior_depth/2 - ledge_width, 0])
        cube([ledge_length, ledge_width, z_bottom]);

    // Left ledge
    translate([-interior_width/2, -ledge_length/2, 0])
        cube([ledge_width, ledge_length, z_bottom]);

    // Right ledge
    translate([interior_width/2 - ledge_width, -ledge_length/2, 0])
        cube([ledge_width, ledge_length, z_bottom]);
}

// Top frame (protective bars across the open top)
module top_frame() {
    z_top = cap_height - frame_bar_width;

    // Perimeter frame
    difference() {
        translate([0, 0, z_top + frame_bar_width/2])
            cube([exterior_width, exterior_depth, frame_bar_width], center = true);

        translate([0, 0, z_top + frame_bar_width/2])
            cube([interior_width - 20, interior_depth - 20, frame_bar_width + 2], center = true);
    }

    // Cross bars for support (X direction)
    num_bars = 3;
    bar_spacing = interior_width / (num_bars + 1);
    for (i = [1:num_bars]) {
        translate([-interior_width/2 + (i * bar_spacing) - frame_bar_width/2,
                   -interior_depth/2 + corner_post_size,
                   z_top])
            cube([frame_bar_width, interior_depth - (2 * corner_post_size) + (2 * wall_thickness), frame_bar_width]);
    }

    // Cross bars (Y direction)
    for (i = [1:num_bars]) {
        translate([-interior_depth/2 + corner_post_size,
                   -interior_depth/2 + (i * bar_spacing) - frame_bar_width/2,
                   z_top])
            cube([interior_width - (2 * corner_post_size) + (2 * wall_thickness), frame_bar_width, frame_bar_width]);
    }
}

// Skirt that fits over the fan base lip
module interface_skirt() {
    skirt_wall = wall_thickness;
    skirt_outer = skirt_interior + (2 * skirt_wall);

    translate([0, 0, -skirt_height])
        difference() {
            // Outer skirt
            cube([skirt_outer, skirt_outer, skirt_height], center = true);

            // Inner cutout (slides over lip)
            translate([0, 0, skirt_wall])
                cube([skirt_interior, skirt_interior, skirt_height], center = true);
        }

    // Move skirt down so cap sits flush
    translate([0, 0, -skirt_height/2]);
}

// Complete filter cap
module filter_cap() {
    union() {
        corner_posts();
        side_walls();
        filter_ledges();
        top_frame();

        // Interface skirt (positioned at bottom)
        translate([0, 0, 0])
            interface_skirt();
    }
}

// Render - lift up so skirt is visible
translate([0, 0, skirt_height])
    filter_cap();

// Debug output
echo("=== FILTER CAP DIMENSIONS ===");
echo(str("Exterior: ", exterior_width, " x ", exterior_depth, " mm"));
echo(str("Interior (filter space): ", interior_width, " x ", interior_depth, " mm"));
echo(str("Cap height: ", cap_height, " mm"));
echo(str("Total height with skirt: ", cap_height + skirt_height, " mm"));
echo(str("Filter cavity height: ", total_filter_height, " mm"));
echo("");
echo("=== BUILD CHECK (H2D: 350x320x325) ===");
echo(str("Width: ", exterior_width, " / 350 mm - ", exterior_width <= 350 ? "OK" : "TOO BIG"));
echo(str("Depth: ", exterior_depth, " / 320 mm - ", exterior_depth <= 320 ? "OK" : "TOO BIG"));
echo(str("Height: ", cap_height + skirt_height, " / 325 mm - ", (cap_height + skirt_height) <= 325 ? "OK" : "TOO BIG"));
