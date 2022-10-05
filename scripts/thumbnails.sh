#!/usr/bin/bash

render_preview() {
    openscad --autocenter --colorscheme Metallic --imgsize=256,256 -o $1.png $1
}

find -type f -iname *.scad | while read scad ; do
    echo "Generating preview for $scad ..."
    render_preview "$scad"
done