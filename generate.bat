@echo off
REM Generate STL and preview images for Film Dryer parts
REM Output files are gitignored - GitHub Actions pipeline generates them

set OPENSCAD="C:\Program Files\OpenSCAD\openscad.exe"
set OUTPUT_DIR=output

echo Creating output directory...
if not exist %OUTPUT_DIR% mkdir %OUTPUT_DIR%

echo.
echo === Generating Filter Cap ===
echo Rendering STL...
%OPENSCAD% -o %OUTPUT_DIR%\filter_cap.stl filter_cap.scad
echo Rendering preview image...
%OPENSCAD% -o %OUTPUT_DIR%\filter_cap.png --autocenter --viewall --imgsize=800,600 filter_cap.scad
echo Rendering bottom view...
%OPENSCAD% -o %OUTPUT_DIR%\filter_cap_bottom.png --autocenter --viewall --imgsize=800,600 --camera=0,0,0,180,0,0,600 filter_cap.scad

echo.
echo === Generating Fan Base ===
echo Rendering STL...
%OPENSCAD% -o %OUTPUT_DIR%\fan_base.stl fan_base.scad
echo Rendering preview image...
%OPENSCAD% -o %OUTPUT_DIR%\fan_base.png --autocenter --viewall --imgsize=800,600 fan_base.scad
echo Rendering top view...
%OPENSCAD% -o %OUTPUT_DIR%\fan_base_top.png --autocenter --viewall --imgsize=800,600 --camera=0,0,0,0,0,0,600 fan_base.scad

echo.
echo === Generating Assembly Preview ===
echo Rendering assembly image...
%OPENSCAD% -o %OUTPUT_DIR%\assembly.png --autocenter --viewall --imgsize=1024,768 assembly.scad

echo.
echo === Done ===
echo Output files in %OUTPUT_DIR%\
dir /b %OUTPUT_DIR%
