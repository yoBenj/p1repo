#!/bin/bash

# Define variables
excel_file="p1bugs.csv"
branch_name=$(git rev-parse --abbrev-ref HEAD)
current_time=$(date +"%Y%m%d%H%M%S")

# Check if the CSV file exists
if [ ! -f "$excel_file" ]; then
    echo "CSV file not found!"
    exit 1
fi

# Extract data from the CSV file
bug_id=$(awk -F',' 'NR==2 {print $6}' $excel_file)
dev_name=$(awk -F',' 'NR==2 {print $3}' $excel_file)
priority=$(awk -F',' 'NR==2 {print $2}' $excel_file)
description=$(awk -F',' 'NR==2 {print $5}' $excel_file)

# Generate the commit message
commit_message="${bug_id}:${current_time}:${branch_name}:${dev_name}:${priority}:${description}"

# Check for an additional developer description
if [ -n "$1" ]; then
    commit_message="${commit_message}:$1"
fi

# Perform git operations
git add .
git commit -m "$commit_message"

if git push origin "$branch_name"; then
    echo "Push successful!"
else
    echo "Push failed!"
    exit 1
fi
