#!/bin/bash

# input variables
SCADFILE=$1
TAG=$2

# generated variables
BASE_FILENAME=$(basename "${SCADFILE%.*}")
VERSION="${TAG:-$(date +"%Y%m%d-%H")}"
VERSIONED_BASE_FILENAME="$BASE_FILENAME-$VERSION"
OUTPUT_FILENAME="$VERSIONED_BASE_FILENAME.scad"



# DEBUG OUTPUT
# echo "scadfile: $SCADFILE"
# echo "tag: $TAG"
# echo "base filename: $BASE_FILENAME"
# echo "version: $VERSION"
# echo "versioned filename: $VERSIONED_BASE_FILENAME"

# compile
echo "=== compilation ==="
./compile "$SCADFILE" "$OUTPUT_FILENAME"

# render
echo "=== render ==="
SETTINGS_FILENAME="${SCADFILE%.*}.json"
./render.sh "$OUTPUT_FILENAME" "$SETTINGS_FILENAME" "$VERSIONED_BASE_FILENAME"

echo "=== move artifacts ==="
mkdir ./output
mv $VERSIONED_BASE_FILENAME* ./output

ls
ls ./output