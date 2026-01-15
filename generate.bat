@echo off
REM Generate STL and preview images for Film Dryer parts
REM Output files are gitignored - GitHub Actions pipeline generates them

set OPENSCAD="C:\Program Files\OpenSCAD\openscad.exe"
set OUTPUT_DIR=output

echo Creating output directories...
if not exist %OUTPUT_DIR%\stl mkdir %OUTPUT_DIR%\stl
if not exist %OUTPUT_DIR%\images mkdir %OUTPUT_DIR%\images

REM Process all SCAD files
for %%f in (*.scad) do (
    echo.
    echo === Processing %%~nf ===

    echo   Building STL...
    %OPENSCAD% -o %OUTPUT_DIR%\stl\%%~nf.stl "%%f"

    echo   Rendering isometric view...
    %OPENSCAD% -o %OUTPUT_DIR%\images\%%~nf_isometric.png ^
        --camera=0,0,0,55,0,25,0 ^
        --autocenter --viewall ^
        --imgsize=1024,1024 ^
        --colorscheme=Tomorrow ^
        "%%f"

    echo   Rendering isometric flipped view...
    %OPENSCAD% -o %OUTPUT_DIR%\images\%%~nf_isometric_flipped.png ^
        --camera=0,0,0,55,0,205,0 ^
        --autocenter --viewall ^
        --imgsize=1024,1024 ^
        --colorscheme=Tomorrow ^
        "%%f"

    echo   Done with %%~nf
)

echo.
echo === Build Complete ===
echo.
echo STL files:
dir /b %OUTPUT_DIR%\stl\*.stl 2>nul || echo   No STL files generated
echo.
echo Image files:
dir /b %OUTPUT_DIR%\images\*.png 2>nul || echo   No images generated
