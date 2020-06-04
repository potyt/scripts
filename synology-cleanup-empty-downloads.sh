#!/bin/sh

set -e

find /volume1/downloads/nzbget/completed -mindepth 1 -type d -empty -delete
