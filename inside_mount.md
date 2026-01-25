# Inside Mount Plate

## Overview

The inside mount plate is an interior mounting plate for the film dryer fan system. It mounts from inside the box and mates with the fan_base through the wall, creating a secure sandwich connection. The plate features a central rounded-square cutout for airflow to the four 80mm fans, and eight mounting holes (four at corners, four at side midpoints) with countersunk recesses for #10 screw heads.

## Dimensions

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Filter Specifications** | | |
| filter_width_mm | 298.45 | Filter width (11.75 inches) |
| filter_depth_mm | 298.45 | Filter depth (11.75 inches) |
| filter_clearance_mm | 2 | Gap around filters for easy insertion |
| wall_thickness_mm | 5 | Must match filter_cap |
| **Calculated Dimensions** | | |
| interior_width_mm | 300.45 | filter_width_mm + filter_clearance_mm |
| interior_depth_mm | 300.45 | filter_depth_mm + filter_clearance_mm |
| base_width_mm | 310.45 | Overall width (matches fan_base) |
| base_depth_mm | 310.45 | Overall depth (matches fan_base) |
| **Main Plate** | | |
| plate_height_mm | 10 | Plate thickness (Z) |
| **Corner Mounting Holes** | | |
| corner_inset_mm | 30 | Distance from corner to hole center |
| mounting_hole_diameter_mm | 5.0 | Clearance for #10 screw shaft |
| mounting_head_diameter_mm | 10.0 | Clearance for #10 screw head |
| mounting_head_depth_mm | 5.0 | Recess depth for screw head |
| **Fan Cutout** | | |
| fan_size_mm | 80 | Individual fan size |
| fan_gap_mm | 8 | Gap between fans |
| fan_offset_mm | 44 | (fan_size_mm + fan_gap_mm) / 2 |
| cutout_size_mm | 182 | Cutout covers all 4 fans |
| cutout_corner_radius_mm | 10 | Rounded corners on cutout |

## Component Diagrams

### Top View (looking down, -Z)

```
                              +Y (back)
                                 ^
                                 |
    +----------------------------.----------------------------+
    |  O                                                  O   |
    |                                                         |
    |                                                         |
    |              +-------------------------+                |
    |              |                         |                |
    |              |                         |                |
    |  O           |      FAN CUTOUT         |            O   |
    |              |       (~182mm)          |                |
 <--.--------------|            *            |----------------.--> +X (right)
    |              |                         |                |
    |              |                         |                |
    |  O           |                         |            O   |
    |              +-------------------------+                |
    |                    (rounded corners)                    |
    |                                                         |
    |  O                                                  O   |
    +----------------------------.----------------------------+
                                 |
                              Origin [0,0]

    Legend:
      O = Mounting hole (8 total: 4 corners + 4 side midpoints)
      * = Center of plate
      . = Axis reference points
```

### Side View (looking from right, -X)

```
           +Z (up)
              ^
              |
              |     plate_height_mm (10mm)
              |    +--------------------------------------------------+
              |    |                                                  |
              |    |     MOUNTING          FAN              MOUNTING  |
              |    |      HOLE           CUTOUT               HOLE    |
              +----+------[  ]------+-------------+-------[  ]--------+----> +Y (back)
                   |                |             |                   |
                   +----------------+             +-------------------+

                  -Y                                                 +Y
              (front edge)                                      (back edge)

                   |<------ corner_inset_mm (30mm) ------>|
                   |<-------------- base_depth_mm (~310mm) ---------->|
```

### Front View (looking from front, -Y)

```
           +Z (up)
              ^
              |
              |     plate_height_mm (10mm)
              |    +--------------------------------------------------+
              |    |                                                  |
              |    |     MOUNTING          FAN              MOUNTING  |
              |    |      HOLE           CUTOUT               HOLE    |
              +----+------[  ]------+-------------+-------[  ]--------+----> +X (right)
                   |     (head      |             |        (head      |
                   |     recess)    |             |        recess)    |
                   +----------------+             +-------------------+

                  -X                      *                          +X
              (left edge)              Origin                   (right edge)

                   |<-------------- base_width_mm (~310mm) ---------->|
```

## Components

### base_plate

- **Purpose**: Main solid body of the mounting plate
- **Position**: Centered on origin at Z=0
- **Bounding Box**: [-155.225, -155.225, 0] to [155.225, 155.225, 10]
- **Size**: [310.45, 310.45, 10] mm
- **Attachment**: Ground level, receives subtractive features

### fan_cutout

- **Purpose**: Central opening for airflow to all four 80mm fans
- **Position**: Centered at origin, extends through plate thickness
- **Bounding Box**: [-91, -91, -1] to [91, 91, 12]
- **Size**: [182, 182, plate_height+2] mm (with rounded corners r=10mm)
- **Attachment**: Subtractive element from base_plate

### corner_mounting_hole (x8)

- **Purpose**: Through holes with countersunk head recesses for #10 screws
- **Position**: 8 positions - 4 at corners, 4 at side midpoints
- **Hole Layout**:
  - Corner holes: 30mm inset from each corner
  - Side holes: Centered on each edge, 30mm from edge
- **Features**:
  - Through hole: 5.0mm diameter (shaft clearance)
  - Head recess: 10.0mm diameter, 5.0mm deep (from top)
- **Attachment**: Subtractive elements, align with fan_base mounting holes

## Assembly Notes

### Mounting Position
- Mounts from **inside** the enclosure box
- Mates with fan_base through the box wall
- Screws insert from inside, heads recess into this plate

### Alignment with fan_base
- Identical footprint (310.45 x 310.45 mm)
- All 8 mounting holes align exactly with fan_base holes
- Forms a sandwich joint with enclosure wall between plates

### Print Orientation
- Print with flat side down (Z=0 surface on bed)
- No supports needed

### Recommended Settings
- Infill: 20-30%
- Material: PLA or PETG
- Layer height: 0.2mm

### Hardware
- 8x #10 screws (shaft 4.8mm, head 9.5mm)
- Screws pass through inside_mount, enclosure wall, and into fan_base

## Changelog

| Date | Change |
|------|--------|
| 2026-01-25 | Initial documentation |
