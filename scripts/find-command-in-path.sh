#!/bin/bash

if [ $# -eq 0 ]; then
    echo -e "\033[31mError: Please provide a command name to search for\033[0m"
    echo "Usage: $0 <command_name>"
    exit 1
fi

command_name="$1"

IFS=':' read -ra PATH_DIRS <<<"$PATH"

echo -e "\033[1mSearching for $command_name in PATH directories:\033[0m"
echo "----------------------------------------"

found=0
for dir in "${PATH_DIRS[@]}"; do
    if [ -x "$dir/$command_name" ]; then
        echo -e "\033[32m✓ Found: $dir/$command_name\033[0m"
        found=1
    else
        echo -e "\033[31m✗ Not found in: $dir\033[0m"
    fi
done

if [ $found -eq 1 ]; then
    echo -e "\n\033[1mFirst $command_name in PATH:\033[0m"
    which "$command_name"
fi
