#! /usr/bin/env zsh

PROG=`basename $0`

USAGE="USAGE: $PROG [-q] [-v] [arg1 [arg2 ...]]

Argument:
    [arg]   arg (default: .)

Options:
    [-h]    show help and exit
    [-q]    quiet
    [-v]    verbose
    [arg1 [arg2 ...]] args
"

# Option defaults
quiet=0
verbose=0
channels=()

# Process options
while getopts ":qvh" opt; do
  case $opt in
    q)
      quiet=1
      ;;
    v)
      verbose=1
      ;;
    h)
      echo $USAGE
      exit 0
      ;;
    \?)
      echo "$PROG: Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# clear the options from the argument string
shift $((OPTIND-1))

# get the arguments
if [ $# -gt 0 ]; then
    args=$@
fi

echo "Hello World! $args"
