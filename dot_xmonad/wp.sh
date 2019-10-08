#!/bin/bash
shopt -s nullglob

TGTDIR="$HOME/Dropbox/kabegami"
test -d "$TGTDIR" || {
    TGTDIR="$HOME/.xmonad/wps"
}
cd "$TGTDIR"


FILES=()
for i in *.jpg *.png; do
    [[ -f $i ]] && FILES+=("$i")
done
RANGE=${#FILES[@]}
NUM_C=$(ls "$TGTDIR"| wc -l)


PICNUM=$(( $(od -vAn -N4 -tu4 < /dev/random) % $RANGE ))
while true; do
    ((RANGE)) && feh --bg-fill "$TGTDIR/${FILES[$PICNUM]}"
    if [ $$ -ne $(pgrep -fo "$0") ]; then
        exit 1
    fi
    [ $NUM_C -eq $(ls "$TGTDIR"|wc -l) ] || {
        FILES=()
        for i in *.jpg *.png; do
            [[ -f $i ]] && FILES+=("$i")
        done
        RANGE=${#FILES[@]}
        NUM_C=$(ls "$TGTDIR"| wc -l)
    }
    PICNUM=$(( $(od -vAn -N4 -tu4 < /dev/random) % $RANGE ))
    sleep 10m
done

