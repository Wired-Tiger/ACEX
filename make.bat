@echo off
setlocal enabledelayedexpansion

if not exist "@acex" mkdir "@acex"
if not exist "@acex\addons" mkdir "@acex\addons"
if not exist "@acex\optionals" mkdir "@acex\optionals"

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set armake=tools\armake_w64.exe) else (set armake=tools\armake_w32.exe)

for /d %%f in (addons\*) do (
    set folder=%%f
    set name=!folder:addons\=!
    echo   PBO  @acex\addons\acex_!name!.pbo
    !armake! build -w unquoted-string -w redefinition-wo-undef -f !folder! @acex\addons\acex_!name!.pbo
)

for /d %%f in (optionals\*) do (
    set folder=%%f
    set name=!folder:optionals\=!
    echo   PBO  @acex\optionals\acex_!name!.pbo
    !armake! build -w unquoted-string -w redefinition-wo-undef -f !folder! @acex\optionals\acex_!name!.pbo
)

pause
