#! /usr/bin/env bash

perl -nle '$sum += $_ } END { print $sum' $1
