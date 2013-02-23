#! /usr/bin/env zsh

PROG=$0

USAGE='USAGE: $PROG [-q] [-v] [ch1 [ch2 ...]]

Argument:
    [foo]   file or folder (default: current directory)

Options:
    [-h]    Show help and exit
    [-q]    Quiet
    [-v]    Verbose, otherwise output from mbsync is quiet
    [ch1 [ch2 ...]] Channels
'

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

# set the folders or files if given as arguments
if [ $# -gt 0 ]; then
    channels=$@
fi
