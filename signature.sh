#! /usr/bin/env sh

script=`basename $0`
fortune=$1

base=${script%.*}
fortune ~/fortune/$fortune
printf "  // %s\n" `cat ~/.signature/$base`
