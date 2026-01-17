# Film Dryer Fan System

A 3D printable filtered air system for film drying boxes. Designed to fit on the Bambu Labs H2D 3D printer.

## Preview

### Base
| Isometric | Isometric Flipped |
|-----------|-------------------|
| ![Isometric](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/fan_base_isometric.png) | ![Isometric Flipped](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/fan_base_isometric_flipped.png) |

### Cap (Top Vents)
| Isometric | Isometric Flipped |
|-----------|-------------------|
| ![Isometric](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/filter_cap_isometric.png) | ![Isometric Flipped](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/filter_cap_isometric_flipped.png) |

### Cap (Side Vents)
*Images will be available after next release*

### Inside Mount
| Isometric | Isometric Flipped |
|-----------|-------------------|
| ![Isometric](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/inside_mount_isometric.png) | ![Isometric Flipped](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/inside_mount_isometric_flipped.png) |

## Overview

This system consists of four pieces:
1. **Base** (`base.scad`) - Mounts 4x 80mm computer fans with flanges to attach to a box
2. **Cap (Top Vents)** (`cap_top_vents.scad`) - Holds 2x 12x12x1" furnace filters with top grid vents
3. **Cap (Side Vents)** (`cap_side_vents.scad`) - Holds 2x 12x12x1" furnace filters with side vents
4. **Inside Mount** (`inside_mount.scad`) - Interior mounting plate with matching screw pattern

## Specifications

### Base
- Accommodates 4x 80mm computer fans in 2x2 configuration
- Standard 71.5mm mounting hole spacing (M4 screws)
- 8 mounting flanges (2 per side) with 5mm screw holes
- Dimensions: 310mm x 310mm base, ~43mm tall

### Cap (Top Vents)
- Holds 2x filters: 11.75" x 11.75" x 0.75" (298.45mm x 298.45mm x 19.05mm)
- Filters stack vertically for compact footprint
- Protective grill on top for air intake
- Slides over base with interference fit

### Cap (Side Vents)
- Same filter capacity as top vents version
- Side-mounted vents instead of top grid
- Solid top for protection from debris
- Slides over base with interference fit

### Build Volume (Bambu Labs H2D)
- Max build: 350mm x 320mm x 325mm
- Base: 310mm x 310mm x 43mm ✓
- Caps: ~305mm x 305mm x ~70mm ✓

## Downloads

| Part | STL Download |
|------|--------------|
| Base | [base.stl](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/base.stl) |
| Cap (Top Vents) | [cap_top_vents.stl](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/cap_top_vents.stl) |
| Cap (Side Vents) | [cap_side_vents.stl](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/cap_side_vents.stl) |
| Inside Mount | [inside_mount.stl](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/inside_mount.stl) |

## Files

| File | Description | Print This? |
|------|-------------|-------------|
| `base.scad` | Fan mounting base with flanges | ✓ Yes |
| `cap_top_vents.scad` | Filter holder cap with top vents | ✓ Pick one cap |
| `cap_side_vents.scad` | Filter holder cap with side vents | ✓ Pick one cap |
| `inside_mount.scad` | Interior mounting plate | ✓ Yes |

## Printing Instructions

1. Download the STL files from the table above (or from the [latest release](https://github.com/JeremyProffitt/film-dryer/releases/latest))
2. Print parts with the following recommended settings:
   - Layer height: 0.2mm
   - Infill: 15-20%
   - Walls: 3-4 perimeters
   - Material: PETG or ABS recommended for durability

## Assembly

1. Mount 4x 80mm fans to the base using M4 screws
2. Attach base to your box using the flanges (8x mounting points)
3. Insert 2x furnace filters into the cap (stacked)
4. Place cap over base

## Bill of Materials

- 4x 80mm computer fans (25mm thick)
- 16x M4 screws for fan mounting
- 8x screws for flange mounting (5mm holes)
- 2x 12x12x1" furnace filters (actual size: 11.75" x 11.75" x 0.75")

## Customization

All dimensions are parameterized in the OpenSCAD files. Adjust the values in the `[Main Dimensions]` and other sections to customize:

- `base_size` - Overall base dimensions
- `wall_thickness` - Wall thickness throughout
- `fan_size` - Fan dimensions (default 80mm)
- `flange_width` - Size of mounting flanges
- `filter_*` - Filter dimensions
