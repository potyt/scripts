#! /bin/sh

tr -d '\n' - | sed -e 's/\s*//g' | sed -e 's/\/.*\///g' | fold -w 21
