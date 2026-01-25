// Film Dryer Filter Cap - Side Vents Version
// Holds 2x 12x12x1 furnace filters (11.75" x 11.75" x 0.75" actual)
// Solid top with side vent holes for air intake
// Two-tier interior: main cutout below, smaller recessed area with side vents above
// Rounded top and bottom edges
// Designed to fit Bambu Labs H2D (max 350x320x325mm)

/**
 * Coordinate System:
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * Origin: Center of base plate at ground level (XY centered, Z at bottom)
 */

/**
 * ===========================================
 * COMPONENT INDEX
 * ===========================================
 *
 * | Component              | Origin [X,Y,Z]           | Size [W,D,H]                                    | Attaches To       |
 * |------------------------|--------------------------|------------------------------------------------|-------------------|
 * | filter_cap_side_vents  | [0, 0, 0] (XY centered)  | [exterior_width_mm, exterior_depth_mm, total_height_mm] | fan_base top      |
 * | rounded_rect           | N/A (2D helper)          | [w, h] (parameterized)                         | N/A               |
 * | vent_hole_2d           | N/A (2D helper)          | [vent_hole_length_mm, vent_hole_height_mm]     | N/A               |
 * | side_vents_front_back  | (centered on cap)        | Vent holes on Y-normal faces                   | filter_cap        |
 * | side_vents_left_right  | (centered on cap)        | Vent holes on X-normal faces                   | filter_cap        |
 *
 */

// ===========================================
// DIMENSIONS (all values in millimeters)
// ===========================================

// --- Filter Specifications ---
// Actual filter size: 11.75" x 11.75" x 0.75"
filter_width_mm = 298.45;           // Filter width (X dimension)
filter_depth_mm = 298.45;           // Filter depth (Y dimension)
filter_height_mm = 19.05;           // Filter height (0.75 inches)
num_filters = 2;                    // Number of filters stacked vertically
filter_clearance_mm = 1;            // Gap around filters for easy insertion

// --- Frame Dimensions ---
wall_thickness_mm = 5;              // Common wall thickness
frame_height_mm = 15;               // Height of top frame section
top_radius_mm = 2;                  // Radius for top and bottom edge rounding

// --- Upper Recess Specifications ---
upper_recess_inset_mm = 45;         // How much smaller the upper recess is (per side)
extra_recess_height_mm = 10;        // Additional height for the upper recess and cap

// --- Side Vent Specifications ---
vent_hole_height_mm = 15;           // Height of rectangular portion of vent
vent_holes_per_side = 10;           // Number of vent holes per side
vent_hole_radius_mm = 1.5;          // Radius for rounded corners (unused, teardrops instead)

// --- Base Interface (must match fan_base.scad) ---
base_width_mm = 310;                // Fan base width
base_height_mm = 30;                // Fan base plate thickness
lip_height_mm = 25;                 // Must match fan_base lip_height

// ===========================================
// CALCULATED DIMENSIONS
// ===========================================

// Interior dimensions (filter space)
interior_width_mm = filter_width_mm + filter_clearance_mm;
interior_depth_mm = filter_depth_mm + filter_clearance_mm;
total_filter_height_mm = (filter_height_mm * num_filters) + filter_clearance_mm;

// Exterior dimensions
exterior_width_mm = interior_width_mm + (2 * wall_thickness_mm);
exterior_depth_mm = interior_depth_mm + (2 * wall_thickness_mm);

// Height calculations
fan_base_total_height_mm = base_height_mm + lip_height_mm;  // 55mm
internal_height_mm = fan_base_total_height_mm + total_filter_height_mm;
cap_height_mm = internal_height_mm + wall_thickness_mm + extra_recess_height_mm;

// Total height of entire object
total_height_mm = cap_height_mm;

// Z position where frame/upper section starts
grid_z_mm = cap_height_mm - frame_height_mm - extra_recess_height_mm;

// Upper recess dimensions
upper_recess_width_mm = filter_width_mm - upper_recess_inset_mm;
upper_recess_depth_mm = filter_depth_mm - upper_recess_inset_mm;
upper_recess_height_mm = frame_height_mm - wall_thickness_mm + extra_recess_height_mm;

// Vent hole calculations
// Formula: 2 edge buffers + N holes + (N-1) gaps = recess_width
// So: vent_hole_length = (recess_width - (N+1) * wall_thickness) / N
vent_hole_length_mm = (upper_recess_width_mm - (vent_holes_per_side + 1) * wall_thickness_mm) / vent_holes_per_side;

// Side vent positioning - vents positioned with top at top of upper recess
vent_z_center_mm = grid_z_mm + upper_recess_height_mm - vent_hole_height_mm / 2;
// Spacing between hole centers = hole length + gap
vent_spacing_mm = vent_hole_length_mm + wall_thickness_mm;

$fn = 96; // Higher value for smoother curves

// ===========================================
// CONNECTION INTERFACES
// ===========================================

// Bottom center of cap where it sits on fan_base
function cap_bottom_center() = [0, 0, 0];

// Top center of cap (solid surface)
function cap_top_center() = [0, 0, total_height_mm];

// Main interior cavity bottom center
function cap_interior_bottom_center() = [0, 0, 0];

// Upper recess bottom center
function cap_upper_recess_bottom_center() = [0, 0, grid_z_mm];

// Filter stack bottom position
function filter_stack_bottom() = [0, 0, fan_base_total_height_mm];

// ===========================================
// 2D HELPER MODULES
// ===========================================

/**
 * Rounded Rectangle (2D)
 *
 * PURPOSE: Creates a 2D rounded rectangle shape for extrusion
 *
 * PARAMETERS:
 *   w: Width of rectangle
 *   h: Height of rectangle
 *   r: Corner radius
 */
module rounded_rect(w, h, r) {
    offset(r = r) offset(r = -r)
        square([w, h], center = true);
}

/**
 * Teardrop Vent Hole (2D)
 *
 * PURPOSE: Creates a teardrop-shaped vent hole for printability
 *          when cap is printed upside down. Top half is rectangle,
 *          bottom half is 45 degree triangle to point.
 *
 * PARAMETERS:
 *   flip: When true, point is at top instead of bottom
 *
 * BOUNDING BOX:
 *   Size: [vent_hole_length_mm, vent_hole_height_mm]
 */
module vent_hole_2d(flip = false) {
    half_height = vent_hole_height_mm / 2;
    half_width = vent_hole_length_mm / 2;

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

// ===========================================
// VENT HOLE MODULES
// ===========================================

/**
 * Side Vents - Front and Back Walls
 *
 * PURPOSE: Creates vent holes on Y-normal faces (front and back walls)
 *          Vents are oriented with length along X axis, height along Z axis
 *
 * POSITION:
 *   Centered on cap XY, positioned at vent_z_center_mm in Z
 *
 * BOUNDING BOX:
 *   Each vent: [vent_hole_length_mm, vent_depth, vent_hole_height_mm]
 *
 * ALIGNMENT:
 *   X: Distributed evenly across upper_recess_width_mm with wall_thickness_mm margins
 *   Y: Penetrates from exterior wall through to upper recess
 *   Z: Top of vents aligned with top of upper recess
 *
 * CONNECTS TO:
 *   - filter_cap_side_vents: Subtracted from cap body to create ventilation
 */
module side_vents_front_back() {
    // Depth to cut through from exterior to upper recess
    vent_depth = (exterior_depth_mm - upper_recess_depth_mm) / 2 + 2;

    for (side = [-1, 1]) {
        for (i = [0:vent_holes_per_side-1]) {
            // Start with wall_thickness buffer from edge, then vent_spacing between hole centers
            x_pos = -upper_recess_width_mm/2 + wall_thickness_mm + vent_hole_length_mm/2 + i * vent_spacing_mm;
            // Position at exterior wall, cut inward
            y_start = side * (exterior_depth_mm/2 + 1);
            // Flip teardrop for side=-1 so point faces down after rotation
            translate([x_pos, y_start, vent_z_center_mm])
                rotate([side * 90, 0, 0])
                    linear_extrude(vent_depth + 2)
                        vent_hole_2d(flip = (side == -1));
        }
    }
}

/**
 * Side Vents - Left and Right Walls
 *
 * PURPOSE: Creates vent holes on X-normal faces (left and right walls)
 *          Vents are oriented with length along Y axis, height along Z axis
 *
 * POSITION:
 *   Centered on cap XY, positioned at vent_z_center_mm in Z
 *
 * BOUNDING BOX:
 *   Each vent: [vent_depth, vent_hole_length_mm, vent_hole_height_mm]
 *
 * ALIGNMENT:
 *   X: Penetrates from exterior wall through to upper recess
 *   Y: Distributed evenly across upper_recess_depth_mm with wall_thickness_mm margins
 *   Z: Top of vents aligned with top of upper recess
 *
 * CONNECTS TO:
 *   - filter_cap_side_vents: Subtracted from cap body to create ventilation
 */
module side_vents_left_right() {
    // Depth to cut through from exterior to upper recess
    vent_depth = (exterior_width_mm - upper_recess_width_mm) / 2 + 2;

    for (side = [-1, 1]) {
        for (i = [0:vent_holes_per_side-1]) {
            // Start with wall_thickness buffer from edge, then vent_spacing between hole centers
            y_pos = -upper_recess_depth_mm/2 + wall_thickness_mm + vent_hole_length_mm/2 + i * vent_spacing_mm;
            // Position at exterior wall, cut inward
            x_start = side * (exterior_width_mm/2 + 1);
            // Flip teardrop for side=1 so point faces down after rotation
            translate([x_start, y_pos, vent_z_center_mm])
                rotate([0, side * -90, 0])
                    rotate([0, 0, 90])  // Rotate 2D shape so length runs along Y
                        linear_extrude(vent_depth + 2)
                            vent_hole_2d(flip = (side == 1));
        }
    }
}

// ===========================================
// MAIN COMPONENT MODULE
// ===========================================

/**
 * Filter Cap with Side Vents
 *
 * PURPOSE: Main cap body that sits atop the fan base, holds filters,
 *          and provides side ventilation through teardrop-shaped holes.
 *
 * POSITION:
 *   Origin: [0, 0, 0] (XY centered, Z at bottom)
 *
 * BOUNDING BOX:
 *   Min: [-exterior_width_mm/2, -exterior_depth_mm/2, 0]
 *   Max: [exterior_width_mm/2, exterior_depth_mm/2, total_height_mm]
 *   Size: [exterior_width_mm, exterior_depth_mm, total_height_mm]
 *         Approximately: [309.45, 309.45, 109.15] mm
 *
 * ALIGNMENT:
 *   X: Centered (symmetric about YZ plane)
 *   Y: Centered (symmetric about XZ plane)
 *   Z: Bottom at Z=0, sits on top of fan_base
 *
 * CONNECTS TO:
 *   - fan_base: Bottom of cap sits on top of fan_base lip
 *   - filters: Main interior cavity holds 2 stacked filters
 */
module filter_cap_side_vents() {
    difference() {
        // Main cap body with rounded top and bottom edges
        // Translate up so minkowski sphere creates rounded bottom at z=0
        translate([0, 0, top_radius_mm])
            minkowski() {
                linear_extrude(cap_height_mm - 2*top_radius_mm)
                    rounded_rect(exterior_width_mm - 2*top_radius_mm, exterior_depth_mm - 2*top_radius_mm, 3);
                sphere(r = top_radius_mm);
            }

        // Main interior cutout - stops at grid_z
        translate([0, 0, -1])
            linear_extrude(grid_z_mm + 2)
                square([interior_width_mm, interior_depth_mm], center = true);

        // Upper recess - smaller cutout above the main interior
        translate([0, 0, grid_z_mm])
            linear_extrude(upper_recess_height_mm + 1)
                square([upper_recess_width_mm, upper_recess_depth_mm], center = true);

        // Side vent holes on all four sides (cut into upper recess walls)
        side_vents_front_back();
        side_vents_left_right();
    }
}

// ===========================================
// DEBUG / VISUALIZATION
// ===========================================

// Render coordinate axes at origin (length = 50mm)
module debug_axes(length = 50) {
    color("red")   translate([0,0,0]) cylinder(h=length, r=1, $fn=16);  // Z (up)
    color("green") rotate([0,90,0]) cylinder(h=length, r=1, $fn=16);    // X (right)
    color("blue")  rotate([-90,0,0]) cylinder(h=length, r=1, $fn=16);   // Y (back)
}

// Show bounding box for filter_cap_side_vents (transparent)
module debug_bounds() {
    color("yellow", 0.2)
        translate([-exterior_width_mm/2, -exterior_depth_mm/2, 0])
            cube([exterior_width_mm, exterior_depth_mm, total_height_mm]);
}

// Color-coded assembly for visual debugging
module assembly_colored() {
    color("salmon") filter_cap_side_vents();
}

// Exploded view - shows cap elevated (would show fan_base below if imported)
module assembly_exploded(separation = 30) {
    translate([0, 0, separation]) filter_cap_side_vents();
    // fan_base would be at [0, 0, 0] if imported
}

// ===========================================
// MAIN ASSEMBLY
// ===========================================

/**
 * Main Assembly
 *
 * Renders the filter cap with side vents.
 * Use debug_axes(), debug_bounds(), assembly_colored(),
 * or assembly_exploded() for debugging.
 */
module assembly() {
    filter_cap_side_vents();
}

// Default render
color([1.0, 0.6, 0.6]) // Light red
assembly();

// ===========================================
// DEBUG OUTPUT
// ===========================================

echo("=== FILTER CAP (SIDE VENTS) DIMENSIONS ===");
echo(str("Exterior: ", exterior_width_mm, " x ", exterior_depth_mm, " mm"));
echo(str("Main interior cutout: ", interior_width_mm, " x ", interior_depth_mm, " mm"));
echo(str("Upper recess: ", upper_recess_width_mm, " x ", upper_recess_depth_mm, " x ", upper_recess_height_mm, " mm"));
echo(str("Internal height: ", internal_height_mm, " mm (fan base ", fan_base_total_height_mm, " + filters ", total_filter_height_mm, ")"));
echo(str("Total height: ", total_height_mm, " mm"));
echo(str("Edge radius: ", top_radius_mm, " mm (top and bottom)"));
echo(str("Side vents: ", vent_holes_per_side, " holes per side x 4 sides"));
echo(str("Vent teardrop: ", vent_hole_length_mm, " x ", vent_hole_height_mm, " mm (pointed, self-supporting)"));
echo(str("Total vent holes: ", vent_holes_per_side * 4));
echo("");
echo("=== BUILD CHECK (H2D: 350x320x325) ===");
echo(str("Width: ", exterior_width_mm, " / 350 mm - ", exterior_width_mm <= 350 ? "OK" : "TOO BIG"));
echo(str("Depth: ", exterior_depth_mm, " / 320 mm - ", exterior_depth_mm <= 320 ? "OK" : "TOO BIG"));
echo(str("Height: ", total_height_mm, " / 325 mm - ", total_height_mm <= 325 ? "OK" : "TOO BIG"));
