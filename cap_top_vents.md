# Filter Cap with Top Grid Vents

## Overview

A hollow filter cap designed to fit over the fan_base and hold two stacked 12x12x1 furnace filters (11.75" x 11.75" x 0.75" actual dimensions). The cap features a protective ventilation grid on top for air intake, with rounded top and bottom edges for improved aesthetics and handling. The interior cavity is open through the bottom to allow the cap to slide over the fan_base while providing space for filter insertion.

Designed to fit the Bambu Labs H2D printer (max build volume: 350x320x325mm).

## Dimensions

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Filter Specifications** | | |
| filter_width_mm | 298.45 | X dimension of filter (11.75 inches) |
| filter_depth_mm | 298.45 | Y dimension of filter (11.75 inches) |
| filter_height_mm | 19.05 | Z dimension of single filter (0.75 inches) |
| num_filters | 2 | Number of filters stacked vertically |
| filter_clearance_mm | 1 | Gap around filters for easy insertion |
| **Frame Dimensions** | | |
| wall_thickness_mm | 5 | Wall thickness throughout |
| frame_height_mm | 15 | Height of top frame/grid section |
| top_radius_mm | 2 | Radius for top and bottom edge rounding |
| **Grid Specifications** | | |
| grid_bar_width_mm | 3 | Width of grid bars |
| grid_holes_x | 12 | Number of holes in X direction |
| grid_holes_y | 12 | Number of holes in Y direction |
| grid_hole_radius_mm | 2 | Radius for grid hole corners |
| **Base Interface** | | |
| base_width_mm | 310 | Width of fan base (must match fan_base.scad) |
| base_height_mm | 30 | Fan base plate thickness |
| lip_height_mm | 25 | Lip height (must match fan_base lip_height) |
| **Calculated Dimensions** | | |
| interior_width_mm | 299.45 | filter_width + clearance |
| interior_depth_mm | 299.45 | filter_depth + clearance |
| total_filter_height_mm | 39.1 | (filter_height x 2) + clearance |
| exterior_width_mm | 309.45 | interior_width + (2 x wall_thickness) |
| exterior_depth_mm | 309.45 | interior_depth + (2 x wall_thickness) |
| fan_base_total_height_mm | 55 | base_height + lip_height |
| internal_height_mm | 94.1 | fan_base_total_height + total_filter_height |
| cap_height_mm | 99.1 | internal_height + wall_thickness |
| total_height_mm | 99.1 | Total height of entire cap |
| usable_width_mm | 279.45 | interior_width - 20 (grid area) |
| usable_depth_mm | 279.45 | interior_depth - 20 (grid area) |
| grid_z_mm | 84.1 | cap_height - frame_height |

## Component Diagram

### Top View (looking down, -Z)

```
                          +Y (back)
                             ^
                             |
        +--------------------+--------------------+
        |  +--------------grid area-----------+  |
        |  | +--+ +--+ +--+ +--+ +--+ +--+ +--+|  |
        |  | |  | |  | |  | |  | |  | |  | |  ||  |
        |  | +--+ +--+ +--+ +--+ +--+ +--+ +--+|  |
        |  | +--+ +--+ +--+ +--+ +--+ +--+ +--+|  |
        |  | |  | |  | |  | |  | |  | |  | |  ||  |
        |  | +--+ +--+ +--+ +--+ +--+ +--+ +--+|  |
        |  | +--+ +--+ +--+ +--+ +--+ +--+ +--+|  |
        |  | |  | |  | |  | |  | |  | |  | |  ||  |   <-- 12x12 grid of
        |  | +--+ +--+ +--+ +--+ +--+ +--+ +--+|  |       ventilation holes
        |  | +--+ +--+ +--+ +--+ +--+ +--+ +--+|  |
        |  | |  | |  | |  | |  | |  | |  | |  ||  |
        |  | +--+ +--+ +--+ +--+ +--+ +--+ +--+|  |
        |  +----------------------------------+   |
        |                                        |
        +-------------------*--------------------+  --> +X (right)
                           /
                   Origin [0,0]
                   (centered)

        Exterior: 309.45 x 309.45 mm
        Grid area: 279.45 x 279.45 mm (12x12 holes)
```

### Side View (looking from right, -X)

```
                +Z (up)
                   ^
                   |
    99.1mm ------> +=============================+ <-- top surface with grid
                   |  [ ]  [ ]  [ ]  [ ]  [ ]    |     (frame_height = 15mm)
    grid_z  -----> +-----------------------------+ <-- grid starts here (84.1mm)
    (84.1mm)       |                             |
                   |                             |
                   |     interior cavity         |     <-- open interior for
                   |     (filter space +         |         fan_base + filters
                   |      fan_base space)        |
                   |                             |
                   |                             |
                   |                             |
                   +=============================+ ----> +Y (back)
                   ^                             ^
                   |                             |
              wall thickness              wall thickness
                 (5mm)                       (5mm)

         Total height: 99.1mm
         Interior cutout goes from Z=0 to Z=84.1mm (grid_z)
```

### Front View (looking from front, -Y)

```
                              +Z (up)
                                 ^
                                 |
        +------------------------+------------------------+
        |  [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ]    | <-- grid holes
        |  [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ]    |     (12x12 pattern)
        +------------------------------------------------ + <-- grid_z (84.1mm)
        |                                                 |
        |                                                 |
        |                                                 |
        |                                                 |
        |              interior cavity                    |
        |              (open through bottom)              |
        |                                                 |
        |                                                 |
        |                                                 |
        |                                                 |
        +-------------------------*-----------------------+ ----> +X (right)
                                 /
                          Origin [0,0,0]
                          (centered X/Y)

        Width: 309.45mm (exterior)
        Interior opening: 299.45mm
        Wall thickness: 5mm each side
        Rounded edges: 2mm radius (top and bottom)
```

## Components

### rounded_rect (2D Helper Module)

- **Purpose**: Creates a 2D rounded rectangle shape used for the cap exterior profile
- **Position**: Centered at origin (2D)
- **Parameters**: w (width), h (height), r (corner radius)
- **Usage**: Called by filter_cap to generate the exterior shell profile

### grid_holes

- **Purpose**: Creates the 12x12 pattern of ventilation holes cut through the top of the cap
- **Position**: Origin [0, 0, grid_z_mm] (centered in X/Y)
- **Bounding Box**: [-139.725, -139.725, 83.1] to [139.725, 139.725, 111.1]
- **Size**: [279.45, 279.45, frame_height + 10] (usable area)
- **Grid Pattern**: 12 columns x 12 rows with 3mm bars between holes
- **Hole Corners**: Rounded with 2mm radius
- **Connects To**: Subtracted from filter_cap to create ventilation

### filter_cap

- **Purpose**: Main component - hollow cap with rounded edges and top ventilation grid
- **Position**: Origin [0, 0, 0] (centered in X/Y, bottom at Z=0)
- **Bounding Box**: [-154.725, -154.725, 0] to [154.725, 154.725, 99.1]
- **Size**: [309.45, 309.45, 99.1]
- **Features**:
  - Rounded top and bottom edges (2mm radius via Minkowski sum)
  - Interior cavity open through bottom for fan_base fit
  - 12x12 ventilation grid on top surface
  - 5mm wall thickness throughout
- **Attachment**: Bottom opening fits over fan_base top lip

## Assembly Notes

### Fitting Over Base

1. The cap's interior cavity (299.45 x 299.45mm) is sized to fit over the fan_base
2. The internal height (94.1mm) accommodates:
   - Fan base total height: 55mm (30mm plate + 25mm lip)
   - Two stacked filters: 39.1mm (2 x 19.05mm + 1mm clearance)
3. The cap slides down over the fan_base until the bottom edges meet

### Filter Insertion

1. Remove cap from fan_base
2. Insert first filter (11.75" x 11.75" x 0.75") into the cavity
3. Stack second filter on top of first
4. Replace cap over fan_base assembly
5. Filters rest on the fan_base lip, held in place by the cap walls

### Print Orientation

- **Recommended**: Print with top grid facing up (no supports needed for grid)
- **Infill**: 20% recommended for structural integrity
- **Material**: PLA or PETG suitable

### Build Volume Check (Bambu Labs H2D: 350x320x325mm)

| Dimension | Value | Limit | Status |
|-----------|-------|-------|--------|
| Width (X) | 309.45mm | 350mm | OK |
| Depth (Y) | 309.45mm | 320mm | OK |
| Height (Z) | 99.1mm | 325mm | OK |

## Connection Interfaces

| Function | Return Value | Description |
|----------|--------------|-------------|
| filter_cap_bottom_center() | [0, 0, 0] | Bottom opening center point |
| filter_cap_top_center() | [0, 0, 99.1] | Top surface center point |
| filter_cap_interior_opening() | [299.45, 299.45] | Interior opening dimensions |
| filter_cap_grid_z() | 84.1 | Z position where grid starts |

## Changelog

| Date | Change |
|------|--------|
| 2026-01-25 | Initial documentation created |
