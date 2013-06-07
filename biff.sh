#! /bin/sh

for dir in ~/mail/*; do
    biff="$dir/biff.txt"
    if [ -r "$biff" -a -f "$biff" ]; then
        biffname=`cat $biff`
    else
        biffname=`basename $dir`
    fi
    printf " $biffname: "
    chk4mail -c -d "$dir" -e "Trash" -l \
        | sed -e "s/^.* \([-0-9]\+\) \+new.*$/\1/g" \
        | sed -e "s/-/0/g" \
        | paste -sd+ \
        | bc
done | grep -v 0 | paste -sd" "
