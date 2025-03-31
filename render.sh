#!/bin/bash

compiledscadfile="$1"
jsonfile="$2"
outputbase="$3"

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
  echo "Error: missing parameters.  usage: render.sh {input filename} {json customizer settings} {output filename base}" >&2
  exit 1
fi

# scadfile="$2"
# tag="$3"

# # Define the JSON file path
# extension="${scadfile##*.}"
# filename_no_ext="${scadfile%.$extension}"

# JSON_FILE="${filename_no_ext}.json"

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install jq."
    exit 1
fi

# Extract and loop over the keys of parameterSets
jq -r '.parameterSets | keys[]' "$jsonfile" | while read -r key; do
    echo "Rendering: $key"
    # Perform any additional operations on each key here
    filename="$outputbase-$key-$tag.stl"
    openscad -o "$filename" $compiledscadfile -p "$jsonfile" -P "$key"
done