@ECHO OFF

:: [===] PACK SOURCE GETTER [===]
::
::  This script will simply execute a couple of program to
:: perform the Minecraft decompilation.
::  Keep in mind decompilation isn't perfect, maybe you need to
:: apply some fixes to make decompiled client to work without bugs.
::
:: Many thanks to md_5 to create SpecialSource and IntelliJ community to create FernFlower.
:: Minecraft is trademark of Mojang AB. Do not distribute.

:: Directory where user files are placed
SET INPUT_DIR=%cd%\input
:: Directory where script write
SET OUTPUT_DIR=%cd%\output
:: Location of necessary files
SET RUNTIME_DIR=%cd%\runtime
:: Temporary FernFlower destination.
SET FLOWER_TMP=%OUTPUT_DIR%\flower

:: Client to decompile
SET GAME_FILE=%INPUT_DIR%\client.jar
:: Mojang's mapping file.
SET PROGUARD_FILE=%INPUT_DIR%\client.txt
:: Converted mapping file (for SpecialSource)
SET SRG_FILE=%OUTPUT_DIR%\client.srg

:: Modified client. It will simply have differents classes name (according to mapping file).
SET NAMED_FILE=%OUTPUT_DIR%\client.jar
:: Location's name of decompiled files.
SET DECOMP_FILENAME=client-src.jar

IF NOT EXIST "%OUTPUT_DIR%" (
	MKDIR "%OUTPUT_DIR%"
)

:: Converting Proguard file to SRG file (SpecialSource work only with SRG files)
ECHO Converting mapping file...
PUSHD "%RUNTIME_DIR%"
java MappingConverter "%PROGUARD_FILE%" "%SRG_FILE%"
POPD
ECHO.

:: Deobfuscate game file
ECHO Running SpecialSource...
java -jar "%RUNTIME_DIR%\SpecialSource.jar" --in-jar "%GAME_FILE%" --out-jar "%NAMED_FILE%" --srg-in "%SRG_FILE%" --kill-lvt
ECHO.

:: Now, decompiling...
ECHO Decompiling (using FernFlower)...
IF NOT EXIST "%FLOWER_TMP%" (MKDIR "%FLOWER_TMP%")
java -jar "%RUNTIME_DIR%\fernflower.jar" -din=1 -rbr=1 -dgs=1 "%NAMED_FILE%" "%FLOWER_TMP%"

:: Rename destination file (FernFlower not allow to rename directly destination file)
RENAME "%FLOWER_TMP%\client.jar" "%DECOMP_FILENAME%"
MOVE "%FLOWER_TMP%\%DECOMP_FILENAME%" "%OUTPUT_DIR%"
RMDIR "%FLOWER_TMP%"

ECHO.
ECHO Finish ! Source file available at "%OUTPUT_DIR%\%DECOMP_FILENAME%".
PAUSE