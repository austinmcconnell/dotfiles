#!/usr/bin/env bats

load "${DOTFILES_DIR}/etc/zsh/functions/get"
load "${DOTFILES_DIR}/etc/zsh/functions/calc"
load "${DOTFILES_DIR}/etc/zsh/functions/get_trunk_branch"

# shellcheck disable=SC2034
FIXTURE_TEXT="foo"

@test "get" {
    ACTUAL=$(get "FIXTURE_TEXT")
    EXPECTED="foo"
    [ "$ACTUAL" = "$EXPECTED" ]
}

@test "calc" {
    ACTUAL="$(calc 1+2)"
    EXPECTED=3
    [ "$ACTUAL" -eq "$EXPECTED" ]
}

@test "get_trunk_branch" {
    ACTUAL="$(get_trunk_branch)"
    EXPECTED=main
    [ "$ACTUAL" == "$EXPECTED" ]
}
