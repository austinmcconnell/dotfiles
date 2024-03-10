#!/usr/bin/env bats

# source: https://devguide.python.org/versions/
min_python_version=3.8  # lowest non-end-of-life python version

@test "verify vim version" {
    run bash -c "vim --version | head -1 | cut -d ' ' -f 5"
    [ "$(echo "$output >= 8.0" | bc -l)" -eq 1 ]
}

@test "verify python version" {
    run bash -c "python --version | cut -d ' ' -f 2 | cut -d '.' -f 1,2"

    min_major=$(echo "$min_python_version" | cut -d '.' -f 1)
    min_minor=$(echo "$min_python_version" | cut -d '.' -f 2)

    installed_major=$(echo "$output" | cut -d '.' -f 1)
    installed_minor=$(echo "$output" | cut -d '.' -f 2)

    [ "$(echo "$installed_major >= $min_major" | bc -l)" -eq 1 ]
    [ "$(echo "$installed_minor >= $min_minor" | bc -l)" -eq 1 ]
}
