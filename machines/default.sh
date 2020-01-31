# shellcheck disable=SC2148
# This script is sourced

# TODO: Check if curl exists. 
function cheatsheet() {
	curl cheat.sh/$1 
}

function google() {
	open https://www.google.com/search\?q=$1
}

# Make directory and change into it.
function mcd() {
  	mkdir -p "$1" && cd "$1";
}

# Pretty print the path
alias paths='echo $PATH | tr -s ":" "\n"'

