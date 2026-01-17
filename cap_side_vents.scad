// Film Dryer Filter Cap - Side Vents Version
// Holds 2x 12x12x1 furnace filters (11.75" x 11.75" x 0.75" actual)
// Solid top with side vent holes for air intake
// Two-tier interior: main cutout below, smaller recessed area with side vents above
// Rounded top and bottom edges
// Designed to fit Bambu Labs H2D (max 350x320x325mm)

/* [Filter Specifications] */
// Actual filter size: 11.75" x 11.75" x 0.75"
filter_width = 298.45; // mm
filter_depth = 298.45; // mm
filter_height = 19.05; // mm (0.75 inches)
num_filters = 2; // stacked vertically
filter_clearance = 1; // mm - gap around filters for easy insertion

/* [Frame Dimensions] */
wall_thickness = 5; // mm
frame_height = 15; // mm - height of top frame section
top_radius = 2; // mm - radius for top edge rounding

/* [Upper Recess Specifications] */
upper_recess_inset = 45; // mm - how much smaller the upper recess is (per side)
extra_recess_height = 10; // mm - additional height for the upper recess and cap

/* [Side Vent Specifications] */
vent_hole_height = 15; // mm - height of rectangular portion of vent
vent_holes_per_side = 10; // number of vent holes per side
vent_hole_radius = 1.5; // mm - radius for rounded corners

/* [Base Interface] */
// Must match fan_base.scad
base_width = 310; // mm
base_height = 30; // mm - fan base plate thickness
lip_height = 25; // mm - must match fan_base lip_height

/* [Calculated] */
interior_width = filter_width + filter_clearance;
interior_depth = filter_depth + filter_clearance;
total_filter_height = (filter_height * num_filters) + filter_clearance;

exterior_width = interior_width + (2 * wall_thickness);
exterior_depth = interior_depth + (2 * wall_thickness);

// Internal height = fan base total height + two filters
fan_base_total_height = base_height + lip_height; // 55mm
internal_height = fan_base_total_height + total_filter_height;
cap_height = internal_height + wall_thickness + extra_recess_height; // add top wall thickness + extra height

// Total height of entire object
total_height = cap_height;

// Z position where frame/upper section starts (same as grid_z in original)
grid_z = cap_height - frame_height - extra_recess_height;

// Upper recess dimensions
upper_recess_width = filter_width - upper_recess_inset;
upper_recess_depth = filter_depth - upper_recess_inset;
upper_recess_height = frame_height - wall_thickness + extra_recess_height;

// Vent hole length calculated from recess width, number of holes, and wall_thickness margins
// wall_thickness buffer on both ends, then wall_thickness gaps between holes
// Formula: 2 edge buffers + N holes + (N-1) gaps = recess_width
// So: vent_hole_length = (recess_width - (N+1) * wall_thickness) / N
vent_hole_length = (upper_recess_width - (vent_holes_per_side + 1) * wall_thickness) / vent_holes_per_side;

// Side vent calculations - vents positioned with top at top of upper recess
vent_z_center = grid_z + upper_recess_height - vent_hole_height / 2;
// Spacing between hole centers = hole length + gap
vent_spacing = vent_hole_length + wall_thickness;

$fn = 96; // Higher value for smoother curves

// Rounded rectangle module for 2D shape
module rounded_rect(w, h, r) {
    offset(r = r) offset(r = -r)
        square([w, h], center = true);
}

// Teardrop-shaped vent hole for printability when cap is printed upside down
// Top half: rectangle, Bottom half: 45° triangle to point
// Total height = vent_hole_height, width = vent_hole_length
// flip parameter: when true, point is at top instead of bottom (for sides where rotation flips it)
module vent_hole_2d(flip = false) {
    half_height = vent_hole_height / 2;
    half_width = vent_hole_length / 2;

    if (flip) {
        // Point at top, rectangle at bottom
        polygon([
            [-half_width, -half_height],              // bottom left (rect)
            [half_width, -half_height],               // bottom right (rect)
            [half_width, 0],                          // middle right (rect/triangle junction)
            [0, half_height],                         // top point
            [-half_width, 0]                          // middle left (rect/triangle junction)
        ]);
    } else {
        // Point at bottom, rectangle at top (normal orientation)
        polygon([
            [-half_width, half_height],               // top left (rect)
            [half_width, half_height],                // top right (rect)
            [half_width, 0],                          // middle right (rect/triangle junction)
            [0, -half_height],                        // bottom point
            [-half_width, 0]                          // middle left (rect/triangle junction)
        ]);
    }
}

// Side vent holes - front and back walls (Y-normal faces)
// Vents are oriented with length along X axis, height along Z axis
module side_vents_front_back() {
    // Depth to cut through from exterior to upper recess
    vent_depth = (exterior_depth - upper_recess_depth) / 2 + 2;

    for (side = [-1, 1]) {
        for (i = [0:vent_holes_per_side-1]) {
            // Start with wall_thickness buffer from edge, then vent_spacing between hole centers
            x_pos = -upper_recess_width/2 + wall_thickness + vent_hole_length/2 + i * vent_spacing;
            // Position at exterior wall, cut inward
            y_start = side * (exterior_depth/2 + 1);
            // Flip teardrop for side=-1 so point faces down after rotation
            translate([x_pos, y_start, vent_z_center])
                rotate([side * 90, 0, 0])
                    linear_extrude(vent_depth + 2)
                        vent_hole_2d(flip = (side == -1));
        }
    }
}

// Side vent holes - left and right walls (X-normal faces)
// Vents are oriented with length along Y axis, height along Z axis
module side_vents_left_right() {
    // Depth to cut through from exterior to upper recess
    vent_depth = (exterior_width - upper_recess_width) / 2 + 2;

    for (side = [-1, 1]) {
        for (i = [0:vent_holes_per_side-1]) {
            // Start with wall_thickness buffer from edge, then vent_spacing between hole centers
            y_pos = -upper_recess_depth/2 + wall_thickness + vent_hole_length/2 + i * vent_spacing;
            // Position at exterior wall, cut inward
            x_start = side * (exterior_width/2 + 1);
            // Flip teardrop for side=1 so point faces down after rotation
            translate([x_start, y_pos, vent_z_center])
                rotate([0, side * -90, 0])
                    rotate([0, 0, 90])  // Rotate 2D shape so length runs along Y
                        linear_extrude(vent_depth + 2)
                            vent_hole_2d(flip = (side == 1));
        }
    }
}

// Complete filter cap with side vents
module filter_cap_side_vents() {
    difference() {
        // Main cap body with rounded top and bottom edges
        // Translate up so minkowski sphere creates rounded bottom at z=0
        translate([0, 0, top_radius])
            minkowski() {
                linear_extrude(cap_height - 2*top_radius)
                    rounded_rect(exterior_width - 2*top_radius, exterior_depth - 2*top_radius, 3);
                sphere(r = top_radius);
            }

        // Main interior cutout - same as original, stops at grid_z
        translate([0, 0, -1])
            linear_extrude(grid_z + 2)
                square([interior_width, interior_depth], center = true);

        // Upper recess - smaller cutout above the main interior
        translate([0, 0, grid_z])
            linear_extrude(upper_recess_height + 1)
                square([upper_recess_width, upper_recess_depth], center = true);

        // Side vent holes on all four sides (cut into upper recess walls)
        side_vents_front_back();
        side_vents_left_right();
    }
}

// Render
color([1.0, 0.6, 0.6]) // Light red
filter_cap_side_vents();

// Debug output
echo("=== FILTER CAP (SIDE VENTS) DIMENSIONS ===");
echo(str("Exterior: ", exterior_width, " x ", exterior_depth, " mm"));
echo(str("Main interior cutout: ", interior_width, " x ", interior_depth, " mm"));
echo(str("Upper recess: ", upper_recess_width, " x ", upper_recess_depth, " x ", upper_recess_height, " mm"));
echo(str("Internal height: ", internal_height, " mm (fan base ", fan_base_total_height, " + filters ", total_filter_height, ")"));
echo(str("Total height: ", total_height, " mm"));
echo(str("Edge radius: ", top_radius, " mm (top and bottom)"));
echo(str("Side vents: ", vent_holes_per_side, " holes per side x 4 sides"));
echo(str("Vent teardrop: ", vent_hole_length, " x ", vent_hole_height, " mm (pointed, self-supporting)"));
echo(str("Total vent holes: ", vent_holes_per_side * 4));
echo("");
echo("=== BUILD CHECK (H2D: 350x320x325) ===");
echo(str("Width: ", exterior_width, " / 350 mm - ", exterior_width <= 350 ? "OK" : "TOO BIG"));
echo(str("Depth: ", exterior_depth, " / 320 mm - ", exterior_depth <= 320 ? "OK" : "TOO BIG"));
echo(str("Height: ", total_height, " / 325 mm - ", total_height <= 325 ? "OK" : "TOO BIG"));
