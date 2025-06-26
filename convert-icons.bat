@echo off
setlocal EnableDelayedExpansion

REM === Set paths ===
set "SVG_DIR=SVG"
set "PNG_DIR=PNG"
set "ICO_DIR=ICO"
set "INKSCAPE=C:\Program Files\Inkscape\bin\inkscape.exe"

mkdir "%PNG_DIR%" 2>nul
mkdir "%ICO_DIR%" 2>nul

echo Starting conversion...

REM === Loop through SVG files ===
for %%F in ("%SVG_DIR%\*.svg") do (
    REM Extract base name directly inside the loop
    for %%G in ("%%~nF") do (
        set "baseName=%%~nG"
        set "svgFile=%%~fF"

        echo.
        echo Processing !baseName!...

        REM ---- PNG ----
        if exist "%PNG_DIR%\!baseName!.png" (
            echo Skipping PNG: !baseName!.png already exists.
        ) else (
            echo Creating PNG: !baseName!.png
            "%INKSCAPE%" "!svgFile!" --export-type=png --export-width=1000 --export-height=1000 --export-filename="%PNG_DIR%\!baseName!.png"
        )

        REM ---- ICO ----
        if exist "%ICO_DIR%\!baseName!.ico" (
            echo Skipping ICO: !baseName!.ico already exists.
        ) else (
            echo Creating ICO: !baseName!.ico
            "%INKSCAPE%" "!svgFile!" --export-type=png --export-width=256 --export-height=256 --export-filename="%ICO_DIR%\!baseName!-temp.png"
            magick "%ICO_DIR%\!baseName!-temp.png" -define icon:auto-resize="256" "%ICO_DIR%\!baseName!.ico"
            del "%ICO_DIR%\!baseName!-temp.png"
        )
    )
)

echo.
echo All conversions done!
pause
