# Film Dryer Fan System

A 3D printable filtered air system for film drying boxes. Designed to fit on the Bambu Labs H2D 3D printer.

## Preview

### Assembly
![Assembly - Isometric](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/assembly_isometric.png)

| Front | Back | Top |
|-------|------|-----|
| ![Front](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/assembly_front.png) | ![Back](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/assembly_back.png) | ![Top](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/assembly_top.png) |

### Fan Base
| Isometric | Front | Back | Top |
|-----------|-------|------|-----|
| ![Isometric](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/fan_base_isometric.png) | ![Front](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/fan_base_front.png) | ![Back](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/fan_base_back.png) | ![Top](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/fan_base_top.png) |

### Filter Cap
| Isometric | Front | Back | Top |
|-----------|-------|------|-----|
| ![Isometric](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/filter_cap_isometric.png) | ![Front](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/filter_cap_front.png) | ![Back](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/filter_cap_back.png) | ![Top](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/filter_cap_top.png) |

### Inside Mount
| Isometric | Front | Back | Top |
|-----------|-------|------|-----|
| ![Isometric](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/inside_mount_isometric.png) | ![Front](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/inside_mount_front.png) | ![Back](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/inside_mount_back.png) | ![Top](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/inside_mount_top.png) |

## Overview

This system consists of three pieces:
1. **Fan Base** (`fan_base.scad`) - Mounts 4x 80mm computer fans with flanges to attach to a box
2. **Filter Cap** (`filter_cap.scad`) - Holds 2x 12x12x1" furnace filters stacked vertically
3. **Inside Mount** (`inside_mount.scad`) - Interior mounting plate with matching screw pattern

## Specifications

### Fan Base
- Accommodates 4x 80mm computer fans in 2x2 configuration
- Standard 71.5mm mounting hole spacing (M4 screws)
- 8 mounting flanges (2 per side) with 5mm screw holes
- Dimensions: 310mm x 310mm base, ~43mm tall

### Filter Cap
- Holds 2x filters: 11.75" x 11.75" x 0.75" (298.45mm x 298.45mm x 19.05mm)
- Filters stack vertically for compact footprint
- Protective grill on top
- Slides over fan base with interference fit

### Build Volume (Bambu Labs H2D)
- Max build: 350mm x 320mm x 325mm
- Fan base: 310mm x 310mm x 43mm ✓
- Filter cap: ~305mm x 305mm x ~70mm ✓

## Downloads

| Part | STL Download |
|------|--------------|
| Fan Base | [fan_base.stl](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/fan_base.stl) |
| Filter Cap | [filter_cap.stl](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/filter_cap.stl) |
| Inside Mount | [inside_mount.stl](https://github.com/JeremyProffitt/film-dryer/releases/download/latest/inside_mount.stl) |

## Files

| File | Description | Print This? |
|------|-------------|-------------|
| `fan_base.scad` | Fan mounting base with flanges | ✓ Yes |
| `filter_cap.scad` | Filter holder cap | ✓ Yes |
| `inside_mount.scad` | Interior mounting plate | ✓ Yes |
| `assembly.scad` | Assembly visualization | No (view only) |

## Printing Instructions

1. Download the STL files from the table above (or from the [latest release](https://github.com/JeremyProffitt/film-dryer/releases/latest))
2. Print both parts with the following recommended settings:
   - Layer height: 0.2mm
   - Infill: 15-20%
   - Walls: 3-4 perimeters
   - Material: PETG or ABS recommended for durability

## Assembly

1. Mount 4x 80mm fans to the fan base using M4 screws
2. Attach fan base to your box using the flanges (8x mounting points)
3. Insert 2x furnace filters into the cap (stacked)
4. Place cap over fan base

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
