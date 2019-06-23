#!/usr/bin/env bats

@test "dotfiles" {
	run dotfiles
	[[ $output =~ "Usage" ]]
}

@test "json" {
	ACTUAL=$(echo '{"x":1}' | json)
	EXPECTED=$'{
  "x": 1
}'
	[ "$ACTUAL" = "$EXPECTED" ]
}

@test "is-executable" {
	run is-executable ls
	[ "$status" -eq 0 ]
}

@test "is-executable (false)" {
	run is-executable nonexistent
	[ "$status" -eq 1 ]
}

@test "is-supported" {
	run is-supported ls -a
	[ "$status" -eq 0 ]
}

@test "is-supported (false)" {
	run is-supported "ls --nonexistent"
	[ "$status" -eq 1 ]
}

@test "set-config" {
	echo "********************"
	run set-config KEY_A VALUE_1 MYFILE
	ACTUAL=`cat MYFILE`
	echo "$ACTUAL"
	echo "********************"
	run set-config KEY_B VALUE_2 MYFILE
	ACTUAL=`cat MYFILE`
	echo "$ACTUAL"
	echo "********************"
	run set-config KEY_A VALUE_3 MYFILE
	ACTUAL=`cat MYFILE`
	echo "$ACTUAL"
	echo "********************"
	EXPECTED=$'export KEY_A="VALUE_3"\nexport KEY_B="VALUE_2"'
	# echo "$EXPECTED"
	[ "$ACTUAL" = "$EXPECTED" ]
	run rm MYFILE
}
