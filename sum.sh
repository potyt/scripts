#! /usr/bin/env sh

perl -nle '$sum += $_ } END { print $sum' $1
