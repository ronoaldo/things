#!/usr/bin/bash
set -e

JOBS=""
export_png() {
    echo "Generating preview for $scad ..."
    openscad \
        --autocenter --viewall \
        --colorscheme Metallic \
        --render \
        --imgsize=1024,768 -o $1.png $1 &
    JOB=$!
    echo "Job started with PID: $JOB"
    export JOBS="$JOBS $JOB"
}

export_stl() {
    echo "Generating preview for $scad ..."
    openscad -o ${1/.scad/.stl} $1 &
    JOB=$!
    echo "Job started with PID: $JOB"
    export JOBS="$JOBS $JOB"
}

FILES="$(find -type f -iname *.scad)"
for scad in $FILES ; do
    export_png "$scad"
    export_stl "$scad"
done

echo "Waiting for $JOBS ..."
sleep 1
for pid in $JOBS ; do
    wait $pid || echo "$pid finished"
done
