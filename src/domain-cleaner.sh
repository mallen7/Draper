#!/bin/bash

source ./env.sh

# Grabbing PID variable
export pid=$(cat ./work/${proj_name}/pid.txt)

# The filename is the first argument
export filename=$1
export proj_name=$2

# Replace these with your actual file paths
export input_file="../work/${proj_name}/dirty_${pid}.csv"
export temp_file="../work/${proj_name}/temp_${pid}.csv"
export output_file="../work/${proj_name}/clean_${pid}.csv"

# Check if a filename is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Preprocess the input file to extract domain names
sed -E 's#http(s)?://([^/]+).*#\2#g' "$input_file" > "$temp_file"

# Regular expression for simple domain validation
regex='^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$'

# Filtering valid domains
egrep "$regex" "$temp_file" > "$output_file"

echo "Filtered domains saved to $output_file"