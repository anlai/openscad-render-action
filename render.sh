#!/bin/bash

compiledscadfile="$1"
scadfile="$2"
tag="$3"

# Define the JSON file path
extension="${scadfile##*.}"
filename_no_ext="${scadfile%.$extension}"

JSON_FILE="${filename_no_ext}.json"

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install jq."
    exit 1
fi

# Extract and loop over the keys of parameterSets
jq -r '.parameterSets | keys[]' "$JSON_FILE" | while read -r key; do
    echo "Rendering: $key"
    # Perform any additional operations on each key here
    filename="$key-$tag.stl"
    openscad -o "$filename" $scadfile -p "$JSON_FILE" -P "$key"
done