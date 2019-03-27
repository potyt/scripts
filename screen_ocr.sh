#!/bin/sh

clear
xdotool windowminimize $(xdotool getactivewindow)

SCR_IMG=`mktemp`
trap "rm $SCR_IMG*" EXIT

scrot -s $SCR_IMG.png -q 100
# increase image quality with option -q from default 75 to 100

mogrify -modulate 100,0 -resize 400% $SCR_IMG.png
#should increase detection rate

echo tesseract $SCR_IMG.png $SCR_IMG
tesseract $SCR_IMG.png $SCR_IMG
cat $SCR_IMG.txt
cat $SCR_IMG.txt | xsel -bi

exit
