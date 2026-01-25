// Film Dryer Filter Cap
// Holds 2x 12x12x1 furnace filters (11.75" x 11.75" x 0.75" actual)
// Open top with protective grid for air intake
// Interior cutout goes all the way through
// Rounded top and bottom edges
// Designed to fit Bambu Labs H2D (max 350x320x325mm)

/**
 * Coordinate System:
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * Origin: Center of base (centered in X/Y), at ground level (Z=0)
 */

/**
 * ===========================================
 * COMPONENT INDEX
 * ===========================================
 *
 * | Component        | Origin [X,Y,Z]              | Size [W,D,H]                              | Attaches To           |
 * |------------------|-----------------------------|-------------------------------------------|-----------------------|
 * | rounded_rect     | (2D, centered)              | [w, h] (parametric)                       | (helper module)       |
 * | grid_holes       | [0, 0, grid_z_mm]           | [usable_width_mm, usable_depth_mm, frame] | filter_cap interior   |
 * | filter_cap       | [0, 0, 0] (centered X/Y)    | [exterior_width_mm, exterior_depth_mm, total_height_mm] | fan_base top |
 *
 */

// ===========================================
// DIMENSIONS (all values in millimeters)
// ===========================================

// --- Filter Specifications ---
// Actual filter size: 11.75" x 11.75" x 0.75"
filter_width_mm = 298.45;      // X dimension of filter
filter_depth_mm = 298.45;      // Y dimension of filter
filter_height_mm = 19.05;      // Z dimension (0.75 inches)
num_filters = 2;               // stacked vertically
filter_clearance_mm = 1;       // gap around filters for easy insertion

// --- Frame Dimensions ---
wall_thickness_mm = 5;         // wall thickness throughout
frame_height_mm = 15;          // height of top frame/grid
top_radius_mm = 2;             // radius for top and bottom edge rounding

// --- Grid Specifications ---
grid_bar_width_mm = 3;         // width of grid bars
grid_holes_x = 12;             // number of holes in X direction
grid_holes_y = 12;             // number of holes in Y direction
grid_hole_radius_mm = 2;       // radius for grid hole corners

// --- Base Interface (must match fan_base.scad) ---
base_width_mm = 310;           // width of fan base
base_height_mm = 30;           // fan base plate thickness
lip_height_mm = 25;            // must match fan_base lip_height

// --- Calculated Dimensions ---
interior_width_mm = filter_width_mm + filter_clearance_mm;
interior_depth_mm = filter_depth_mm + filter_clearance_mm;
total_filter_height_mm = (filter_height_mm * num_filters) + filter_clearance_mm;

exterior_width_mm = interior_width_mm + (2 * wall_thickness_mm);
exterior_depth_mm = interior_depth_mm + (2 * wall_thickness_mm);

// Internal height = fan base total height + two filters
fan_base_total_height_mm = base_height_mm + lip_height_mm; // 55mm
internal_height_mm = fan_base_total_height_mm + total_filter_height_mm;
cap_height_mm = internal_height_mm + wall_thickness_mm; // add top wall thickness

// Total height of entire object
total_height_mm = cap_height_mm;

// Grid calculations
usable_width_mm = interior_width_mm - 20;
usable_depth_mm = interior_depth_mm - 20;
hole_width_mm = (usable_width_mm - (grid_holes_x + 1) * grid_bar_width_mm) / grid_holes_x;
hole_depth_mm = (usable_depth_mm - (grid_holes_y + 1) * grid_bar_width_mm) / grid_holes_y;

// Z position where grid starts
grid_z_mm = cap_height_mm - frame_height_mm;

$fn = 96; // Higher value for smoother curves

// ===========================================
// CONNECTION INTERFACES
// ===========================================

// Bottom opening center point (where cap sits on fan_base)
function filter_cap_bottom_center() = [0, 0, 0];

// Top surface center point
function filter_cap_top_center() = [0, 0, total_height_mm];

// Interior opening dimensions for filter insertion
function filter_cap_interior_opening() = [interior_width_mm, interior_depth_mm];

// Grid surface Z position
function filter_cap_grid_z() = grid_z_mm;

// ===========================================
// MODULES
// ===========================================

/**
 * Rounded Rectangle (2D Helper)
 *
 * POSITION:
 *   Origin: Center of rectangle
 *
 * BOUNDING BOX:
 *   Min: [-w/2, -h/2]
 *   Max: [w/2, h/2]
 *   Size: [w, h]
 *
 * ALIGNMENT:
 *   Centered in X and Y
 *
 * CONNECTS TO:
 *   - Used by filter_cap for exterior profile
 */
module rounded_rect(w, h, r) {
    offset(r = r) offset(r = -r)
        square([w, h], center = true);
}

/**
 * Grid Holes Cutouts
 *
 * Creates the grid pattern of holes in the top of the cap.
 *
 * POSITION:
 *   Origin: [0, 0, grid_z_mm] (centered in X/Y, at grid start Z)
 *
 * BOUNDING BOX:
 *   Min: [-usable_width_mm/2, -usable_depth_mm/2, grid_z_mm - 1]
 *   Max: [usable_width_mm/2, usable_depth_mm/2, cap_height_mm + top_radius_mm + 9]
 *   Size: [usable_width_mm, usable_depth_mm, frame_height_mm + top_radius_mm + 10]
 *
 * ALIGNMENT:
 *   X: Centered on cap
 *   Y: Centered on cap
 *   Z: Starts at grid_z_mm (below top surface)
 *
 * CONNECTS TO:
 *   - filter_cap: subtracted from top section to create ventilation grid
 */
module grid_holes() {
    start_x = -usable_width_mm/2 + grid_bar_width_mm + hole_width_mm/2;
    start_y = -usable_depth_mm/2 + grid_bar_width_mm + hole_depth_mm/2;
    step_x = hole_width_mm + grid_bar_width_mm;
    step_y = hole_depth_mm + grid_bar_width_mm;

    for (ix = [0:grid_holes_x-1]) {
        for (iy = [0:grid_holes_y-1]) {
            translate([start_x + ix * step_x, start_y + iy * step_y, grid_z_mm - 1])
                linear_extrude(frame_height_mm + top_radius_mm + 10)
                    offset(r = grid_hole_radius_mm) offset(r = -grid_hole_radius_mm)
                        square([hole_width_mm, hole_depth_mm], center = true);
        }
    }
}

/**
 * Filter Cap
 *
 * Main component - a hollow cap with rounded edges and ventilation grid on top.
 * Open bottom for mounting on fan_base, open interior for filter insertion.
 *
 * POSITION:
 *   Origin: [0, 0, 0] (centered in X/Y, bottom at Z=0)
 *
 * BOUNDING BOX:
 *   Min: [-exterior_width_mm/2, -exterior_depth_mm/2, 0]
 *   Max: [exterior_width_mm/2, exterior_depth_mm/2, total_height_mm]
 *   Size: [exterior_width_mm, exterior_depth_mm, total_height_mm]
 *
 * ALIGNMENT:
 *   X: Centered (symmetric about X=0)
 *   Y: Centered (symmetric about Y=0)
 *   Z: Bottom surface at Z=0, top at Z=total_height_mm
 *
 * CONNECTS TO:
 *   - fan_base: bottom opening fits over fan_base top lip
 */
module filter_cap() {
    difference() {
        // Main cap body with rounded top and bottom edges
        // Translate up so minkowski sphere creates rounded bottom at z=0
        translate([0, 0, top_radius_mm])
            minkowski() {
                linear_extrude(cap_height_mm - 2*top_radius_mm)
                    rounded_rect(exterior_width_mm - 2*top_radius_mm, exterior_depth_mm - 2*top_radius_mm, 3);
                sphere(r = top_radius_mm);
            }

        // Interior cutout - goes all the way through bottom, stops below grid
        // Must be full interior size to fit filters
        translate([0, 0, -1])
            linear_extrude(grid_z_mm + 2)
                square([interior_width_mm, interior_depth_mm], center = true);

        // Grid holes in top section
        grid_holes();
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

// Show bounding box for a component (transparent)
module debug_bounds(min_pt, max_pt) {
    size = [max_pt[0] - min_pt[0], max_pt[1] - min_pt[1], max_pt[2] - min_pt[2]];
    color("yellow", 0.2)
        translate(min_pt)
            cube(size);
}

// Show bounding box for filter_cap
module debug_filter_cap_bounds() {
    debug_bounds(
        [-exterior_width_mm/2, -exterior_depth_mm/2, 0],
        [exterior_width_mm/2, exterior_depth_mm/2, total_height_mm]
    );
}

// Color-coded assembly for visual debugging
module assembly_colored() {
    color([1.0, 0.6, 0.6]) filter_cap();  // Light red
}

// Exploded view - shows filter_cap lifted (useful when combined with fan_base)
module assembly_exploded(separation = 30) {
    translate([0, 0, separation]) filter_cap();
}

// ===========================================
// MAIN ASSEMBLY
// ===========================================

/**
 * Main Assembly
 *
 * Renders the filter cap in its final position.
 * Use assembly_colored() or assembly_exploded() for debugging.
 * Use debug_axes() to visualize coordinate system.
 * Use debug_filter_cap_bounds() to visualize bounding box.
 */
module assembly() {
    filter_cap();
}

// Default render
color([1.0, 0.6, 0.6]) // Light red
assembly();

// Uncomment for debugging:
// debug_axes();
// debug_filter_cap_bounds();
// assembly_colored();
// assembly_exploded();

// ===========================================
// DEBUG OUTPUT
// ===========================================

echo("=== FILTER CAP DIMENSIONS ===");
echo(str("Exterior: ", exterior_width_mm, " x ", exterior_depth_mm, " mm"));
echo(str("Interior cutout: ", interior_width_mm, " x ", interior_depth_mm, " mm"));
echo(str("Internal height: ", internal_height_mm, " mm (fan base ", fan_base_total_height_mm, " + filters ", total_filter_height_mm, ")"));
echo(str("Total height: ", total_height_mm, " mm"));
echo(str("Edge radius: ", top_radius_mm, " mm (top and bottom)"));
echo(str("Grid: ", grid_holes_x, " x ", grid_holes_y, " holes"));
echo("");
echo("=== BUILD CHECK (H2D: 350x320x325) ===");
echo(str("Width: ", exterior_width_mm, " / 350 mm - ", exterior_width_mm <= 350 ? "OK" : "TOO BIG"));
echo(str("Depth: ", exterior_depth_mm, " / 320 mm - ", exterior_depth_mm <= 320 ? "OK" : "TOO BIG"));
echo(str("Height: ", total_height_mm, " / 325 mm - ", total_height_mm <= 325 ? "OK" : "TOO BIG"));
