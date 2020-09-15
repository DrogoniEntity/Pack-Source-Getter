#!/bin/bash

# [===] PACK SOURCE GETTER [===]
#
#  This script will simply execute a couple of program to
# perform the Minecraft decompilation.
#  Keep in mind decompilation isn't perfect, maybe you need to
# apply some fixes to make decompiled client to work without bugs.
#
# Many thanks to md_5 to create SpecialSource and IntelliJ community to create FernFlower.
# Minecraft is trademark of Mojang AB. Do not distribute.

# Directory where user files are placed
INPUT_DIR=$PWD/input
# Directory where script write
OUTPUT_DIR=$PWD/output
# Location of necessary files
RUNTIME_DIR=$PWD/runtime
# Temporary FernFlower destination.
FLOWER_TMP=$PWD/flower

# Client to decompile
GAME_FILE=$INPUT_DIR/client.jar
# Mojang's mapping file.
PROGUARD_FILE=$INPUT_DIR/client.txt
# Converted mapping file (for SpecialSource)
SRG_FILE=$OUTPUT_DIR/client.srg

# Modified client. It will simply have differents classes name (according to mapping file).
NAMED_FILE=$OUTPUT_DIR/client.jar
# Location's name of decompiled files.
DECOMP_FILENAME=client-src.jar

if [ ! -d "$OUTPUT_DIR" ] ; then
	mkdir "$OUTPUT_DIR"
fi

# Converting Proguard file to SRG file (SpecialSource work only with SRG files)
echo "Converting mapping file..."
pushd "$RUNTIME_DIR" > /dev/null
java MappingConverter "$PROGUARD_FILE" "$SRG_FILE"
popd > /dev/null
echo

# Deobfuscate game file
echo Running SpecialSource...
java -jar "$RUNTIME_DIR/SpecialSource.jar" --in-jar "$GAME_FILE" --out-jar "$NAMED_FILE" --srg-in "$SRG_FILE" --kill-lvt
echo

# Now, decompiling...
echo "Decompiling (using FernFlower)..."
if [ ! -d "%FLOWER_TMP%" ] ; then
	mkdir "$FLOWER_TMP"
fi
java -jar "$RUNTIME_DIR/fernflower.jar" -din=1 -rbr=1 -dgs=1 "$NAMED_FILE" "$FLOWER_TMP"

# Rename destination file (FernFlower not allow to rename directly destination file)
mv "$FLOWER_TMP/client.jar" "$OUTPUT_DIR/$DECOMP_FILENAME"
rmdir "$FLOWER_TMP"

echo
echo "Finish ! Source file available at '$OUTPUT_DIR/$DECOMP_FILENAME'."
