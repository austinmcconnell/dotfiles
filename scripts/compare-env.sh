#!/bin/bash

# Show usage if no arguments provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <example-env-file>"
    echo "Example: $0 .env.example"
    exit 1
fi

EXAMPLE_ENV="$1"
CURRENT_ENV=".env"

# Remove comments and empty lines, then get only variable names before '='
get_vars() {
    grep -v '^#' "$1" | grep -v '^$' | sed 's/=.*//' | sort
}

# Get value for a specific variable from a file
get_value() {
    local file=$1
    local var=$2
    grep "^$var=" "$file" | sed "s/^$var=//"
}

# Check if files exist
if [ ! -f "$CURRENT_ENV" ]; then
    echo "Error: $CURRENT_ENV file not found"
    exit 1
fi

if [ ! -f "$EXAMPLE_ENV" ]; then
    echo "Error: $EXAMPLE_ENV file not found"
    exit 1
fi

echo "Comparing environment variables..."
echo "================================"
echo "Current env file: $CURRENT_ENV"
echo "Example env file: $EXAMPLE_ENV"
echo

# Get variables from both files
env_vars=$(get_vars "$CURRENT_ENV")
example_vars=$(get_vars "$EXAMPLE_ENV")

# Find missing variables in .env
echo "Variables in $EXAMPLE_ENV but missing from $CURRENT_ENV:"
echo "----------------------------------------------"
missing_vars=$(comm -23 <(echo "$example_vars") <(echo "$env_vars"))
if [ -n "$missing_vars" ]; then
    while IFS= read -r var; do
        # Get the example value for the missing variable
        example_val=$(get_value "$EXAMPLE_ENV" "$var")
        echo "  $var (suggested value: $example_val)"
    done <<<"$missing_vars"
else
    echo "  None"
fi

echo

# Find extra variables in .env
echo "Variables in $CURRENT_ENV but not in $EXAMPLE_ENV:"
echo "----------------------------------------"
extra_vars=$(comm -13 <(echo "$example_vars") <(echo "$env_vars"))
if [ -n "$extra_vars" ]; then
    while IFS= read -r var; do
        actual_val=$(get_value "$CURRENT_ENV" "$var")
        echo "  $var (current value: $actual_val)"
    done <<<"$extra_vars"
else
    echo "  None"
fi

echo

# Compare values for variables present in both files
echo "Variables with different values:"
echo "------------------------------"
common_vars=$(comm -12 <(echo "$example_vars") <(echo "$env_vars"))
different_values=0
while IFS= read -r var; do
    example_val=$(get_value "$EXAMPLE_ENV" "$var")
    actual_val=$(get_value "$CURRENT_ENV" "$var")
    if [ "$example_val" != "$actual_val" ]; then
        echo "  $var:"
        echo "    Example value: $example_val"
        echo "    Current value: $actual_val"
        different_values=1
    fi
done <<<"$common_vars"
if [ $different_values -eq 0 ]; then
    echo "  None"
fi
