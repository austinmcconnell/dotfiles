#!/usr/bin/env bats

@test "verify vim version"
{
    run bash -c "vim --version | head -1 | cut -d ' ' -f 5"
    [ "$output" = "9.0" ]
}
