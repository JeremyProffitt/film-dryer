// Film Dryer Filter Cap
// Holds 2x 12x12x1 furnace filters (11.75" x 11.75" x 0.75" actual)
// Open top with protective grid for air intake
// Interior cutout goes all the way through
// Rounded top edges with 4mm radius
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
top_radius = 4; // mm - radius for top edge rounding

/* [Grid Specifications] */
grid_bar_width = 4; // mm - thinner bars
grid_holes_x = 8; // number of holes in X direction
grid_holes_y = 8; // number of holes in Y direction
grid_hole_radius = 4; // mm - radius for grid hole corners

/* [Base Interface] */
// Must match fan_base.scad
base_width = 310; // mm
base_height = 30; // mm - fan base plate thickness
lip_height = 10; // mm
lip_thickness = 4; // mm
interface_gap = 0.5; // mm - clearance for fit

/* [Calculated] */
interior_width = filter_width + filter_clearance;
interior_depth = filter_depth + filter_clearance;
total_filter_height = (filter_height * num_filters) + filter_clearance;

exterior_width = interior_width + (2 * wall_thickness);
exterior_depth = interior_depth + (2 * wall_thickness);

// Cap height = 2 filters + fan base height + clearance
fan_base_total_height = base_height + lip_height; // 40mm
cap_height = total_filter_height + fan_base_total_height + 5; // filters + base + clearance

// Interface skirt dimensions (fits over fan base lip)
skirt_interior = base_width - (2 * lip_thickness) + interface_gap;
skirt_height = lip_height + 5;
skirt_wall = wall_thickness;
skirt_outer = skirt_interior + (2 * skirt_wall);

// Total height of entire object
total_height = cap_height + skirt_height;

// Grid calculations
usable_width = interior_width - 20;
usable_depth = interior_depth - 20;
hole_width = (usable_width - (grid_holes_x + 1) * grid_bar_width) / grid_holes_x;
hole_depth = (usable_depth - (grid_holes_y + 1) * grid_bar_width) / grid_holes_y;

// Z position where grid starts
grid_z = skirt_height + cap_height - frame_height;

$fn = 32;

// Rounded rectangle module for 2D shape
module rounded_rect(w, h, r) {
    offset(r = r) offset(r = -r)
        square([w, h], center = true);
}

// Grid hole cutouts with rounded corners
module grid_holes() {
    start_x = -usable_width/2 + grid_bar_width + hole_width/2;
    start_y = -usable_depth/2 + grid_bar_width + hole_depth/2;
    step_x = hole_width + grid_bar_width;
    step_y = hole_depth + grid_bar_width;

    for (ix = [0:grid_holes_x-1]) {
        for (iy = [0:grid_holes_y-1]) {
            translate([start_x + ix * step_x, start_y + iy * step_y, grid_z - 1])
                linear_extrude(frame_height + top_radius + 10)
                    offset(r = grid_hole_radius) offset(r = -grid_hole_radius)
                        square([hole_width, hole_depth], center = true);
        }
    }
}

// Complete filter cap with rounded top edges
module filter_cap() {
    difference() {
        // Main solid body
        minkowski() {
            union() {
                // Main cap body - reduced size for minkowski
                translate([0, 0, skirt_height])
                    linear_extrude(cap_height - top_radius)
                        rounded_rect(exterior_width - 2*top_radius, exterior_depth - 2*top_radius, 3);

                // Skirt at bottom - no rounding needed
                linear_extrude(skirt_height)
                    rounded_rect(skirt_outer, skirt_outer, 3);
            }

            // Add rounding sphere - but only affects top due to positioning
            sphere(r = top_radius);
        }

        // Cut off the bottom expansion from minkowski
        translate([0, 0, -top_radius - 1])
            cube([exterior_width + 20, exterior_depth + 20, top_radius * 2 + 2], center = true);

        // Cut off side expansion from minkowski on skirt
        difference() {
            translate([0, 0, skirt_height/2])
                cube([exterior_width + 20, exterior_depth + 20, skirt_height + 2], center = true);
            translate([0, 0, skirt_height/2])
                cube([skirt_outer, skirt_outer, skirt_height + 4], center = true);
        }

        // Interior cutout - stops below the grid section
        translate([0, 0, -1])
            linear_extrude(grid_z + 2)
                square([interior_width - 10, interior_depth - 10], center = true);

        // Grid holes in top section
        grid_holes();
    }
}

// Render
filter_cap();

// Debug output
echo("=== FILTER CAP DIMENSIONS ===");
echo(str("Exterior: ", exterior_width, " x ", exterior_depth, " mm"));
echo(str("Interior cutout: ", interior_width - 10, " x ", interior_depth - 10, " mm"));
echo(str("Cap height: ", cap_height, " mm"));
echo(str("Skirt height: ", skirt_height, " mm"));
echo(str("Total height: ", total_height, " mm"));
echo(str("Top edge radius: ", top_radius, " mm"));
echo(str("Grid: ", grid_holes_x, " x ", grid_holes_y, " holes"));
echo("");
echo("=== BUILD CHECK (H2D: 350x320x325) ===");
echo(str("Width: ", exterior_width, " / 350 mm - ", exterior_width <= 350 ? "OK" : "TOO BIG"));
echo(str("Depth: ", exterior_depth, " / 320 mm - ", exterior_depth <= 320 ? "OK" : "TOO BIG"));
echo(str("Height: ", total_height, " / 325 mm - ", total_height <= 325 ? "OK" : "TOO BIG"));
