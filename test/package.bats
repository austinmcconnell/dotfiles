#!/usr/bin/env bats

@test "pyenv" {
    run is-executable pyenv
    [ "$status" -eq 0 ]
}
