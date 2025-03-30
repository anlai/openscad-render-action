#!/bin/bash

# Parameters
inputFile="$1"
tag="${2:-$(date +"%Y%m%d-%H")}"

echo "Compiling file: $inputFile with tag $tag"
echo ""

line_pattern='(include|use)\s*<(.+?)>'
comment_pattern='^\s*//'

pathRoot=$(dirname "$0")
inputFilename=$(basename "$1")
dependencies=()

function find_dependencies {
    local path=$1
    local file=$2
    local depth=$3

    local nextDepth=$((depth+1))

    while IFS= read -r line; do
        if ! [[ $line =~ $comment_pattern ]] && [[ $line =~ $line_pattern ]]; then
            depFilename="${BASH_REMATCH[2]}"
            filedir=$(dirname "$depFilename")
            depFilename=$(basename "$depFilename")
            if [[ $filedir == "." ]]; then
                dir="$path"
            else
                dir="$path/$filedir"
            fi

            dependencies+=("{\"path\":\"$dir/$depFilename\",\"depth\":$depth}")
            find_dependencies $dir $depFilename $nextDepth
        fi
    done < "$path/$file"
}

function process_file {
    local filepath=$1
    local outputPath=$2
    local customizer=$3

    local srcFilename=$(basename "$filepath")

    echo "// ======" >> "$outputPath"
    if [[ $customizer == true ]]; then    
        echo "// $srcFilename -- parameters" >> "$outputPath"
    else
        echo "// $srcFilename" >> "$outputPath"
    fi
    echo "// ======" >> "$outputPath"

    local write=$customizer

    if [[ $customizer == false ]] && ! grep -q "module __Customizer_Limit__ () {}" "$filepath"; then
        write=true
    fi

    while IFS= read -r line; do
        if [[ $customizer == true ]] && [[ $line == "module __Customizer_Limit__ () {}" ]]; then
            echo "$line" >> "$outputPath"
            break
        elif [[ $customizer == false ]] && [[ $line == "module __Customizer_Limit__ () {}" ]]; then
            write=true
            continue
        fi

        if ! [[ $line =~ $line_pattern ]] && [[ $write == true ]]; then
            echo "$line" >> "$outputPath"
        fi
    done < "$filepath"
}

function addd_empty_line {
    local filepath=$1

    # Check if the last line is empty
    if [ -n "$(tail -c 1 "$filepath")" ]; then
        echo "" >> "$filepath"
    fi
}

find_dependencies $pathRoot $inputFile 0

echo "==output=="
outputFilename=$(echo "$inputFilename" | sed 's/\.[^.]*$//')
outputPath="$outputFilename-$tag.scad"

sorted=$(printf "%s\n" "${dependencies[@]}" | jq -s 'sort_by(.depth) | reverse | unique_by(.path) | .[].path')

addd_empty_line "$inputFile"
process_file "$inputFile" "$outputPath" true
for f in $sorted; do
    unquoted=${f//\"/}
    addd_empty_line "$unquoted"
    process_file "$unquoted" "$outputPath" false
done
process_file "$inputFile" "$outputPath" false

echo "result written to: $outputPath"
echo "done"