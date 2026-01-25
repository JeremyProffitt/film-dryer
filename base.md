# Fan Mounting Base

## Overview

The fan mounting base is the foundation component of the film dryer system. It mounts four 80mm computer fans in a 2x2 configuration, with fans sitting in deep recesses and blowing air downward into the drying box. The base includes a raised lip around the perimeter that interfaces with the filter cap component. Designed to fit the Bambu Labs H2D printer (max 350x320x325mm build volume).

## Dimensions

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Filter Specifications** | | |
| filter_width_mm | 298.45 | Actual filter width (11.75") |
| filter_depth_mm | 298.45 | Actual filter depth (11.75") |
| filter_clearance_mm | 2 | Gap around filters for easy insertion |
| wall_thickness_mm | 5 | Common wall thickness (must match filter_cap) |
| **Calculated from Filter Size** | | |
| interior_width_mm | 300.45 | filter_width_mm + filter_clearance_mm |
| interior_depth_mm | 300.45 | filter_depth_mm + filter_clearance_mm |
| base_width_mm | 310.45 | Overall width (X dimension) |
| base_depth_mm | 310.45 | Overall depth (Y dimension) |
| **Main Dimensions** | | |
| base_height_mm | 30 | Base plate thickness (Z dimension) |
| **Fan Specifications** | | |
| fan_size_mm | 80 | 80mm fan size |
| fan_hole_spacing_mm | 71.5 | Mounting hole center-to-center |
| fan_screw_diameter_mm | 3.8 | Clearance for #6 screw shaft |
| fan_screw_head_diameter_mm | 7.0 | Flat head #6 screw head diameter (82 deg) |
| fan_screw_countersink_depth_mm | 2.2 | Depth of countersink cone |
| fan_opening_diameter_mm | 76 | Airflow opening diameter |
| fan_corner_radius_mm | 5 | Rounded corners on fans |
| fan_gap_mm | 8 | Gap between fans |
| **Fan Recess** | | |
| recess_depth_mm | 25 | base_height_mm - 5 (fans sit deep) |
| fan_recess_size_mm | 85 | Square cutout for 80mm fans with gap |
| **Corner Mounting Holes** | | |
| corner_inset_mm | 30 | Distance from edge (~1 inch) |
| mounting_hole_diameter_mm | 5.0 | Clearance for #10 screw shaft |
| mounting_head_diameter_mm | 10.0 | Clearance for #10 screw head |
| mounting_head_depth_mm | 5.0 | Recess depth for screw head |
| **Cap Interface** | | |
| lip_height_mm | 25 | Raised rim height for cap interface |
| lip_thickness_mm | 20 | Rim wall thickness |
| **Calculated** | | |
| fan_offset_mm | 44 | (fan_size_mm + fan_gap_mm) / 2 |

## Component Diagram

### Top View (looking down, -Z)

```
                            +Y (back)
                               ^
                               |
        +----------------------+----------------------+
        |  o                   o                   o  |
        |      +----------+----------+                |
        |      |  85x85   |  85x85   |                |
        |      |  ((76))  |  ((76))  |   <-- fan recesses with
        |  o   |  [o  o]  |  [o  o]  |   o       76mm airflow holes
        |      |  [o  o]  |  [o  o]  |           [o o] = screw holes
        |      +----------+----------+                |
        |      +----------+----------+                |
        |      |  85x85   |  85x85   |                |
        |      |  ((76))  |  ((76))  |                |
        |  o   |  [o  o]  |  [o  o]  |   o            |
        |      |  [o  o]  |  [o  o]  |                |
        |      +----------+----------+                |
        |                                             |
        |  o                   o                   o  |
        +----------------------+----------------------+ --> +X (right)
       /
      Origin [0,0] (center)

    o = mounting holes (8 total: 4 corners + 4 side midpoints)
        30mm inset from edges, 5mm shaft with 10mm head recess
    Fan positions: +/-44mm from center in X and Y
```

### Side View (looking from right, -X)

```
                +Z (up)
                   ^
                   |
            55mm   |   +---------------------------+  <- top of lip
                   |   |  lip (20mm thick walls)   |
            30mm   |   +--+---------------------+--+  <- top of base plate
                   |   |  |  recess  |  recess  |  |
                   |   |  |  25mm    |  25mm    |  |
             5mm   |   |  +----( )--+--( )-----+  |  <- bottom of recess
                   |   |       76mm dia holes     |
             0mm   +---+---------------------------+----> +Y (back)
                      /
                     Origin [0,0,0] (center at ground)

                   |<-------- 310.45mm -------->|
```

### Front View (looking from front, -Y)

```
                +Z (up)
                   ^
                   |
            55mm   |   +---------------------------+  <- top of lip
                   |   |                           |
                   |   |   lip_height = 25mm       |
            30mm   |   +--+---------------------+--+  <- base_height
                   |   |  |  recess  |  recess  |  |
                   |   |  |  85x85   |  85x85   |  |
                   |   |  |  ((76))  |  ((76))  |  |
             5mm   |   |  +----( )--+--( )-----+  |
                   |   |  o                   o   |  <- mounting holes
             0mm   +---+---------------------------+----> +X (right)
                      /
                     Origin [0,0,0] (center)

                   |<-------- 310.45mm -------->|
```

## Components

### base_plate

- **Purpose**: Main structural platform that holds the fan array and provides the mounting surface
- **Position**: Origin centered at [0, 0, 0]
- **Bounding Box**: [-155.225, -155.225, 0] to [155.225, 155.225, 30]
- **Size**: [310.45, 310.45, 30] mm

### cap_lip

- **Purpose**: Raised rim around perimeter that provides interface for filter cap to fit over
- **Position**: Origin at [0, 0, base_height_mm] (top of base plate)
- **Bounding Box**: [-155.225, -155.225, 30] to [155.225, 155.225, 55]
- **Size**: [310.45, 310.45, 25] mm (hollow, 20mm wall thickness)
- **Attachment**: Bottom surface flush with base_plate top surface

### fan_cutout

- **Purpose**: Creates recess and airflow opening for a single 80mm fan with countersunk screw holes
- **Position**: Centered at origin, translated to each fan position (+/-44mm in X and Y)
- **Features**:
  - 85x85mm square recess, 25mm deep (sharp corners)
  - 76mm diameter through-hole for airflow
  - 4x countersunk screw holes at 71.5mm spacing (3.8mm shaft, 7.0mm head)
- **Attachment**: Subtracted from base_plate

### mounting_hole

- **Purpose**: Through-holes with head recesses for #10 screws to secure base to drying box
- **Position**: 8 locations total - 4 corners and 4 side midpoints, 30mm inset from edges
- **Features**:
  - 5.0mm shaft diameter (through entire height)
  - 10.0mm head recess diameter
  - 5.0mm head recess depth (from top)
- **Attachment**: Subtracted from base_plate

## Assembly Notes

### Print Orientation

- Print with base plate facing down (lip pointing up)
- The flat bottom surface ensures good bed adhesion
- No supports required for this orientation

### Recommended Settings

- **Layer Height**: 0.2mm for good detail on screw holes
- **Infill**: 20-30% (gyroid or grid pattern)
- **Perimeters**: 3-4 walls for structural rigidity
- **Top/Bottom Layers**: 4-5 layers

### Material Recommendations

- **PLA**: Suitable for indoor use, easy to print
- **PETG**: Recommended for better heat resistance and durability
- **ABS/ASA**: Best for high temperature or outdoor environments

### Hardware Required

- 16x #6 flat head screws (82 degree countersink) for fan mounting
- 8x #10 screws for base mounting to enclosure
- 4x 80mm fans (standard PC case fans)

### Post-Processing

- Test fit fans in recesses before final assembly
- Ensure countersunk screw holes allow screws to sit flush
- Verify filter cap fits over lip with appropriate clearance

## Changelog

| Date | Change |
|------|--------|
| 2026-01-25 | Initial design - 2x2 fan array with 8 mounting holes and cap lip interface |
