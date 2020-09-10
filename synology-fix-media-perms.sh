#!/bin/sh

set -e

chown -R sc-headphones.headphones /volume1/musik/incoming
chmod -R ug+rw /volume1/musik/incoming
chmod -R o-w /volume1/musik/incoming
find /volume1/musik/incoming -type f -exec chmod a-x {} \;
find /volume1/musik/incoming/lossless -type f -name "*.flac" -exec chmod a+x {} \;
find /volume1/musik/incoming/encoded -type f -name "*.ogg" -exec chmod a+x {} \;
find /volume1/musik/incoming/encoded -type f -name "*.m4a" -exec chmod a+x {} \;
find /volume1/musik/incoming/encoded -type f -name "*.mp3" -exec chmod a+x {} \;
find /volume1/musik/incoming/encoded -type f -name "*.aac" -exec chmod a+x {} \;

chown -R sc-sickbeard-custom.sickbeard-custom /volume1/videos/TV
chmod -R ug+rw /volume1/videos/TV
chmod -R o-w /volume1/videos/TV
find /volume1/videos/TV -type f -exec chmod a-x {} \;
find /volume1/videos/TV -type f -name "*.jpg" -exec chmod a+x {} \;
find /volume1/videos/TV -type f -name "*.mkv" -exec chmod a+x {} \;
find /volume1/videos/TV -type f -name "*.tbn" -exec chmod a+x {} \;

chown -R sc-couchpotatoserver.couchpotatoserver /volume1/videos/Movies
chmod -R ug+rw /volume1/videos/Movies
chmod -R o-w /volume1/videos/Movies
find /volume1/videos/Movies -type f -exec chmod a-x {} \;
find /volume1/videos/Movies -type f -name "*.jpg" -exec chmod a+x {} \;
find /volume1/videos/Movies -type f -name "*.mkv" -exec chmod a+x {} \;
