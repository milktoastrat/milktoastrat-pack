@echo off
setlocal EnableDelayedExpansion

REM === Set folder paths ===
set "SVG_DIR=SVG"
set "PNG_DIR=PNG"
set "ICO_DIR=ICO"

REM === Set Inkscape executable path ===
set "INKSCAPE_PATH=C:\Program Files\Inkscape\bin\inkscape.exe"

REM === Make output folders if they don't exist ===
mkdir "%PNG_DIR%" 2>nul
mkdir "%ICO_DIR%" 2>nul

REM === Loop through SVGs ===
for %%f in ("%SVG_DIR%\*.svg") do (
    set "svgFile=%%f"
    set "baseName=%%~nf"
    call :process
)

echo.
echo All done!
pause
exit /b

:process
REM === Generate PNG ===
if exist "%PNG_DIR%\!baseName!.png" (
    echo Skipping PNG for !baseName! (already exists)
) else (
    echo Creating PNG for !baseName!...
    "%INKSCAPE_PATH%" "!svgFile!" --export-type=png --export-width=1000 --export-height=1000 --export-filename="%PNG_DIR%\!baseName!.png"
)

REM === Generate ICO (via Inkscape to PNG, then convert to ICO) ===
if exist "%ICO_DIR%\!baseName!.ico" (
    echo Skipping ICO for !baseName! (already exists)
) else (
    echo Creating ICO for !baseName!...
    "%INKSCAPE_PATH%" "!svgFile!" --export-type=png --export-width=256 --export-height=256 --export-filename="%ICO_DIR%\!baseName!-temp.png"
    magick "%ICO_DIR%\!baseName!-temp.png" -define icon:auto-resize="256" "%ICO_DIR%\!baseName!.ico"
    del "%ICO_DIR%\!baseName!-temp.png"
)

exit /b

