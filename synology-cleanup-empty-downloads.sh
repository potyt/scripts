#!/bin/sh

set -e

find /volume1/downloads/nzbget/completed -mindepth 2 -type d -empty -delete
