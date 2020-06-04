#!/bin/sh

set -e

find /volume1/downloads/nzbget/completed/Movies -mindepth 1 -type d -empty -delete
find /volume1/downloads/nzbget/completed/Music -mindepth 1 -type d -empty -delete
find /volume1/downloads/nzbget/completed/TV -mindepth 1 -type d -empty -delete
