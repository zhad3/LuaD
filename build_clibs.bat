@echo off
set OLD_CD=%CD%

set PACKAGE_DIR=%~1
set ARCH=%DUB_ARCH%
set BUILD_TYPE=%DUB_BUILD_TYPE%

echo PACKAGE_DIR=%PACKAGE_DIR%
echo ARCH=%ARCH%
echo BUILD_TYPE=%BUILD_TYPE%

set DEST_DIR=%PACKAGE_DIR%\c\build\%ARCH%-%BUILD_TYPE%
echo DEST_DIR=%DEST_DIR%

IF NOT EXIST "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
)

IF EXIST "%DEST_DIR%\liblua5.1.lib" IF "%DUB_FORCE%"=="" (
    exit /b 0
)

IF NOT DEFINED VSINSTALLDIR (
    echo Visual Studio wasn't found. Make sure you run the command from Visual Studio or using the Visual Studio Developer Console.
    exit /b 1
)


IF "%BUILD_TYPE%"=="debug" (set CL_OPTS=/Zi /nologo /w /WX- /Od /Oi /D _DEBUG /D _WINDOWS /D _MBCS /EHsc /Fd"liblua.pdb")
IF "%BUILD_TYPE%"=="release" (set CL_OPTS=/Zi /nologo /w /WX- /Ox /Oi /D NDEBUG /D _WINDOWS /D _MBCS /EHsc)

cd /d "%PACKAGE_DIR%\c\lua5.1.5\src"
echo CD=%CD%

set LUA_A=liblua5.1.lib

set CORE_C=lapi.c lcode.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c lmem.c ^
lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c ^
lundump.c lvm.c lzio.c
set LIB_C=lauxlib.c lbaselib.c ldblib.c liolib.c lmathlib.c loslib.c ltablib.c ^
lstrlib.c loadlib.c linit.c

set CORE_O=lapi.obj lcode.obj ldebug.obj ldo.obj ldump.obj lfunc.obj lgc.obj llex.obj lmem.obj ^
lobject.obj lopcodes.obj lparser.obj lstate.obj lstring.obj ltable.obj ltm.obj ^
lundump.obj lvm.obj lzio.obj
set LIB_O=lauxlib.obj lbaselib.obj ldblib.obj liolib.obj lmathlib.obj loslib.obj ltablib.obj ^
lstrlib.obj loadlib.obj linit.obj

cl.exe /c %CL_OPTS% %CORE_C% %LIB_C%
lib.exe /nologo /out:"%DEST_DIR%\%LUA_A%" %CORE_O% %LIB_O%

IF "%BUILD_TYPE%"=="debug" (move "%PACKAGE_DIR%\c\lua5.1.5\src\liblua.pdb" "%DEST_DIR%\liblua.pdb")

cd /d "%OLD_CD%"