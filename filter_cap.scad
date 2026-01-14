// Film Dryer Filter Cap
// Holds 2x 12x12x1 furnace filters (11.75" x 11.75" x 0.75" actual)
// Filters slide in from the top, rest on support ledges
// Open top with protective grid for air intake
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
frame_height = 15; // mm - height of top frame/grid

/* [Grid Specifications] */
grid_bar_width = 4; // mm - thinner bars
grid_holes_x = 8; // number of holes in X direction
grid_holes_y = 8; // number of holes in Y direction

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
cap_height = total_filter_height + 3 + 5; // ledge + space above filters

// Interface skirt dimensions (fits over fan base lip)
skirt_interior = base_width - (2 * lip_thickness) + interface_gap;
skirt_height = lip_height + 5;

$fn = 32;

// Main frame walls
module frame_walls() {
    difference() {
        // Outer shell
        linear_extrude(cap_height)
            offset(r = 3) offset(r = -3)
                square([exterior_width, exterior_depth], center = true);

        // Inner cutout (hollow)
        translate([0, 0, -1])
            linear_extrude(cap_height + 2)
                square([interior_width - 10, interior_depth - 10], center = true);
    }
}

// Top grid with many smaller holes
module top_grid() {
    grid_z = cap_height - frame_height;

    // Calculate hole sizes based on count
    usable_width = interior_width - 20; // Leave margin
    usable_depth = interior_depth - 20;

    hole_width = (usable_width - (grid_holes_x + 1) * grid_bar_width) / grid_holes_x;
    hole_depth = (usable_depth - (grid_holes_y + 1) * grid_bar_width) / grid_holes_y;

    translate([0, 0, grid_z]) {
        difference() {
            // Solid top frame
            linear_extrude(frame_height)
                offset(r = 3) offset(r = -3)
                    square([exterior_width, exterior_depth], center = true);

            // Cut grid holes
            start_x = -usable_width/2 + grid_bar_width + hole_width/2;
            start_y = -usable_depth/2 + grid_bar_width + hole_depth/2;
            step_x = hole_width + grid_bar_width;
            step_y = hole_depth + grid_bar_width;

            for (ix = [0:grid_holes_x-1]) {
                for (iy = [0:grid_holes_y-1]) {
                    translate([start_x + ix * step_x, start_y + iy * step_y, -1])
                        linear_extrude(frame_height + 2)
                            square([hole_width, hole_depth], center = true);
                }
            }
        }
    }
}

// Bottom skirt that fits over fan base lip
module interface_skirt() {
    skirt_wall = wall_thickness;
    skirt_outer = skirt_interior + (2 * skirt_wall);

    translate([0, 0, -skirt_height]) {
        difference() {
            // Outer skirt
            linear_extrude(skirt_height)
                offset(r = 3) offset(r = -3)
                    square([skirt_outer, skirt_outer], center = true);

            // Inner cutout (slides over lip)
            translate([0, 0, skirt_wall])
                linear_extrude(skirt_height)
                    square([skirt_interior, skirt_interior], center = true);
        }
    }
}

// Filter support ledges at bottom
module filter_ledges() {
    ledge_width = 8;
    ledge_thickness = 3;
    ledge_length = interior_width - 30;

    // Four ledges around perimeter
    for (angle = [0, 90, 180, 270]) {
        rotate([0, 0, angle])
            translate([0, interior_depth/2 - ledge_width/2 - 5, ledge_thickness/2])
                cube([ledge_length, ledge_width, ledge_thickness], center = true);
    }
}

// Complete filter cap
module filter_cap() {
    union() {
        frame_walls();
        top_grid();
        interface_skirt();
        filter_ledges();
    }
}

// Render - position so skirt is above build plate
translate([0, 0, skirt_height])
    filter_cap();

// Debug output
echo("=== FILTER CAP DIMENSIONS ===");
echo(str("Exterior: ", exterior_width, " x ", exterior_depth, " mm"));
echo(str("Interior (filter space): ", interior_width, " x ", interior_depth, " mm"));
echo(str("Cap height: ", cap_height, " mm"));
echo(str("Total height with skirt: ", cap_height + skirt_height, " mm"));
echo(str("Grid: ", grid_holes_x, " x ", grid_holes_y, " holes"));
echo("");
echo("=== BUILD CHECK (H2D: 350x320x325) ===");
echo(str("Width: ", exterior_width, " / 350 mm - ", exterior_width <= 350 ? "OK" : "TOO BIG"));
echo(str("Depth: ", exterior_depth, " / 320 mm - ", exterior_depth <= 320 ? "OK" : "TOO BIG"));
echo(str("Height: ", cap_height + skirt_height, " / 325 mm - ", (cap_height + skirt_height) <= 325 ? "OK" : "TOO BIG"));
