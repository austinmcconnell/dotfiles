#!/usr/bin/env bats

load "${DOTFILES_DIR}/system/.function"

FIXTURE=$'foo\nbar\nbaz\nfoo'
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
