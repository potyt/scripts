#! /usr/bin/env sh

script=`basename $0`
fortune=$1

base=${script%.*}
[[ -x "$fortune" ]] && fortune ~/.fortune/$fortune || fortune
if [ -e ~/.signature/$base ]; then
    printf "  // %s\n" `cat ~/.signature/$base`
fi
