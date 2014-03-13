#! /usr/bin/env sh

script=`basename $0`
fortune=$1

base=${script%.*}
[[ -z "$fortune" ]] && fortune -s || fortune ~/.fortune/$fortune
if [ -e ~/.signature/$base ]; then
    printf "  // %s\n" `cat ~/.signature/$base`
fi
