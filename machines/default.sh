# shellcheck disable=SC2148
# This script is sourced

# TODO: Check if curl exists. 
cheatsheet() {
	curl cheat.sh/$1 
}

google() {
	open https://www.google.com/search\?q=$1
}
