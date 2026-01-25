# Claude Code Guidelines for Film Dryer Project

## Project Overview

This repository contains OpenSCAD designs for a film dryer fan system with filtered air intake. The designs are intended for 3D printing and are optimized for the Bambu Labs H2D printer.

---

## 1. README.md Maintenance

The `README.md` must always be kept up-to-date and include rendered images of each SCAD design.

### Required Images

For **each** `.scad` file in the project, the README must display two images:

1. **Front-angle view**: Camera positioned at 45° azimuth (horizontal rotation) and 45° elevation (vertical tilt) from the front face
2. **Rear-angle view**: Camera positioned at the opposite angle (225° azimuth, 45° elevation) - effectively the "flipped" view showing the back

### Image Specifications

- Format: PNG
- Resolution: 800x600 pixels minimum
- Background: Transparent or neutral gray
- Naming convention: `<scad_filename>_front.png` and `<scad_filename>_rear.png`

### Camera Settings

OpenSCAD camera parameter format: `--camera=translateX,translateY,translateZ,rotX,rotY,rotZ,distance`

**Important**: The camera must be centered on the model's bounding box center, not the origin. Use `--autocenter --viewall` flags to automatically frame the entire model.

Camera angles:
- **Front view**: `rotX=55, rotY=0, rotZ=45` (looking from front-right-above)
- **Rear view**: `rotX=55, rotY=0, rotZ=225` (looking from back-left-above)

The `--autocenter` flag centers the model at the origin before rendering, and `--viewall` adjusts the camera distance to fit the entire model in frame.

### README Structure

```markdown
## Designs

### [Design Name]

| Front View | Rear View |
|------------|-----------|
| ![Front](https://github.com/<owner>/<repo>/releases/latest/download/<design>_front.png) | ![Rear](https://github.com/<owner>/<repo>/releases/latest/download/<design>_rear.png) |

[Description of the design and its purpose]

**Documentation**: [design.md](<design>.md)

**Download STL**: [design.stl](https://github.com/<owner>/<repo>/releases/latest/download/<design>.stl)
```

Note: Replace `<owner>/<repo>` with the actual GitHub repository path. Images and STL files are served from GitHub releases since generated files are not committed to the repository.

### GitHub Releases

Each release must include:
- All generated STL files
- All rendered PNG images (both views)
- The release pipeline should automatically generate these artifacts

---

## 2. OpenSCAD Coding Conventions

### Coordinate System Convention

All designs use the following coordinate system (document this at the top of each file):

```openscad
/**
 * Coordinate System:
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * Origin: Front-left corner of base plate, at ground level
 */
```

### Dimension Variables

All measurements must be defined as named constants at the top of the file. **Never use hardcoded numbers in geometry.**

#### Naming Convention

Variables follow this pattern: `<scope>_<description>_mm`

- **Object-specific dimensions**: Prefix with the module/function name
  - `base_plate_width_mm` - width specific to base_plate module
  - `vertical_bar_hole_diameter_mm` - hole diameter in vertical_bar module

- **Shared/global dimensions**: Use descriptive prefix
  - `vesa_hole_spacing_mm` - standard VESA measurement used by multiple components
  - `wall_thickness_mm` - common thickness used throughout

- **Always use `_mm` suffix** to indicate units

#### Example

```openscad
// ===========================================
// DIMENSIONS (all values in millimeters)
// ===========================================

// --- Global / Shared Dimensions ---
wall_thickness_mm     = 3;     // Common wall thickness
vesa_hole_spacing_mm  = 100;   // VESA 100x100 standard
screw_hole_diameter_mm = 4;    // M4 screw clearance

// --- base_plate dimensions ---
base_plate_width_mm   = 120;   // X dimension
base_plate_depth_mm   = 80;    // Y dimension
base_plate_height_mm  = 10;    // Z dimension

// --- vertical_bar dimensions ---
vertical_bar_width_mm  = 20;   // X dimension
vertical_bar_depth_mm  = 15;   // Y dimension
vertical_bar_height_mm = 150;  // Z dimension
vertical_bar_slot_width_mm  = 8;   // Cable management slot
vertical_bar_slot_depth_mm  = 5;

// --- monitor_bracket dimensions ---
monitor_bracket_width_mm  = 40;
monitor_bracket_depth_mm  = 20;
monitor_bracket_height_mm = 30;
monitor_bracket_arm_length_mm = 25;  // Specific to this component
```

#### Usage in Modules

```openscad
// GOOD: All dimensions from variables
module base_plate() {
    difference() {
        cube([base_plate_width_mm, base_plate_depth_mm, base_plate_height_mm]);
        // Holes use shared dimension
        translate([10, 10, 0])
            cylinder(h=base_plate_height_mm, d=screw_hole_diameter_mm, $fn=32);
    }
}

// BAD: Hardcoded numbers
module base_plate() {
    cube([120, 80, 10]);  // NO! Use variables
}
```

### Modular Function Design

Every distinct object or component must be defined in its own module:

```openscad
// GOOD: Separate modules for each component
module base_plate() { ... }
module vertical_bar() { ... }
module monitor_bracket() { ... }

// BAD: Everything in one monolithic block
difference() {
    cube([100, 100, 10]);
    // ... hundreds of lines ...
}
```

### Position and Alignment Documentation

Each module must include a comprehensive comment block:

```openscad
/**
 * Vertical Support Bar
 *
 * POSITION:
 *   Origin: [50, 65, 10] (front-left-bottom corner of this component)
 *
 * BOUNDING BOX:
 *   Min: [50, 65, 10]
 *   Max: [70, 80, 160]
 *   Size: [20, 15, 150]
 *
 * ALIGNMENT:
 *   X: Centered on base_plate (base_plate_width_mm/2 - vertical_bar_width_mm/2 = 50)
 *   Y: Flush with rear edge of base_plate (base_plate_depth_mm - vertical_bar_depth_mm = 65)
 *   Z: Sits on top surface of base_plate (z = base_plate_height_mm = 10)
 *
 * CONNECTS TO:
 *   - base_plate: bottom surface flush with base_plate top surface
 *   - monitor_bracket: top surface provides attachment point
 */
module vertical_bar() {
    translate([base_plate_width_mm/2 - vertical_bar_width_mm/2,
               base_plate_depth_mm - vertical_bar_depth_mm,
               base_plate_height_mm])
        cube([vertical_bar_width_mm, vertical_bar_depth_mm, vertical_bar_height_mm]);
}
```

### Connection Interfaces

Define named attachment points that components share:

```openscad
// ===========================================
// CONNECTION INTERFACES
// ===========================================

// Where vertical_bar attaches to base_plate
function base_plate_top_center() = [
    base_plate_width_mm/2,
    base_plate_depth_mm - vertical_bar_depth_mm/2,
    base_plate_height_mm
];

// Where monitor_bracket attaches to vertical_bar
function vertical_bar_top_center() = [
    base_plate_width_mm/2,
    base_plate_depth_mm - vertical_bar_depth_mm/2,
    base_plate_height_mm + vertical_bar_height_mm
];
```

### Component Index Table

Include a master index of all components at the top of the file:

```openscad
/**
 * ===========================================
 * COMPONENT INDEX
 * ===========================================
 *
 * | Component        | Origin [X,Y,Z]  | Size [W,D,H]    | Attaches To      |
 * |------------------|-----------------|-----------------|------------------|
 * | base_plate       | [0, 0, 0]       | [100, 80, 10]   | (ground)         |
 * | vertical_bar     | [40, 65, 10]    | [20, 15, 150]   | base_plate top   |
 * | monitor_bracket  | [30, 60, 160]   | [40, 20, 30]    | vertical_bar top |
 *
 */
```

### Debug and Visualization Modules

Every SCAD file must include these debug modules:

```openscad
// ===========================================
// DEBUG / VISUALIZATION
// ===========================================

// Render coordinate axes at origin (length = 50mm)
module debug_axes(length = 50) {
    color("red")   translate([0,0,0]) cylinder(h=length, r=1, $fn=16);  // Z
    color("green") rotate([0,90,0]) cylinder(h=length, r=1, $fn=16);    // X
    color("blue")  rotate([-90,0,0]) cylinder(h=length, r=1, $fn=16);   // Y
}

// Show bounding box for a component (transparent)
module debug_bounds(min_pt, max_pt) {
    color("yellow", 0.2)
        translate(min_pt)
            cube(max_pt - min_pt);
}

// Color-coded assembly for visual debugging
module assembly_colored() {
    color("gray")   base_plate();
    color("blue")   vertical_bar();
    color("green")  monitor_bracket();
}

// Exploded view - separates components along Z axis
module assembly_exploded(separation = 30) {
    translate([0, 0, 0])              base_plate();
    translate([0, 0, separation])     vertical_bar();
    translate([0, 0, separation * 2]) monitor_bracket();
}
```

### Assembly Module

The main assembly module combines all components:

```openscad
/**
 * Main Assembly
 *
 * Combines all components in their final positions.
 * Use assembly_colored() or assembly_exploded() for debugging.
 */
module assembly() {
    base_plate();
    vertical_bar();
    monitor_bracket();
}

// Default render
assembly();
```

---

## 3. Documentation Files

### Per-Design Documentation

**IMPORTANT**: For each `.scad` file, create and maintain a corresponding `.md` file in the **same directory** as the `.scad` file.

| SCAD File | Documentation File |
|-----------|-------------------|
| `mount.scad` | `mount.md` |
| `bracket.scad` | `bracket.md` |
| `parts/widget.scad` | `parts/widget.md` |

### Documentation File Structure

Each documentation file must contain:

```markdown
# [Design Name]

## Overview

Brief description of what this design is and its purpose.

## Dimensions

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Global** | | |
| wall_thickness_mm | 3 | Common wall thickness |
| screw_hole_diameter_mm | 4 | M4 screw clearance |
| **base_plate** | | |
| base_plate_width_mm | 120 | Width of the base plate (X) |
| base_plate_depth_mm | 80 | Depth of the base plate (Y) |
| base_plate_height_mm | 10 | Height of the base plate (Z) |
| **vertical_bar** | | |
| vertical_bar_width_mm | 20 | Width of vertical bar (X) |
| ... | ... | ... |

## Component Diagram

### Top View (looking down, -Z)

```
        +Y (back)
           ^
           |
    +------+------+
    |             |
    |    [BAR]    |
    |      *      |   <-- * = bar position
    |             |
    |             |
    +-------------+  --> +X (right)
   /
  Origin [0,0]
```

### Side View (looking from right, -X)

```
        +Z (up)
           ^
           |    +--+
           |    |  |  monitor_bracket
           |    +--+
           |    |  |
           |    |  |  vertical_bar
           |    |  |
           |    |  |
    +------+----+--+----> +Y (back)
    |      base_plate   |
    +-------------------+
```

### Front View (looking from front, -Y)

```
        +Z (up)
           ^
           |      +--+
           |      |  |  monitor_bracket
           |      +--+
           |      |  |
           |      |  |  vertical_bar
           |      |  |
           |      |  |
    +------+------+--+------+----> +X (right)
    |       base_plate      |
    +------------------------+
```

## Components

### base_plate

- **Purpose**: Foundation that attaches to VESA mount
- **Position**: Origin [0, 0, 0]
- **Bounding Box**: [0,0,0] to [100, 80, 10]

### vertical_bar

- **Purpose**: Vertical support structure
- **Position**: Origin [40, 65, 10]
- **Bounding Box**: [40, 65, 10] to [60, 80, 160]
- **Attachment**: Bottom surface connects to base_plate top

[Continue for each component...]

## Assembly Notes

- Print orientation: Base plate facing down
- Recommended infill: 20%
- Material: PLA or PETG

## Changelog

| Date | Change |
|------|--------|
| YYYY-MM-DD | Initial design |
```

### Keeping Documentation in Sync

**CRITICAL**: Whenever a `.scad` file is modified:
1. Update the corresponding `<name>.md` file (same directory as the `.scad`)
2. Update the component index table in both files
3. Update ASCII diagrams if positions change
4. Update the README.md if the design's purpose or images change

---

## 4. Build Scripts and Generated Files

### Scripts

The repository must contain build scripts for both platforms:

- `build.sh` - Bash script for Linux/macOS
- `build.bat` - Batch script for Windows

Both scripts must:
1. Find all `.scad` files in the project
2. Generate STL files for each design
3. Generate PNG images (front and rear views) for each design
4. Output files to a `build/` directory

### Script Requirements

- Use OpenSCAD command-line interface
- Camera settings for images:
  - Use `--autocenter` to center the model at origin before rendering
  - Use `--viewall` to automatically fit the entire model in frame
  - Front view: `--camera=0,0,0,55,0,45,0` (rotX=55, rotY=0, rotZ=45)
  - Rear view: `--camera=0,0,0,55,0,225,0` (rotX=55, rotY=0, rotZ=225)
  - Note: With `--viewall`, the distance parameter (last value) is ignored
- Image size: `--imgsize=800,600`
- Output format: `--export-format=binstl` for STL files

### .gitignore

The following must be in `.gitignore`:

```
# Generated build artifacts
build/
*.stl
*.png

# Exception: Keep source images if any exist in assets/
!assets/*.png
```

Generated files should never be committed to the repository - they are produced by the build scripts and included only in GitHub releases.

---

## 5. Workflow Summary

1. **Development**: Create/modify `.scad` files following the modular conventions
2. **Documentation**: Update corresponding `<name>.md` (same directory) with ASCII diagrams and component details
3. **Local Testing**: Run `build.sh` or `build.bat` to generate STL and images locally
4. **README Update**: Ensure `README.md` references the design, documentation link, and release STL download
5. **Release**: GitHub Actions pipeline generates artifacts and attaches to release

---

## 6. Quick Reference: Required Updates Checklist

When creating or modifying a `.scad` file:

- [ ] Coordinate system documented at top
- [ ] All dimensions as named variables (no hardcoded numbers)
- [ ] Variable names follow convention: `<module_name>_<description>_mm`
- [ ] Shared dimensions use descriptive prefix (e.g., `wall_thickness_mm`)
- [ ] Component index table updated
- [ ] Each module has position/bounding box/alignment comments
- [ ] Connection interfaces defined as functions
- [ ] Debug modules included (axes, bounds, colored, exploded)
- [ ] `<name>.md` created/updated in same directory with ASCII diagrams
- [ ] `README.md` updated with design entry and link to docs
