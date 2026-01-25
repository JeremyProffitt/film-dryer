# Filter Cap with Side Vents

## Overview

A filter cap designed to sit atop the fan base and hold two stacked 12x12x1 furnace filters. This variant features a solid top surface with teardrop-shaped ventilation holes on all four side walls. The cap has a two-tier interior: a main cutout below for the filters and a smaller recessed area above with the side vents. Rounded edges on top and bottom provide a finished appearance. The teardrop vent shape is optimized for 3D printing when the cap is printed upside down, allowing the vents to be self-supporting without bridging.

## Dimensions

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Filter Specifications** | | |
| filter_width_mm | 298.45 | Filter width (X dimension, 11.75 inches) |
| filter_depth_mm | 298.45 | Filter depth (Y dimension, 11.75 inches) |
| filter_height_mm | 19.05 | Filter height (0.75 inches) |
| num_filters | 2 | Number of filters stacked vertically |
| filter_clearance_mm | 1 | Gap around filters for easy insertion |
| **Frame Dimensions** | | |
| wall_thickness_mm | 5 | Common wall thickness |
| frame_height_mm | 15 | Height of top frame section |
| top_radius_mm | 2 | Radius for top and bottom edge rounding |
| **Upper Recess Specifications** | | |
| upper_recess_inset_mm | 45 | How much smaller the upper recess is (per side) |
| extra_recess_height_mm | 10 | Additional height for upper recess and cap |
| **Side Vent Specifications** | | |
| vent_hole_height_mm | 15 | Height of rectangular portion of vent |
| vent_holes_per_side | 10 | Number of vent holes per side |
| vent_hole_radius_mm | 1.5 | Radius for rounded corners (unused, teardrops instead) |
| **Base Interface** | | |
| base_width_mm | 310 | Fan base width (must match fan_base.scad) |
| base_height_mm | 30 | Fan base plate thickness |
| lip_height_mm | 25 | Must match fan_base lip_height |
| **Calculated Dimensions** | | |
| interior_width_mm | 299.45 | filter_width_mm + filter_clearance_mm |
| interior_depth_mm | 299.45 | filter_depth_mm + filter_clearance_mm |
| total_filter_height_mm | 39.1 | (filter_height_mm * num_filters) + filter_clearance_mm |
| exterior_width_mm | 309.45 | interior_width_mm + (2 * wall_thickness_mm) |
| exterior_depth_mm | 309.45 | interior_depth_mm + (2 * wall_thickness_mm) |
| fan_base_total_height_mm | 55 | base_height_mm + lip_height_mm |
| internal_height_mm | 94.1 | fan_base_total_height_mm + total_filter_height_mm |
| cap_height_mm | 109.1 | internal_height_mm + wall_thickness_mm + extra_recess_height_mm |
| total_height_mm | 109.1 | Total height of entire object |
| grid_z_mm | 84.1 | Z position where frame/upper section starts |
| upper_recess_width_mm | 253.45 | filter_width_mm - upper_recess_inset_mm |
| upper_recess_depth_mm | 253.45 | filter_depth_mm - upper_recess_inset_mm |
| upper_recess_height_mm | 20 | frame_height_mm - wall_thickness_mm + extra_recess_height_mm |
| vent_hole_length_mm | 20.04 | Calculated width of each vent hole |
| vent_z_center_mm | 96.6 | Z center of vent holes |
| vent_spacing_mm | 25.04 | Spacing between hole centers |

## Component Diagram

### Top View (looking down, -Z)

```
                          +Y (back)
                             ^
                             |
        +--------------------+--------------------+
        |                                         |
        |    +-------------------------------+    |
        |    |                               |    |
        |    |      Upper Recess Area        |    |
        |    |       (253.45 x 253.45)       |    |
        |    |                               |    |
        |    |          SOLID TOP            |    |
        |    |       (no top vents)          |    |
        |    |                               |    |
        |    +-------------------------------+    |
        |                                         |
        +-----------------------------------------+  --> +X (right)
       /
      Origin [0,0] (centered)

      Exterior: 309.45 x 309.45 mm
```

### Side View (looking from right, -X)

```
        +Z (up)
           ^
           |
   109.1mm +--+=========================================+--+
           |  |  wall (5mm thick solid top)             |  |
           |  +-----------------------------------------+  |
           |  |      Upper Recess (20mm height)         |  |
    96.6mm |  |  [v] [v] [v] [v] [v] [v] [v] [v] [v] [v]|  |  <-- Teardrop vents
           |  |      (253.45mm wide)                    |  |
    84.1mm +--+-----------------------------------------+--+
           |  |                                         |  |
           |  |                                         |  |
           |  |        Main Interior Cavity             |  |
           |  |        (299.45 x 299.45 mm)             |  |
           |  |                                         |  |
           |  |   +-------------------------------+     |  |
    55mm   |  |   |    Filter 2 (19.05mm)         |     |  |
           |  |   +-------------------------------+     |  |
    35.95mm|  |   |    Filter 1 (19.05mm)         |     |  |
           |  |   +-------------------------------+     |  |
           |  |        (sits on fan_base lip)           |  |
           |  |                                         |  |
         0 +--+-----------------------------------------+--+--> +Y (back)

           |<--- 5mm wall                    5mm wall --->|
           |<------------- 309.45mm total --------------->|
```

### Front View (looking from front, -Y) - Teardrop Vent Detail

```
        +Z (up)
           ^
           |
           |     Single Teardrop Vent (point down for printing upside-down)
           |
           |           +-------+
           |          /         \
           |         /           \
           |        |             |    <-- Rectangular top half (7.5mm)
           |        |             |
           |        |             |
           |         \           /
           |          \         /
           |           \       /
           |            \     /
           |             \   /
           |              \ /
           |               *         <-- Point (45 degree angles)
           |
           +-------------------------------------------------> +X (right)

           |<-- 20.04mm -->|

           Vent hole dimensions: 20.04mm wide x 15mm tall
           10 vents per side x 4 sides = 40 total vents
```

## Components

### filter_cap_side_vents (Outer Shell)

- **Purpose**: Main cap body that sits atop the fan base, holds filters, and provides side ventilation
- **Position**: Origin [0, 0, 0] (XY centered, Z at bottom)
- **Bounding Box**: [-154.73, -154.73, 0] to [154.73, 154.73, 109.1]
- **Size**: [309.45, 309.45, 109.1] mm
- **Features**: Rounded top and bottom edges (2mm radius) using Minkowski sum with sphere

### Interior Cavity (Main Cutout)

- **Purpose**: Houses two stacked furnace filters and accommodates the fan base lip
- **Position**: Centered at XY origin, extends from Z=0 to Z=84.1mm (grid_z)
- **Bounding Box**: [-149.73, -149.73, 0] to [149.73, 149.73, 84.1]
- **Size**: [299.45, 299.45, 84.1] mm
- **Clearance**: 1mm gap around filters for easy insertion/removal

### Upper Recess

- **Purpose**: Smaller recessed area above main cavity where side vents are located
- **Position**: Centered at XY origin, from Z=84.1mm to Z=104.1mm
- **Bounding Box**: [-126.73, -126.73, 84.1] to [126.73, 126.73, 104.1]
- **Size**: [253.45, 253.45, 20] mm
- **Inset**: 45mm smaller per side than the main interior (creates shelf for vent walls)

### Side Vents

- **Purpose**: Teardrop-shaped ventilation holes on all four walls for air intake
- **Configuration**: 10 holes per side x 4 sides = 40 total vents
- **Hole Size**: 20.04mm wide x 15mm tall (teardrop shape)
- **Position**: Holes cut through the wall from exterior to upper recess
- **Z Position**: Top of vents aligned with top of upper recess (centered at Z=96.6mm)
- **Spacing**: 5mm wall thickness between holes, 5mm buffer from edges

## Assembly Notes

### Print Orientation

- **Recommended**: Print upside down (solid top facing the build plate)
- **Reason**: Teardrop vents have a 45-degree pointed bottom that is self-supporting when printed upside down
- **Alternative**: If printing right-side up, supports would be needed inside the vent holes

### Filter Insertion

1. Place cap upside down or tilted
2. Insert first filter into the main cavity (sits on the stepped shelf at grid_z level)
3. Stack second filter on top of first
4. Place cap assembly onto fan_base lip

### Interface with Fan Base

- Cap sits on top of fan_base lip (lip_height = 25mm)
- Interior dimensions accommodate fan_base lip fit
- Filters rest above the fan base total height (55mm from bottom)

### Build Volume Check (Bambu Labs H2D: 350x320x325mm)

- Width: 309.45mm / 350mm - OK
- Depth: 309.45mm / 320mm - OK
- Height: 109.1mm / 325mm - OK

## Changelog

| Date | Change |
|------|--------|
| 2026-01-25 | Initial documentation created |
